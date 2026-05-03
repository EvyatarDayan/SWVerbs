//
//  ContentView.swift
//  SWVerbs
//
//  Created by EVYATAR DAYAN on 2026-01-05.
//

import SwiftUI

struct ContentView: View {
    @State private var showLogo = true
    
    var body: some View {
        ZStack {
            if showLogo {
                LogoView {
                    withAnimation {
                        showLogo = false
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
