//
// Copyright (c) 2026 Enjel Hutasoit
//

import Foundation
import Ronalytic
import RonalyticFileStorage
import RonalyticHTTP

func makeAnalyticsConfig(
    storage: any QueueStorage,
    endpoint: URL? = nil,
    consent: any ConsentProvider = DemoConsentProvider(),
    optOutStore: any OptOutStore = UserDefaultsOptOutStore(defaults: DemoShared.defaults)
) -> RonalyticConfig {
    var config = RonalyticConfig.iOSDefaults(
        storage: storage,
        transport: endpoint.map { HTTPTransport(endpoint: $0) }
    )
    config.plugins = [ConsoleDestination()]
    config.flushInterval = .seconds(10)   // short, so the demo shows results quickly
    config.consentProvider = consent
    config.optOutStore = optOutStore
    #if DEBUG
    config.logger = ConsoleLogger(level: .verbose)
    #endif
    return config
}

/// Convenience used by tests: a queue in a plain folder.
func makeAnalyticsConfig(
    directory: URL,
    endpoint: URL? = nil,
    consent: any ConsentProvider = DemoConsentProvider(),
    optOutStore: any OptOutStore = UserDefaultsOptOutStore(defaults: DemoShared.defaults)
) -> RonalyticConfig {
    makeAnalyticsConfig(
        storage: FileQueueStorage(directory: directory, writerID: "app"),
        endpoint: endpoint,
        consent: consent,
        optOutStore: optOutStore
    )
}

/// Fallback folder when the App Group is not available.
func analyticsDirectory() -> URL {
    let base = FileManager.default
        .urls(for: .applicationSupportDirectory, in: .userDomainMask)
        .first ?? FileManager.default.temporaryDirectory
    return base.appendingPathComponent("Ronalytic", isDirectory: true)
}

/// The shared App Group queue, or a private folder when the group is not set up.
func makeAppStorage() -> any QueueStorage {
    if let shared = try? FileQueueStorage.appGroup(identifier: DemoShared.groupID, writerID: "app") {
        return shared
    }
    return FileQueueStorage(directory: analyticsDirectory(), writerID: "app")
}

/// Call once, as early as possible.
func configureAnalytics() {
    RonalyticSDK.configure(makeAnalyticsConfig(storage: makeAppStorage(), endpoint: EndpointSettings.url))
    RonalyticSDK.track("app_launched")
}
