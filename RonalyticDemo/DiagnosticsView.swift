//
// Copyright (c) 2026 Enjel Hutasoit
//

import SwiftUI

struct DiagnosticsView: View {
    @StateObject private var model = DiagnosticsViewModel()

    var body: some View {
        NavigationView {
            List {
                Section {
                    Text(model.status).foregroundStyle(.secondary)
                }
                Section("Counters") {
                    ForEach(model.rows) { row in
                        HStack {
                            Text(row.title)
                            Spacer()
                            Text(row.value).monospacedDigit()
                        }
                    }
                }
                Section {
                    Button("Refresh") { model.refresh() }
                    Button("Print summary to console") { print(model.summary) }
                }
            }
            .navigationTitle("Diagnostics")
        }
        .onAppear { model.refresh() }
    }
}
