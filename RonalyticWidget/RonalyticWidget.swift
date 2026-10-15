//
// Copyright (c) 2026 Enjel Hutasoit
//

import SwiftUI
import WidgetKit

struct DemoEntry: TimelineEntry {
    let date: Date
}

struct DemoProvider: TimelineProvider {
    func placeholder(in context: Context) -> DemoEntry { DemoEntry(date: Date()) }

    func getSnapshot(in context: Context, completion: @escaping (DemoEntry) -> Void) {
        completion(DemoEntry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DemoEntry>) -> Void) {
        let entry = DemoEntry(date: Date())
        let next = Date().addingTimeInterval(15 * 60)
        Task {
            await WidgetAnalytics.trackTimelineLoaded()
            completion(Timeline(entries: [entry], policy: .after(next)))
        }
    }
}

struct RonalyticWidgetView: View {
    let entry: DemoEntry

    var body: some View {
        VStack {
            Text("Ronalytic").font(.headline)
            Text(entry.date, style: .time).font(.caption)
        }
    }
}

@main
struct RonalyticWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "RonalyticWidget", provider: DemoProvider()) { entry in
            RonalyticWidgetView(entry: entry)
        }
        .configurationDisplayName("Ronalytic")
        .description("Writes an event to the shared queue.")
        .supportedFamilies([.systemSmall])
    }
}
