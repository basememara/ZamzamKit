//
//  LimiterTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2022-04-04.
//  Copyright © 2022 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct LimiterTests {
    @Test
    func throttleRunsTheFirstCallOfEachWindowAtOnce() async throws {
        let throttler = Limiter(policy: .throttle, duration: 1)
        let recorder = Recorder()
        let start = Date.now

        for input in ["h", "e", "l", "l", "o"] {
            await throttler.run { await recorder.append(input) }
        }

        try await Task.sleep(for: .seconds(2))
        let secondWindow = Date.now

        for input in ["wor", "ld"] {
            await throttler.run { await recorder.append(input) }
        }

        try await Task.sleep(for: .milliseconds(500))

        let fired = await recorder.entries
        #expect(fired.map(\.value) == ["h", "wor"])
        #expect(fired.first.map { $0.date.timeIntervalSince(start) < 1 } == true)
        #expect(fired.last.map { $0.date.timeIntervalSince(secondWindow) < 1 } == true)
    }

    @Test
    func debounceRunsOnlyTheLastCallOnceTheCallsPause() async throws {
        let debouncer = Limiter(policy: .debounce, duration: 1)
        let recorder = Recorder()

        for input in ["h", "e", "l", "l", "o"] {
            await debouncer.run { await recorder.append(input) }
        }

        let firstPause = Date.now
        try await Task.sleep(for: .seconds(2))

        for input in ["wor", "ld"] {
            await debouncer.run { await recorder.append(input) }
        }

        let secondPause = Date.now
        try await Task.sleep(for: .seconds(2))

        let fired = await recorder.entries
        #expect(fired.map(\.value) == ["o", "ld"])
        #expect(fired.first.map { $0.date.timeIntervalSince(firstPause) >= 1 } == true)
        #expect(fired.last.map { $0.date.timeIntervalSince(secondPause) >= 1 } == true)
    }
}

private actor Recorder {
    private(set) var entries: [(value: String, date: Date)] = []

    func append(_ value: String) {
        entries.append((value, .now))
    }
}
