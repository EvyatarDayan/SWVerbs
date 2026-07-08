//
//  ContentView.swift
//  SW-Verbs
//
//  Created by EVYATAR DAYAN on 2026-01-05.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(WelcomeStorage.skipWelcomeKey) private var skipWelcomeScreen = false
    @State private var showWelcome = true

    var body: some View {
        ZStack {
            if showWelcome && !skipWelcomeScreen {
                LogoView {
                    withAnimation {
                        showWelcome = false
                    }
                }
            } else {
                MainTabView()
            }
        }
    }
}

#Preview {
    ContentView()
}
