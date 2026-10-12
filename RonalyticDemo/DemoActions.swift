//
// Copyright (c) 2026 Enjel Hutasoit
//

import Ronalytic

/// What the buttons do. Closures are injected so tests need no real SDK.
struct DemoActions {
    var track: (String, [String: PropertyValue]) -> Void
    var screen: (String) -> Void
    var identify: (String, [String: PropertyValue]) -> Void
    var flush: () -> Void

    /// The real SDK.
    @MainActor static let live = DemoActions(
        track: { RonalyticSDK.track($0, properties: $1) },
        screen: { RonalyticSDK.screen($0) },
        identify: { RonalyticSDK.identify($0, traits: $1) },
        flush: { RonalyticSDK.flush() }
    )

    func purchase() {
        track(
            "purchase",
            ["price": 9.99, "qty": 2, "coupon": "WELCOME"]
        )
    }

    func openHome() {
        screen("Home")
    }

    func login() {
        identify(
            "user-42",
            ["plan": "pro"]
        )
    }

    func sendQueued() {
        flush()
    }
}
