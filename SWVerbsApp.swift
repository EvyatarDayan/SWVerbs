//
//  SWVerbsApp.swift
//  SW-Verbs
//
//  Created by EVYATAR DAYAN on 2026-01-05.
//

import SwiftUI

@main
struct SWVerbsApp: App {
    @AppStorage("darkModeEnabled") private var darkModeEnabled: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(darkModeEnabled ? .dark : nil)
                .tint(.appRed)
        }
    }
}
