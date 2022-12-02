//
// 💡 Main Screen
// 🎅🏽 Author: Benno Kress
//

import AdventOfCode2022
import SwiftUI

struct MainScreen: View {
    
    @State private var selectedChallenge: Challenge?
    
    init() {
        self.selectedChallenge = Challenge.current
    }
    
    var body: some View {
        NavigationSplitView(sidebar: sidebar, detail: content)
    }
    
    private func sidebar() -> some View {
        sidebarItems
            .listStyle(.inset(alternatesRowBackgrounds: true))
            .navigationTitle("Challenges")
            .navigationSplitViewColumnWidth(250)
    }
    
    private var sidebarItems: some View {
        List(Challenge.allCases, selection: $selectedChallenge) { challenge in
            NavigationLink(value: challenge) {
                sidebarRow(for: challenge)
            }
        }
    }
    
    private func sidebarRow(for challenge: Challenge) -> some View {
        HStack {
            Text(challenge.date.formatted(for: .sidebar))
                .frame(height: 30)
                .padding(.horizontal)
            
            Spacer()
        }
    }
    
    private func content() -> some View {
        challengeView
    }
    
    @ViewBuilder private var challengeView: some View {
        if let selectedChallenge {
            ChallengeScreen(for: selectedChallenge)
                .id(selectedChallenge.id)
        } else { 
            Text("Please select a challenge from the sidebar")
        }
    }
    
}
