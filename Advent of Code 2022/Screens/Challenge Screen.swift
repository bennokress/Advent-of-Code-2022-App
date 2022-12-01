//
// 💡 Challenge Screen
// 🎅🏽 Author: Benno Kress
//

import AdventOfCode2022
import SwiftUI

struct ChallengeScreen: View {
    
    @State private var input = ""
    @State private var showAlert = false
    @State private var alertType: AlertType = .unavailable
    @State private var solutionPart1 = ""
    @State private var solutionPart2 = ""
    
    private let challenge: Challenge
    
    init(for challenge: Challenge) {
        self.challenge = challenge
    }
    
    var body: some View {
        contentLayer
            .padding()
            .onAppear(perform: fillInputFromStorage)
            .alert(isPresented: $showAlert, content: alertContent)
    }
    
    private var contentLayer: some View {
        VStack(alignment: .leading) {
            Text("Enter the input for the challenge of \(challenge.date.formatted(for: .description)):")
            
            TextEditor(text: $input)
                .font(.system(.body, design: .monospaced, weight: .medium))
                .lineSpacing(8)
                .scrollContentBackground(.hidden) // Removes the default background color
                .padding(.vertical, 8)
                .padding(.horizontal, 4)
                .background(Color.textEditorBackground)
                .border(Color.accentColor)
            
            HStack {
                Spacer()
                Button("Solve", action: solveChallenge)
            }
        }
    }
    
    private func alertContent() -> Alert {
        Alert(
            title: Text(alertType.title),
            message: Text(alertType.message)
        )
    }
    
    private func solveChallenge() {
        guard let solver = AdventOfCode2022.solver(for: challenge, with: input) else { return handleUnavailableChallenge() }
        Storage.shared.save(input, as: .input(challenge: challenge))
        alertType = .solution(challenge: challenge, solver: solver)
        showAlert = true
    }
    
    private func handleUnavailableChallenge() {
        alertType = .unavailable
        showAlert = true
    }
    
    private func fillInputFromStorage() {
        input = Storage.shared.getString(for: .input(challenge: challenge), otherwise: "")
    }
    
    private enum AlertType {
        
        case unavailable
        case solution(challenge: Challenge, solver: any Solver)
        
        var title: String {
            switch self {
            case .unavailable: return "Challenge not available"
            case let .solution(challenge, _): return "Solution for \(challenge.date.formatted(for: .description))"
            }
        }
        
        var message: String {
            switch self {
            case .unavailable: return "Challenge not available"
            case let .solution(_, solver): return "Solution Part 1:\n\(solver.solutionPart1)\n\nSolution Part 2:\n\(solver.solutionPart2)"
            }
        }
        
    }
    
}
