//
// Copyright (c) 2026 Enjel Hutasoit
//

import Foundation

/// Values shared by the app and the widget.
enum DemoShared {
    /// Replace with your own App Group identifier. Same value in both targets' capability.
    static let groupID = "group.com.enjelhutasoit.ronalytic-demo"

    /// Preferences shared with the widget. Falls back to standard defaults without the group.
    static var defaults: UserDefaults {
        UserDefaults(suiteName: groupID) ?? .standard
    }
}
