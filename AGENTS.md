# ZamzamKit — Agent Guide

Open-source Swift package (github.com/ZamzamInc/ZamzamKit, MIT) of micro utilities and extensions over the standard library, Foundation, and native Apple frameworks, meant to be consumed by any Apple app or package. Default branch: `main`.

## Layout

Pure SPM, `swift-tools-version: 5.7`, platforms macOS 12 / iOS 15 / tvOS 15 / watchOS 8. No external dependencies. Five library products:

- `ZamzamCore` — application helpers, errors, extensions, infix operators, keychain, logging, network, utilities
- `ZamzamLocation` — location services (depends on ZamzamCore)
- `ZamzamNotification` — user notifications (depends on ZamzamCore)
- `ZamzamUI` — SwiftUI extensions, platform shims, sheets, styles, views (depends on ZamzamCore)
- `ZamzamKit` — umbrella of the four

## Build & test

```sh
swift build
swift test
```

In Xcode, the shared `ZamzamKit-Package` scheme runs `Package.xctestplan` at the package root, with code coverage on for the four library targets. Agents driving Xcode through its MCP server open this package directory as a workspace and run the plan; sandboxed shells cannot run SwiftPM directly (it needs caches outside the sandbox).

Tests live flat in `Tests/` (the `ZamzamKitTests` target has `path: "Tests"`; XCTest; `TestUtilities.swift` is the shared helper; `Resources/` is a processed resource bundle; `Network/Certificates` is excluded from compilation). Match the existing XCTest style — the 5.7 tools version predates Swift Testing. Bug fixes land with a failing test first.

Known environmental failures (not regressions): `NetworkServerTrustTests` uses certificate fixtures that have expired, `FileTests.testDownloadFile` performs a live download, and `CurrencyFormatterTests.testSA` asserts an Arabic format whose right-to-left mark placement changed with ICU.

## Compatibility contract

Consumers may depend on this package by version or by tracking `main`, so treat every push to `main` as a release: the suite must pass first, and a change to public API is a breaking change until every product that exposes it is considered. Prefer additive changes; when something public must change, deprecate first where practical and call the break out in the commit message.

## Conventions

- Public API is documented with a short doc comment and, where behavior is not obvious, an example in the README section for its product.
- Extensions are grouped by the type they extend, one file per type, under the product that owns the dependency (Foundation-only code in `ZamzamCore`, SwiftUI in `ZamzamUI`, and so on).
- No third-party dependencies: the package's value is being a thin, dependency-free layer.
