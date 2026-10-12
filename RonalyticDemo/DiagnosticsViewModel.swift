//
// Copyright (c) 2026 Enjel Hutasoit
//

import Foundation
import Ronalytic

final class DiagnosticsViewModel: ObservableObject {
    struct Row: Identifiable, Equatable {
        let title: String
        let value: String
        var id: String { title }
    }

    @Published private(set) var rows: [Row] = []
    @Published private(set) var status = "Press refresh"
    @Published private(set) var summary = ""

    private let source: () -> MetricsSnapshot?

    init(source: @escaping () -> MetricsSnapshot? = { RonalyticSDK.diagnostics() }) {
        self.source = source
    }

    func refresh() {
        guard let snapshot = source() else {
            status = "SDK not configured"
            rows = []
            summary = ""
            return
        }

        status = "OK"
        summary = snapshot.summary
        rows = [
            Row(title: "Stored", value: "\(snapshot.eventsStored)"),
            Row(title: "Dropped by plugin", value: "\(snapshot.eventsDroppedByPlugin)"),
            Row(title: "Dropped by queue", value: "\(snapshot.eventsDroppedByQueue)"),
            Row(title: "Dropped by opt-out", value: "\(snapshot.eventsDroppedByOptOut)"),
            Row(title: "Storage failures", value: "\(snapshot.storageFailures)"),
            Row(title: "Batches sent", value: "\(snapshot.batchesSent)"),
            Row(title: "Send failures", value: "\(snapshot.sendFailures)"),
            Row(title: "Delivered", value: "\(snapshot.eventsDelivered)"),
            Row(title: "Rejected", value: "\(snapshot.eventsRejected)"),
            Row(title: "Retries", value: "\(snapshot.retries)"),
            Row(title: "Flushes", value: "\(snapshot.flushes)"),
            Row(title: "Last flush", value: snapshot.lastFlushDuration.map { "\($0)s" } ?? "-")
        ]
    }
}
