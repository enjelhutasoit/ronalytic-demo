//
// Copyright (c) 2026 Enjel Hutasoit
//

import SwiftUI

struct SettingsView: View {
    @State private var text = EndpointSettings.text

    var body: some View {
        NavigationView {
            Form {
                Section("Endpoint (https)") {
                    TextField("https://webhook.site/your-id", text: $text)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.URL)
                }
                Section {
                    Text(text.isEmpty ? "No endpoint: events stay on disk."
                         : parseEndpoint(text) == nil ? "Invalid: must be https."
                         : "Valid.")
                    Text("The SDK configures once per launch. Restart the app to apply a new URL.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
            .onChange(of: text) { EndpointSettings.text = $0 }
        }
    }
}
