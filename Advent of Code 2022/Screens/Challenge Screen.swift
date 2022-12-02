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
        HStack(alignment: .top, spacing: 16) {
            inputColumn
                .frame(width: 500)
            
            outputColumn
                .frame(maxWidth: .infinity)
        }
    }
    
    private var inputColumn: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Challenge")
                .font(.largeTitle)
            
            Text("Enter the input for the challenge of \(challenge.date.formatted(for: .description)):")
                .onTapGesture(perform: openChallengeInBrowser)
            
            TextEditor(text: $input)
                .font(.system(.body, design: .monospaced, weight: .medium))
                .lineSpacing(8)
                .scrollContentBackground(.hidden) // Removes the default background color
                .padding(.vertical, 8)
                .padding(.horizontal, 4)
                .background(Color.textEditorBackground)
                .border(cornerRadius: 5)
            
            Button(action: solveChallenge, label: solveButtonLabel)
                .buttonStyle(.borderedProminent)
        }
    }
    
    private var outputColumn: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Solution")
                .font(.largeTitle)
            
            solutionInfo
        }
    }
    
    @ViewBuilder private var solutionInfo: some View {
        if !solutionPart1.isEmpty, !solutionPart2.isEmpty {
            Text("Enter this for part 1:")
            
            CopyableText(solutionPart1)
                .background(Color.textEditorBackground)
                .border(cornerRadius: 5)
            
            Text("Enter this for part 2:")
            
            CopyableText(solutionPart2)
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .background(Color.textEditorBackground)
                .border(cornerRadius: 5)
        } else {
            Text("To get a solution please go to the challenge website, copy the challenge input and paste it on the left. When you're ready use the solve button below the input.")
            
            Button(action: openChallengeInBrowser, label: openChallengeInBrowserButtonLabel)
                .buttonStyle(.borderedProminent)
        }
    }
    
    private func solveButtonLabel() -> some View {
        Text("Solve")
            .frame(height: 30)
            .frame(maxWidth: .infinity)
    }
    
    private func openChallengeInBrowserButtonLabel() -> some View {
        Text("Open Challenge in your default Browser")
            .frame(height: 30)
            .frame(maxWidth: .infinity)
    }
    
    private func alertContent() -> Alert {
        Alert(
            title: Text(alertType.title),
            message: Text(alertType.message)
        )
    }
    
    private func solveChallenge() {
        guard !input.isEmpty else { return }
        guard let solver = AdventOfCode2022.solver(for: challenge, with: input) else { return handleUnavailableChallenge() }
        Storage.shared.save(input, as: .input(challenge: challenge))
        solutionPart1 = solver.solutionPart1
        solutionPart2 = solver.solutionPart2
    }
    
    private func handleUnavailableChallenge() {
        alertType = .unavailable
        showAlert = true
    }
    
    private func fillInputFromStorage() {
        input = Storage.shared.getString(for: .input(challenge: challenge), otherwise: "")
        if !input.isEmpty { solveChallenge() }
    }
    
    private func openChallengeInBrowser() {
        #if os(macOS)
            NSWorkspace.shared.open(challenge.url)
        #else
            UIApplication.shared.open(challenge.url)
        #endif
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

struct CopyableText: View {
    
    private let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        ZStack {
            textDisplay
                .background(Color.textEditorBackground)
                .border(cornerRadius: 5)
            
            copyButton
        }
    }
    
    private var textDisplay: some View {
        HStack(spacing: 0) {
            Text(text)
                .font(.system(.body, design: .monospaced, weight: .medium))
                .lineSpacing(8)
                .padding(.vertical, 8)
                .padding(.leading, 8)
            
            Spacer(minLength: 0)
        }
    }
    
    private var copyButton: some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            
            Button(action: copyText, label: copyButtonLabel)
                .buttonStyle(.borderedProminent)
                .padding(.trailing, 8)
        }
    }
    
    private func copyText() {
        #if os(macOS)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(text, forType: .string)
        #else
            UIPasteboard.general.string = text
        #endif
    }
    
    private func copyButtonLabel() -> some View {
        Image(systemName: "doc.on.doc")
            .renderingMode(.original)
    }
    
}
