//
// Copyright (c) 2026 Enjel Hutasoit
//

import Ronalytic
import SwiftUI

struct SettingsView: View {
    @State private var text = EndpointSettings.text
    @State private var consent = "unknown"
    @State private var optedOut = RonalyticSDK.isOptedOut() ?? false

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
                
                Section("Consent (asked by the app)") {
                    Picker("Consent", selection: $consent) {
                        Text("Unknown").tag("unknown")
                        Text("Granted").tag("granted")
                        Text("Denied").tag("denied")
                    }
                    .pickerStyle(.segmented)
                    Text("Unknown or denied: events are dropped. Takes effect immediately.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                
                Section("Opt-out (chosen by the user)") {
                    Toggle("Stop tracking me", isOn: $optedOut)
                }
            }
            .navigationTitle("Settings")
            .onChange(of: text) { EndpointSettings.text = $0 }
            .onAppear { consent = DemoConsentProvider().currentRaw }
            .onChange(of: consent) { value in
                DemoConsentProvider().set(value == "granted" ? .granted : value == "denied" ? .denied : .unknown)
            }
            .onChange(of: optedOut) { value in
                optedOut = value
                value ? RonalyticSDK.optOut() : RonalyticSDK.optIn()
            }
        }
    }
}
