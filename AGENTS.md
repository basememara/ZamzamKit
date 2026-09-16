# ZamzamKit — Agent Guide

Open-source Swift package (github.com/ZamzamInc/ZamzamKit, MIT) of micro utilities and extensions over the standard library, Foundation, and native Apple frameworks, meant to be consumed by any Apple app or package. Default branch: `main`.

## Layout

Pure SPM, `swift-tools-version: 6.0`, platforms macOS 12 / iOS 15 / tvOS 15 / watchOS 8. Every library target builds in the **Swift 6 language mode** under strict concurrency; the test target stays in `.v5` because `AtomicTests` and `LimiterTests` deliberately exercise shared mutable state that the Swift 6 checker rejects. Keep new code Sendable-correct rather than reaching for `@unchecked`: the existing unchecked conformances each carry a comment naming the invariant that makes them safe. No external dependencies. Five library products:

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

Tests live flat in `Tests/` (the `ZamzamKitTests` target has `path: "Tests"`; **Swift Testing**; `TestUtilities.swift` is the shared helper; `Resources/` is a processed resource bundle; `Network/Certificates` is excluded from compilation). Suites are structs and tests are `@Test` functions; Swift Testing builds a fresh instance per test and runs them in parallel, so a suite must not share mutable state. Two files stay on XCTest for stated reasons: `AtomicTests` uses `measure`, which has no Swift Testing equivalent, and `LimiterTests` asserts real elapsed time while mutating values captured by the limiter's closures. Both live happily in the same target. The test target stays in Swift 5 mode for the same reason, which is why `Package.swift` says so.

Use `try #require` before comparing an optional, and hoist a `try` out of a comparison: `#expect(a == try #require(b))` does not parse. `#expect` has no tolerance form, so write `#expect(abs(a - (b)) <= tolerance)`. Bug fixes land with a failing test first.

Known environmental failures are wrapped in `withKnownIssue`, so the suite reports them as expected failures and a real regression still turns the run red: nine `NetworkServerTrustTests` evaluations against expired certificate fixtures, `FileTests.downloadFile` (a live download), and `CurrencyFormatterTests.sA` (an Arabic format whose right-to-left mark placement changed with ICU). Re-cutting the fixtures would retire the first group.

## Compatibility contract

Consumers may depend on this package by version or by tracking `main`, so treat every push to `main` as a release: the suite must pass first, and a change to public API is a breaking change until every product that exposes it is considered. Prefer additive changes; when something public must change, deprecate first where practical and call the break out in the commit message.

## Conventions

- Public API is documented with a short doc comment and, where behavior is not obvious, an example in the README section for its product.
- Extensions are grouped by the type they extend, one file per type, under the product that owns the dependency (Foundation-only code in `ZamzamCore`, SwiftUI in `ZamzamUI`, and so on).
- No third-party dependencies: the package's value is being a thin, dependency-free layer.

## Skills

Vetted third-party agent skills live in `.claude/skills/` (MIT; each folder is a copy of its upstream skill's `SKILL.md`, `references/`, and Codex `agents/` metadata, without the marketplace scaffolding). Harnesses with native skill support trigger them automatically; any other agent should read the relevant `SKILL.md` (and only the reference files it points to) before touching that area:

| Before working on… | Read | Upstream |
|---|---|---|
| Any public API: names, argument labels, doc comments, overloads | `.claude/skills/swift-api-design-guidelines-skill/SKILL.md` | [Erik Sebastián de Erice](https://github.com/Erikote04/Swift-API-Design-Guidelines-Agent-Skill), the Swift API Design Guidelines distilled |
| Concurrency: async/await, actors, `Sendable`, Swift 6 diagnostics | `.claude/skills/swift-concurrency-pro/SKILL.md` | [Paul Hudson](https://github.com/twostraws/Swift-Concurrency-Agent-Skill) |
| Formatting values for display: numbers, currency, dates, durations, measurements | `.claude/skills/swift-format-style/SKILL.md` | [Anton Novoselov](https://github.com/n0an/Swift-FormatStyle-Agent-Skill) |
| `ZamzamUI` views, styles, sheets, platform shims | `.claude/skills/swiftui-pro/SKILL.md` | [Paul Hudson](https://github.com/twostraws/SwiftUI-Agent-Skill) |
| Tests: suites, `#expect`, `withKnownIssue`, parallel-safety | `.claude/skills/swift-testing-pro/SKILL.md` | [Paul Hudson](https://github.com/twostraws/Swift-Testing-Agent-Skill) |

The platform floor and the compatibility contract outrank a skill's defaults. `swiftui-pro` assumes a current-OS app and `swift-format-style` rejects every `Formatter` subclass; here an API newer than the floor goes behind `#available` (or a shim in `Platforms/`), and an existing public formatter is deprecated, never deleted.
