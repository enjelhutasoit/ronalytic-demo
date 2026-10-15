//
// Copyright (c) 2026 Enjel Hutasoit
//

import XCTest
import Ronalytic
import RonalyticFileStorage
@testable import RonalyticDemo

final class ExtensionConfigTests: XCTestCase {

    private let container = FileManager.default.temporaryDirectory
        .appendingPathComponent("demo-group-\(UUID().uuidString)", isDirectory: true)
    private let suite = "demo-tests-\(UUID().uuidString)"

    override func tearDown() {
        UserDefaults().removePersistentDomain(forName: suite)
        try? FileManager.default.removeItem(at: container)
    }

    private func makeStorage(writerID: String) throws -> FileQueueStorage {
        let folder = container
        return try FileQueueStorage.appGroup(
            identifier: "group.test",
            writerID: writerID,
            containerProvider: { _ in folder }
        )
    }

    /// The widget tracks one event. Returns what the app sees in the shared queue.
    private func namesSeenByAppAfterWidgetTracks() async throws -> [String] {
        let widget = RonalyticExtension(config: makeExtensionConfig(
            storage: try makeStorage(writerID: "widget"),
            suiteName: suite
        ))

        widget.track("widget_timeline_loaded")
        await widget.waitUntilStored()

        return try await makeStorage(writerID: "app").peek(limit: 10).map(\.name)
    }

    func test_extensionConfig_hasNoTransport() throws {
        let config = makeExtensionConfig(storage: try makeStorage(writerID: "widget"), suiteName: suite)

        XCTAssertNil(config.transport)
    }

    func test_grantedConsent_widgetEventReachesTheAppQueue() async throws {
        DemoConsentProvider(suiteName: suite).set(.granted)

        let names = try await namesSeenByAppAfterWidgetTracks()

        XCTAssertEqual(names, ["widget_timeline_loaded"])
    }

    func test_unknownConsent_widgetEventIsDropped() async throws {
        let names = try await namesSeenByAppAfterWidgetTracks()

        XCTAssertEqual(names, [])
    }

    func test_optOutChosenInTheApp_isRespectedByTheWidget() async throws {
        DemoConsentProvider(suiteName: suite).set(.granted)
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
        UserDefaultsOptOutStore(defaults: defaults).setOptedOut(true)

        let names = try await namesSeenByAppAfterWidgetTracks()

        XCTAssertEqual(names, [])
    }
}
