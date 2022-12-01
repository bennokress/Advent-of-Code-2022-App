//
// 💡 Cache
// 🎅🏽 Author: Benno Kress
//

import CodableStorage
import Foundation

class CacheDestination: StorageDestination {
    
    @Injected(\.storageCache) private var storageCache
    
    func save(_ encodedValue: Data, for key: String) throws {
        storageCache[key] = encodedValue
    }
    
    func containsEncodedValue(for key: String) throws -> Bool {
        storageCache[key] != nil
    }
    
    func getEncodedValue(for key: String, authenticationPromptIfNeeded authenticationPrompt: String) throws -> Data {
        guard let value = storageCache[key] else { throw StorageError.valueNotFound(key) }
        return value
    }
    
    func deleteEncodedValue(for key: String) throws {
        storageCache[key] = nil
    }
    
}

// MARK: - Dependency Injection

private struct StorageCache: InjectionKey {
    
    static var currentValue: [String: Data] = [:]
    
}

extension InjectedValues {
    
    var storageCache: [String: Data] {
        get { Self[StorageCache.self] }
        set { Self[StorageCache.self] = newValue }
    }
    
}
