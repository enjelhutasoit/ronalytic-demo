//
//  ContentView.swift
//  RonalyticDemo
//
//  Created by Enjel Hutasoit on 12/10/26.
//

import Ronalytic
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Ronalytic Demo!")
                .font(.title)
            
            Text("SDK \(RonalyticInfo.version)")
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
