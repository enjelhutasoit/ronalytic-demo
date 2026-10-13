//
// Copyright (c) 2026 Enjel Hutasoit
//

import Foundation
import Ronalytic

/// Example of how an app connects its own consent choice to the SDK.
/// Stores only the suite name, because UserDefaults is not Sendable in older SDKs.
struct DemoConsentProvider: ConsentProvider {
    private let suiteName: String?
    private let key = "demo.consent"

    /// nil means the standard defaults.
    init(suiteName: String? = nil) {
        self.suiteName = suiteName
    }

    private var defaults: UserDefaults {
        suiteName.flatMap { UserDefaults(suiteName: $0) } ?? .standard
    }

    var currentRaw: String { defaults.string(forKey: key) ?? "unknown" }

    func status() async -> ConsentStatus {
        switch currentRaw {
        case "granted": return .granted
        case "denied": return .denied
        default: return .unknown
        }
    }

    func set(_ status: ConsentStatus) {
        let value: String
        switch status {
        case .granted: value = "granted"
        case .denied: value = "denied"
        case .unknown: value = "unknown"
        }
        defaults.set(value, forKey: key)
    }
}
