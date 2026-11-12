//
//  EchoURLProtocol.swift
//  ZamzamKitTests
//
//  Created by Basem Emara on 2026-11-12.
//  Copyright © 2026 Zamzam Inc. All rights reserved.
//

import Foundation

/// Answers every request of a session itself, so the network tests never leave the process.
///
/// The response is derived from the request alone, which keeps parallel tests independent:
/// - any URL gets a `200` with a JSON body echoing the request's `url`, query `args`, `headers` and `json` body;
/// - a path of `/status/<code>` answers with that status code instead;
/// - the host `offline.test` fails with `URLError.notConnectedToInternet`.
final class EchoURLProtocol: URLProtocol {
    override static func canInit(with request: URLRequest) -> Bool { true }
    override static func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let url = request.url, url.host() != "offline.test" else {
            client?.urlProtocol(self, didFailWithError: URLError(.notConnectedToInternet))
            return
        }

        let statusCode = url.pathComponents.dropFirst().first == "status"
            ? url.pathComponents.last.flatMap(Int.init) ?? 200
            : 200

        guard let data = try? JSONSerialization.data(withJSONObject: echo(of: url)),
              let response = HTTPURLResponse(
                url: url,
                statusCode: statusCode,
                httpVersion: "HTTP/1.1",
                headerFields: ["Content-Type": "application/json"]
              )
        else {
            client?.urlProtocol(self, didFailWithError: URLError(.cannotParseResponse))
            return
        }

        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

extension URLSessionConfiguration {
    /// A configuration whose requests are all answered by `EchoURLProtocol`.
    static var echo: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [EchoURLProtocol.self]
        return configuration
    }
}

private extension EchoURLProtocol {
    func echo(of url: URL) -> [String: Any] {
        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []

        // A session hands a protocol the body as a stream, never as `httpBody`
        let body = request.httpBodyStream.map(Data.init(reading:))

        return [
            "url": url.absoluteString,
            "args": Dictionary(queryItems.map { ($0.name, $0.value ?? "") }) { $1 },
            "headers": request.allHTTPHeaderFields ?? [:],
            "json": body.flatMap { try? JSONSerialization.jsonObject(with: $0) } ?? NSNull()
        ]
    }
}

private extension Data {
    init(reading stream: InputStream) {
        stream.open()
        defer { stream.close() }

        let bufferSize = 4_096
        var buffer = [UInt8](repeating: 0, count: bufferSize)
        var data = Data()

        while stream.hasBytesAvailable {
            let count = stream.read(&buffer, maxLength: bufferSize)
            guard count > 0 else { break }
            data.append(buffer, count: count)
        }

        self = data
    }
}
