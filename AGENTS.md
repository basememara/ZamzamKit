# ZamzamKit — Agent Guide

Open-source Swift package (github.com/ZamzamInc/ZamzamKit) of micro utilities and extensions over the standard library, Foundation, and native frameworks. It is the foundation under every Apple app Basem builds: PrayKit and PrayWatch consume it, and both track its `main` branch. Default branch: `main`.

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

Sandboxed Bash cannot run these (SwiftPM needs `/var/folders` caches the seatbelt blocks) — use Apple's Xcode MCP (`xcode` server): `XcodeOpenWorkspace` on this package directory, then `RunAllTests` (scheme `ZamzamKit-Package`, plan `Package.xctestplan` at the root, code coverage on for the four library targets).

Tests live flat in `Tests/` (the `ZamzamKitTests` target has `path: "Tests"`; XCTest; `TestUtilities.swift` is the shared helper; `Resources/` is a processed resource bundle; `Network/Certificates` is excluded from compilation). Match the existing XCTest style — the 5.7 tools version predates Swift Testing. Bug fixes land with a failing test first.

## Consumers

PrayKit and PrayWatch depend on this package as a **remote branch dep** (`branch: main`), so pushing to `main` here is effectively publishing to both. Keep `main` green: the suite must pass before any push. A breaking API change needs matching PrayKit/PrayWatch changes in the same sitting; check both before renaming or removing anything public.

## Skills

When working ZamzamKit alongside the PrayWatch checkout, load the relevant vetted skill from `PrayWatch/.claude/skills/` before starting: `swift-testing-pro` (tests), `swift-concurrency-pro` (async/actors/Sendable), `swiftui-performance-audit` (ZamzamUI).
