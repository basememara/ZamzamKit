#!/bin/sh
# Regenerates the alamofire.org test certificate chain used by NetworkServerTrustTests.
#
# Apple's TLS policy rejects server certificates valid for more than 825 days, so the
# leaf certificates expire roughly every two years. Re-run this script (OpenSSL 3.x) and
# commit the .cer files; the private keys are throwaway.
#
#   sh Tests/Network/Certificates/generate.sh
set -eu

OUT=$(cd "$(dirname "$0")/alamofire.org" && pwd)
WORK=$(mktemp -d "${TMPDIR:-/tmp}/certgen.XXXXXX")
trap 'rm -rf "$WORK"' EXIT
cd "$WORK"

SUBJECT_BASE="/C=US/ST=Oregon/L=Portland/O=Alamofire/OU=Test/emailAddress=test@alamofire.org"
LEAF_DAYS=800
NOT_BEFORE=$(date -u +%Y%m%d000000Z)

ca_ext() {
    printf 'basicConstraints=critical,CA:TRUE\nkeyUsage=critical,keyCertSign,cRLSign\nsubjectKeyIdentifier=hash\nauthorityKeyIdentifier=keyid:always\n'
}

leaf_ext() { # $1 = subjectAltName value or empty
    printf 'basicConstraints=critical,CA:FALSE\nkeyUsage=critical,digitalSignature,keyEncipherment\nextendedKeyUsage=serverAuth\nsubjectKeyIdentifier=hash\nauthorityKeyIdentifier=keyid:always\n'
    if [ -n "$1" ]; then printf 'subjectAltName=%s\n' "$1"; fi
}

key() { openssl genrsa -out "$1.key" 2048 2>/dev/null; }

# root
key root
openssl req -x509 -new -key root.key -sha256 -days 9125 -subj "$SUBJECT_BASE/CN=Alamofire Root CA" \
    -addext "basicConstraints=critical,CA:TRUE" -addext "keyUsage=critical,keyCertSign,cRLSign" -out root.pem
openssl x509 -in root.pem -outform DER -out "$OUT/alamofire-root-ca.cer"

# intermediates
for n in 1 2; do
    key ca$n
    openssl req -new -key ca$n.key -sha256 -subj "$SUBJECT_BASE/CN=Alamofire Signing CA$n" -out ca$n.csr
    ca_ext > ca$n.ext
    openssl x509 -req -in ca$n.csr -CA root.pem -CAkey root.key -CAcreateserial -sha256 -days 7300 -extfile ca$n.ext -out ca$n.pem
    openssl x509 -in ca$n.pem -outform DER -out "$OUT/alamofire-signing-ca$n.cer"
done

# leaf NAME CA CN SAN [not_before not_after]
leaf() {
    name=$1; ca=$2; cn=$3; san=$4; nb=${5:-$NOT_BEFORE}; na=${6:-}
    key "$name"
    openssl req -new -key "$name.key" -sha256 -subj "$SUBJECT_BASE/CN=$cn" -out "$name.csr"
    leaf_ext "$san" > "$name.ext"
    if [ -n "$na" ]; then
        openssl x509 -req -in "$name.csr" -CA "$ca.pem" -CAkey "$ca.key" -CAcreateserial -sha256 -not_before "$nb" -not_after "$na" -extfile "$name.ext" -out "$name.pem"
    else
        openssl x509 -req -in "$name.csr" -CA "$ca.pem" -CAkey "$ca.key" -CAcreateserial -sha256 -not_before "$nb" -days $LEAF_DAYS -extfile "$name.ext" -out "$name.pem"
    fi
    openssl x509 -in "$name.pem" -outform DER -out "$OUT/$name.cer"
}

# signed by CA1
leaf wildcard.alamofire.org ca1 "*.alamofire.org" "DNS:*.alamofire.org"
leaf multiple-dns-names      ca1 "Multiple DNS Names" "DNS:test.alamofire.org,DNS:blog.alamofire.org,DNS:www.alamofire.org"
leaf signed-by-ca1           ca1 "Signed by CA1" "DNS:test.alamofire.org"
leaf test.alamofire.org      ca1 "test.alamofire.org" "URI:test.alamofire.org,DNS:test.alamofire.org"

# signed by CA2
leaf expired                  ca2 "Expired" "DNS:test.alamofire.org" 20150101000000Z 20160101000000Z
leaf missing-dns-name-and-uri ca2 "Missing DNS Name and URI" ""
leaf signed-by-ca2            ca2 "Signed by CA2" "DNS:test.alamofire.org"
leaf valid-dns-name           ca2 "Valid DNS Name" "DNS:test.alamofire.org"
leaf valid-uri                ca2 "Valid URI" "URI:test.alamofire.org"

for f in "$OUT"/*.cer; do
    printf '%-32s %s\n' "$(basename "$f")" "$(openssl x509 -inform DER -in "$f" -noout -enddate)"
done
