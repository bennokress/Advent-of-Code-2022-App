//
// 💡 User Defaults
// 🎅🏽 Author: Benno Kress
//

import CodableStorage
import Foundation

struct UserDefaultsDestination: StorageDestination {
    
    @Injected(\.userDefaults) private var userDefaults
    
    func save(_ encodedValue: Data, for key: String) throws {
        userDefaults.set(encodedValue, forKey: key)
    }
    
    func containsEncodedValue(for key: String) throws -> Bool {
        userDefaults.data(forKey: key) != nil
    }
    
    func getEncodedValue(for key: String, authenticationPromptIfNeeded authenticationPrompt: String) throws -> Data {
        guard let value = userDefaults.data(forKey: key) else { throw StorageError.valueNotFound(key) }
        return value
    }
    
    func deleteEncodedValue(for key: String) throws {
        userDefaults.removeObject(forKey: key)
    }
    
}

// MARK: - Dependency Injection

private struct UserDefaultsWrapper: InjectionKey {
    
    static var currentValue = UserDefaults.standard
    
}

extension InjectedValues {
    
    var userDefaults: UserDefaults {
        get { Self[UserDefaultsWrapper.self] }
        set { Self[UserDefaultsWrapper.self] = newValue }
    }
    
}
