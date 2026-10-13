//
// Copyright (c) 2026 Enjel Hutasoit
//

import XCTest
import Ronalytic
@testable import RonalyticDemo

final class DemoConsentProviderTests: XCTestCase {

    private let suite = "demo-tests-\(UUID().uuidString)"

    override func tearDown() {
        UserDefaults().removePersistentDomain(forName: suite)
    }

    func test_startsUnknown() async {
        let sut = DemoConsentProvider(suiteName: suite)

        let status = await sut.status()

        XCTAssertEqual(status, .unknown)
    }

    func test_remembersGranted() async {
        let sut = DemoConsentProvider(suiteName: suite)

        sut.set(.granted)
        let status = await sut.status()

        XCTAssertEqual(status, .granted)
    }

    func test_survivesANewInstance() async {
        DemoConsentProvider(suiteName: suite).set(.denied)

        let status = await DemoConsentProvider(suiteName: suite).status()

        XCTAssertEqual(status, .denied)
    }
}
