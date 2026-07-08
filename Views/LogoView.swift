//
//  LogoView.swift
//  SWVerbs
//
//  Created by EVYATAR DAYAN on 2026-01-17.
//

import SwiftUI

enum WelcomeStorage {
    static let skipWelcomeKey = "skipWelcomeScreen"
}

struct LogoView: View {
    var onStart: () -> Void
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage(WelcomeStorage.skipWelcomeKey) private var skipWelcomeScreen = false
    @State private var dontShowAgain = false

    var body: some View {
        ZStack {
            (darkModeEnabled ? Color.black : Color(.systemGroupedBackground))
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 20) {
                    logoView

                    SplitTitleView("Welcome to SW-Verbs", splitIndex: 11)

                    Text("Master Swedish verb conjugations with practice, tests, and favorites. Learn present, past, and perfect forms with translations and examples - everything you need to use Swedish verbs with confidence.")
                        .font(.body)
                        .foregroundColor(darkModeEnabled ? .white : .black)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 4)
                        .padding(.top, 15)

                    Button(action: startApp) {
                        Text("Get Started")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.appRed)
                            .clipShape(Capsule())
                    }
                    .padding(.top, 40)
                }
                .padding(.horizontal, 32)

                Spacer()

                Button {
                    dontShowAgain.toggle()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: dontShowAgain ? "checkmark.square.fill" : "square")
                            .font(.title3)
                            .foregroundStyle(dontShowAgain ? Color.appRed : Color.gray)


                        Text("Don't show this again")
                            .font(.subheadline)
                            .foregroundStyle(.gray)

                        Spacer(minLength: 0)
                    }
                    .padding(.bottom, 20)
                    .padding(.leading, 20)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
        .preferredColorScheme(darkModeEnabled ? .dark : .light)
    }

    private func startApp() {
        if dontShowAgain {
            skipWelcomeScreen = true
        }
        onStart()
    }

    private var logoView: some View {
        Image("SwedishLogo")
            .resizable()
            .scaledToFit()
            .frame(width: 160, height: 160)
    }
}

#Preview {
    LogoView(onStart: {})
}
