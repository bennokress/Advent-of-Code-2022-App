//
// 💡 Storage Item
// 🎅🏽 Author: Benno Kress
//

import AdventOfCode2022
import CodableStorage
import Foundation

enum StorageItem: Storable, CaseIterable {
    
    case input(challenge: Challenge)
    
    // MARK: Computed Properties
    
    var key: String { "day\(challenge.id)Input" }
    var challenge: Challenge {
        switch self {
        case let .input(challenge): return challenge
        }
    }
    
    var destination: StorageDestination {
        switch self {
        default:
            return UserDefaultsDestination()
        }
    }
    
    var description: String { "Input for Challenge on \(challenge.date.formatted(for: .sidebar))" }
    
    var authentticationPrompt: String { "Biometric authentication needed " + authenticationReason }
    
    private var authenticationReason: String {
        switch self {
        default:
            return "to continue"
        }
    }
    
    // MARK: - Case Iterable Conformance
    
    static var allCases: [StorageItem] { Challenge.allCases.map { StorageItem.input(challenge: $0) } }
    
}
