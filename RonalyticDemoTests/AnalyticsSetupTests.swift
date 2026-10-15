//
// Copyright (c) 2026 Enjel Hutasoit
//

import XCTest
import Ronalytic
@testable import RonalyticDemo

private struct ConsentGrantedStub: ConsentProvider {
    func status() async -> ConsentStatus { .granted }
}

final class AnalyticsSetupTests: XCTestCase {
    private let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent("demo-tests-\(UUID().uuidString)", isDirectory: true)
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: directory)
    }
    
    func test_config_hasAConsoleDestination() {
        let config = makeAnalyticsConfig(directory: directory)
        
        XCTAssertEqual(config.plugins.map(\.name), ["console-destination"])
    }
    
    func test_config_hasNoTransportWithoutEndpoint() {
        let config = makeAnalyticsConfig(directory: directory, endpoint: nil)

        XCTAssertNil(config.transport)
    }

    func test_config_hasTransportWithEndpoint() {
        let url = URL(string: "https://webhook.site/abc")

        let config = makeAnalyticsConfig(directory: directory, endpoint: url)

        XCTAssertNotNil(config.transport)
    }

    func test_config_hasLifecycleObserverFromIOSDefaults() {
        let config = makeAnalyticsConfig(directory: directory)

        XCTAssertNotNil(config.lifecycleObserver)
    }

    func test_trackedEvent_isWrittenToTheQueueFolder() async throws {
        let client = RonalyticClient(config: makeAnalyticsConfig(
            directory: directory,
            consent: ConsentGrantedStub(),
            optOutStore: InMemoryOptOutStore()
        ))

        client.track("demo_event")
        client.flush()
        await client.waitUntilIdle()

        let files = try FileManager.default.contentsOfDirectory(atPath: directory.path)
        XCTAssertTrue(files.contains("segment-app.jsonl"))
    }
    
    func test_config_hasAConsentProvider() {
        let config = makeAnalyticsConfig(directory: directory)

        XCTAssertNotNil(config.consentProvider)
    }
}
