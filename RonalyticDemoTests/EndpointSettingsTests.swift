//
// Copyright (c) 2026 Enjel Hutasoit
//

import XCTest
@testable import RonalyticDemo

final class EndpointSettingsTests: XCTestCase {
    func test_emptyText_meansNoEndpoint() {
        XCTAssertNil(parseEndpoint(""))
        XCTAssertNil(parseEndpoint("   "))
    }

    func test_httpsURL_isAccepted() {
        let url = parseEndpoint("https://webhook.site/abc")

        XCTAssertEqual(url?.absoluteString, "https://webhook.site/abc")
    }

    func test_httpURL_isRejected() {
        XCTAssertNil(parseEndpoint("http://webhook.site/abc"))
    }

    func test_garbage_isRejected() {
        XCTAssertNil(parseEndpoint("not a url"))
    }

    func test_surroundingSpacesAreTrimmed() {
        let url = parseEndpoint("  https://webhook.site/abc \n")

        XCTAssertEqual(url?.host, "webhook.site")
    }
}
