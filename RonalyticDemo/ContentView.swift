//
//  ContentView.swift
//  RonalyticDemo
//
//  Created by Enjel Hutasoit on 12/10/26.
//

import Ronalytic
import SwiftUI

struct ContentView: View {
    private let actions = DemoActions.live
    @State private var lastAction = "none"
    @State private var showDiagnostics = false
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Ronalytic Demo!").font(.title)
            Text("SDK \(RonalyticInfo.version)").foregroundStyle(.secondary)
            
            Button("Track purchase") { run("purchase", actions.purchase) }
            Button("Open Home screen") { run("screen Home", actions.openHome) }
            Button("Identify user-42") { run("identify", actions.login) }
            Button("Flush") { run("flush", actions.sendQueued) }
            Button("Diagnostics") { showDiagnostics = true }
            Text("Last action: \(lastAction)").font(.footnote)
        }
        .buttonStyle(.borderedProminent)
        .padding()
        .sheet(isPresented: $showDiagnostics, content: { DiagnosticsView() })
    }
    
    private func run(_ label: String, _ action: () -> Void) {
        action()
        lastAction = label
    }
}

#Preview {
    ContentView()
}
