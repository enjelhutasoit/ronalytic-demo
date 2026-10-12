//
// Copyright (c) 2026 Enjel Hutasoit
//

import Foundation
import Ronalytic
import RonalyticFileStorage

/// Builds the SDK config. Separate from `configure` so tests can use it.
func makeAnalyticsConfig(directory: URL) -> RonalyticConfig {
    var config = RonalyticConfig.iOSDefaults(
        storage: FileQueueStorage(directory: directory, writerID: "app")
    )
    config.plugins = [ConsoleDestination()]
    #if DEBUG
    config.logger = ConsoleLogger(level: .verbose)
    #endif
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
    RonalyticSDK.configure(makeAnalyticsConfig(directory: analyticsDirectory()))
    RonalyticSDK.track("app_launched")
}
