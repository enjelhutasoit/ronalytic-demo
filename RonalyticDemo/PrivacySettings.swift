//
// Copyright (c) 2026 Enjel Hutasoit
//

import Foundation

enum PrivacySettings {
    private static let optOutKey = "demo.optOutShown"

    /// The demo's own copy, only used to draw the toggle.
    static var optedOut: Bool {
        get { UserDefaults.standard.bool(forKey: optOutKey) }
        set { UserDefaults.standard.set(newValue, forKey: optOutKey) }
    }
}
