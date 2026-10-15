//
// Copyright (c) 2026 Enjel Hutasoit
//

import RonalyticCore
import RonalyticFileStorage

enum WidgetAnalytics {
    /// Writes one event to the shared queue and waits until it is on disk.
    static func trackTimelineLoaded() async {
        guard let storage = try? FileQueueStorage.appGroup(
            identifier: DemoShared.groupID,
            writerID: "widget"
        ) else { return }

        let sdk = RonalyticExtension(
            config: makeExtensionConfig(storage: storage, suiteName: DemoShared.groupID)
        )
        sdk.track("widget_timeline_loaded", properties: ["family": "small"])
        await sdk.waitUntilStored()
    }
}
