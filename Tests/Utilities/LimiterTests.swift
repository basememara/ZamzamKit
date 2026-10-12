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

        for input in ["h", "e", "l", "l"] {
            await debouncer.run { await recorder.append(input) }
        }

        // Taken before the last call, which starts the wait the first entry must outlast
        let firstPause = Date.now
        await debouncer.run { await recorder.append("o") }
        try await Task.sleep(for: .seconds(2))

        await debouncer.run { await recorder.append("wor") }
        let secondPause = Date.now
        await debouncer.run { await recorder.append("ld") }
        try await Task.sleep(for: .seconds(2))

        let fired = await recorder.entries
        #expect(fired.map(\.value) == ["o", "ld"])
        #expect(fired.first.map { $0.date.timeIntervalSince(firstPause) >= 1 } == true)
        #expect(fired.last.map { $0.date.timeIntervalSince(secondPause) >= 1 } == true)
    }

    @Test
    func debounceStillCancelsACallMadeWhileAnEarlierOperationRuns() async throws {
        let debouncer = Limiter(policy: .debounce, duration: 1)
        let recorder = Recorder()

        // "a" runs from 1 s to 3 s; "b" waits from 2.5 s and should be replaced by "c" at 3.3 s
        await debouncer.run {
            try? await Task.sleep(for: .seconds(2))
            await recorder.append("a")
        }

        try await Task.sleep(for: .seconds(2.5))
        await debouncer.run { await recorder.append("b") }
        try await Task.sleep(for: .seconds(0.8))
        await debouncer.run { await recorder.append("c") }
        try await Task.sleep(for: .seconds(1.5))

        #expect(await recorder.entries.map(\.value) == ["a", "c"])
    }
}

private actor Recorder {
    private(set) var entries: [(value: String, date: Date)] = []

    func append(_ value: String) {
        entries.append((value, .now))
    }
}
