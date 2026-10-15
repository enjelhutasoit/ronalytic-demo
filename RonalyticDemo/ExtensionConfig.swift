//
// Copyright (c) 2026 Enjel Hutasoit
//

import Foundation
import RonalyticCore

/// Config for the widget. No transport: the widget only writes, the app uploads.
/// Consent and opt-out come from the shared suite, so the user's choice applies here too.
func makeExtensionConfig(storage: any QueueStorage, suiteName: String?) -> RonalyticConfig {
    let defaults = suiteName.flatMap { UserDefaults(suiteName: $0) } ?? .standard

    var config = RonalyticConfig(storage: storage)
    config.consentProvider = DemoConsentProvider(suiteName: suiteName)
    config.optOutStore = UserDefaultsOptOutStore(defaults: defaults)
    return config
}
