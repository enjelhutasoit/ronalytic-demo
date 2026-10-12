//
// Copyright (c) 2026 Enjel Hutasoit
//

import XCTest
import Ronalytic
@testable import RonalyticDemo

final class DiagnosticsViewModelTests: XCTestCase {

    func test_beforeRefresh_showsNothing() {
        let sut = DiagnosticsViewModel(source: { MetricsSnapshot() })

        XCTAssertTrue(sut.rows.isEmpty)
        XCTAssertEqual(sut.status, "Press refresh")
    }

    func test_refresh_withNilSource_saysNotConfigured() {
        let sut = DiagnosticsViewModel(source: { nil })

        sut.refresh()

        XCTAssertEqual(sut.status, "SDK not configured")
        XCTAssertTrue(sut.rows.isEmpty)
    }

    func test_refresh_withSnapshot_showsRows() {
        let sut = DiagnosticsViewModel(source: { MetricsSnapshot() })

        sut.refresh()

        XCTAssertEqual(sut.status, "OK")
        XCTAssertEqual(sut.rows.first?.title, "Stored")
        XCTAssertEqual(sut.rows.first?.value, "0")
    }

    func test_summary_isEmptyUntilRefreshed() {
        let sut = DiagnosticsViewModel(source: { MetricsSnapshot() })

        XCTAssertEqual(sut.summary, "")

        sut.refresh()

        XCTAssertTrue(sut.summary.hasPrefix("stored=0"))
    }
}
