//
// Copyright (c) 2026 Enjel Hutasoit
//

import Foundation
import Ronalytic
import RonalyticFileStorage
import RonalyticHTTP

/// Builds the SDK config. Separate from `configure` so tests can use it.
func makeAnalyticsConfig(directory: URL, endpoint: URL? = nil) -> RonalyticConfig {
    var config = RonalyticConfig.iOSDefaults(
        storage: FileQueueStorage(directory: directory, writerID: "app"),
        transport: endpoint.map { HTTPTransport(endpoint: $0) }
    )
    config.plugins = [ConsoleDestination()]
    config.flushInterval = .seconds(10)   // short, so the demo shows results quickly
    #if DEBUG
    config.logger = ConsoleLogger(level: .verbose)
    #endif
    config.consentProvider = DemoConsentProvider()
    return config
}

/// Folder for the queue files, inside the app's private Application Support.
func analyticsDirectory() -> URL {
    let base = FileManager.default
        .urls(for: .applicationSupportDirectory, in: .userDomainMask)
        .first ?? FileManager.default.temporaryDirectory
    return base.appendingPathComponent("Ronalytic", isDirectory: true)
}

/// Call once, as early as possible.
func configureAnalytics() {
    RonalyticSDK.configure(
        makeAnalyticsConfig(
            directory: analyticsDirectory(),
            endpoint: EndpointSettings.url
        )
    )
    RonalyticSDK.track("app_launched")
}
