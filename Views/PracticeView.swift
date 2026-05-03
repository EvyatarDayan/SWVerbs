//
//  PracticeView.swift
//  SWVerbs
//
//  Created by EVYATAR DAYAN on 2026-01-05.
//

import SwiftUI

struct PracticeView: View {
    @StateObject private var viewModel = VerbViewModel()
    @StateObject private var testManager = TestManager.shared
    @State private var practiceVerbs: [Verb] = []
    @State private var isPracticing = false
    @State private var selectedVerb: Verb?
    @State private var showTestAddedAlert = false
    @State private var newTestName: String = ""
    @State private var newTestId: String = ""
    @State private var hasSetAsTest = false
    @State private var showVerbs = false
    @State private var isFirstAppearance = true
    @Binding var selectedTab: Int
    @Binding var selectedTest: Test?
    @Binding var testToAnimate: String?
    
    init(selectedTab: Binding<Int> = .constant(2), selectedTest: Binding<Test?> = .constant(nil), testToAnimate: Binding<String?> = .constant(nil)) {
        self._selectedTab = selectedTab
        self._selectedTest = selectedTest
        self._testToAnimate = testToAnimate
    }
    
    var body: some View {
        NavigationView {
            if !isPracticing {
                // Loading or empty state
                VStack {
                    Spacer()
                    ProgressView()
                    Text("Preparing practice...")
                        .foregroundColor(.secondary)
                        .padding(.top)
                    Spacer()
                }
                .background(Color(.systemGroupedBackground))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        SplitTitleView("Practice", splitIndex: 4)
                    }
                }
                .onAppear {
                    // Automatically start with 5 verbs
                    startPractice(count: 5)
                }
            } else {
                // Practice session
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                    .overlay(
                        VStack(spacing: 0) {
                            // Information message below title
                            if !practiceVerbs.isEmpty && !viewModel.isLoading {
                                Text("Practice these verbs and test yourself when you’re ready.")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 16)
                                    .padding(.top, 35)
                                    .padding(.bottom, 20)
                            }
                            
                            // Top spacer for navigation title area
                            Spacer()
                            
                            // Verb list
                            if viewModel.isLoading {
                                ProgressView()
                                Text("Loading verbs...")
                                    .foregroundColor(.secondary)
                                    .padding(.top)
                            } else if practiceVerbs.isEmpty {
                                Text("No verbs available")
                                    .foregroundColor(.secondary)
                            } else {
                                VStack(spacing: 12) {
                                    ForEach(Array(practiceVerbs.enumerated()), id: \.element.id) { index, verb in
                                        VerbRow(verb: verb, onOpen: {
                                            selectedVerb = verb
                                        })
                                            .onTapGesture {
                                                selectedVerb = verb
                                            }
                                            .scaleEffect(showVerbs ? 1 : 0)
                                            .opacity(showVerbs ? 1 : 0)
                                            .animation(
                                                .spring(response: 0.4, dampingFraction: 0.75)
                                                    .delay(showVerbs ? Double(index) * 0.08 : Double(practiceVerbs.count - 1 - index) * 0.08),
                                                value: showVerbs
                                            )
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.top, -35)
                                .onAppear {
                                    // Only animate on first appearance
                                    if isFirstAppearance {
                                        showVerbs = false
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            showVerbs = true
                                        }
                                        isFirstAppearance = false
                                    } else {
                                        // Show immediately on subsequent appearances
                                        showVerbs = true
                                    }
                                }
                                .onChange(of: practiceVerbs.count) { oldValue, newValue in
                                    // First disappear one by one
                                    showVerbs = false
                                    // Then appear after all disappear
                                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(practiceVerbs.count) * 0.08 + 0.1) {
                                        showVerbs = true
                                    }
                                }
                                
                                // Set as Test button
                                Button(action: {
                                    let testCountBefore = testManager.tests.count
                                    testManager.addTest(verbs: practiceVerbs)
                                    // Get the newly created test (it's at index 0 since we insert at the beginning)
                                    if testManager.tests.count > testCountBefore, let newTest = testManager.tests.first {
                                        newTestName = newTest.name
                                        newTestId = newTest.id
                                        showTestAddedAlert = true
                                    }
                                    hasSetAsTest = true
                                }) {
                                    Text("Set as Test")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(hasSetAsTest ? Color.gray : Color.blue)
                                        .cornerRadius(12)
                                }
                                .disabled(hasSetAsTest)
                                .padding(.horizontal, 100)
                                .padding(.top, 50)
                            }
                            
                            // Bottom spacer
                            Spacer()
                        }
                    )
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        SplitTitleView("Practice", splitIndex: 4)
                    }
                }
                .toolbarBackground(Color(.systemGroupedBackground), for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            // First make verbs disappear one by one
                            showVerbs = false
                            // Then clear and reload after animation
                            DispatchQueue.main.asyncAfter(deadline: .now() + Double(practiceVerbs.count) * 0.08 + 0.1) {
                                isPracticing = false
                                practiceVerbs = []
                                hasSetAsTest = false
                            }
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 18))
                                .foregroundColor(.blue)
                        }
                    }
                }
                .sheet(item: $selectedVerb) { verb in
                    VerbDetailView(verb: verb, isPracticeMode: true)
                }
                .alert("New test added as \"\(newTestName)\"", isPresented: $showTestAddedAlert) {
                    Button("OK") {
                        showTestAddedAlert = false
                    }
                    Button("Open test") {
                        showTestAddedAlert = false
                        // Set the test ID to animate
                        testToAnimate = newTestId
                        // Navigate to Tests tab only (don't open test details)
                        selectedTab = 0 // Tests tab is at index 0
                        selectedTest = nil // Clear any selected test
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private func startPractice(count: Int) {
        guard !viewModel.verbs.isEmpty else {
            // Wait for verbs to load
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                startPractice(count: count)
            }
            return
        }
        
        // Get random verbs
        let shuffled = viewModel.verbs.shuffled()
        practiceVerbs = Array(shuffled.prefix(count))
        isPracticing = true
        hasSetAsTest = false
    }
}

#Preview {
    PracticeView()
}

