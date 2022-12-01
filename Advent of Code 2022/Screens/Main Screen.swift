//
// 💡 Main Screen
// 🎅🏽 Author: Benno Kress
//

import AdventOfCode2022
import SwiftUI

struct MainScreen: View {
    
    @State private var selectedChallenge: Challenge?
    
    var body: some View {
        NavigationSplitView(sidebar: sidebar, detail: content)
    }
    
    private func sidebar() -> some View {
        sidebarItems
            .navigationTitle("Challenges")
    }
    
    private var sidebarItems: some View {
        List(Challenge.allCases, selection: $selectedChallenge) { challenge in
            NavigationLink(value: challenge) {
                Text(challenge.date.formatted(for: .sidebar))
            }
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
