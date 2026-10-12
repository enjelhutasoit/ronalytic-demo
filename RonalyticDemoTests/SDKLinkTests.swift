//
// Copyright (c) 2026 Enjel Hutasoit
//

import XCTest
import Ronalytic

final class SDKLInterface: XCTestCase {
    func test_SDKVersion_isReadableFromOutsideThePackage() {
        let version = RonalyticInfo.version
        
        XCTAssertFalse(version.isEmpty)
    }
}
