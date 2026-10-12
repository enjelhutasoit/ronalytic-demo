//
//  RonalyticDemoApp.swift
//  RonalyticDemo
//
//  Created by Enjel Hutasoit on 12/10/26.
//

import SwiftUI

@main
struct RonalyticDemoApp: App {
    
    init() {
        configureAnalytics()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
