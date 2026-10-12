//
// Copyright (c) 2026 Enjel Hutasoit
//

import XCTest
import Ronalytic
@testable import RonalyticDemo

final class DemoActionsTests: XCTestCase {
    private var calls: [String] = []
    
    func test_purchase_tracksWithThreeProperties() {
        let sut = makeActions()
        
        sut.purchase()
        
        XCTAssertEqual(calls, ["track:purchase:3"])
    }
    
    func test_openHome_sendsScreen() {
        let sut = makeActions()
        
        sut.openHome()
        
        XCTAssertEqual(calls, ["screen:Home"])
    }
    
    func test_login_identifiesUserWithOneTrait() {
        let sut = makeActions()
        
        sut.login()
        
        XCTAssertEqual(calls, ["identify:user-42:1"])
    }
    
    func test_flush_callsFlush() {
        let sut = makeActions()
        
        sut.sendQueued()
        
        XCTAssertEqual(calls, ["flush"])
    }
    
    // MARK: - Helper
    
    private func makeActions() -> DemoActions {
        DemoActions(
            track: { [self] name, properties in calls.append("track:\(name):\(properties.count)") },
            screen: { [self] name in calls.append("screen:\(name)") },
            identify: { [self] id, traits in calls.append("identify:\(id):\(traits.count)") },
            flush: { [self] in calls.append("flush") }
        )
    }
}
