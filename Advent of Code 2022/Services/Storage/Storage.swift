//
// 💡 Storage
// 🎅🏽 Author: Benno Kress
//

import CodableStorage
import Foundation

class Storage {
    
    private let codableStorage = CodableStorage()
    
    static let shared = Storage()
    private init() { }
    
    // MARK: Codable Storage Wrapper
    
    /// Encodes the given value and saves it according to the item rules.
    /// - Parameters:
    ///   - value: The value to be saved
    ///   - item: The storable item that the value represents
    func save(_ value: Codable, as item: StorageItem) {
        try? codableStorage.save(value, as: item)
    }
    
    /// Checks if a value for the given item exists.
    /// - Parameter item: The storable item to look for
    /// - Returns: Returns `true`, if  a value is found for the given storable
    func containsValue(for item: StorageItem) -> Bool {
        guard let containsValue = try? codableStorage.containsValue(for: item) else { return false }
        return containsValue
    }
    
    /// Retrieves the value of the given item, if found and convertable to the given type.
    /// - Parameter item: The storable item to look for
    /// - Parameter type: The type the value should be returned in
    /// - Returns: The desired value, if found and in the correct format or `nil` otherwise.
    func get<T: Codable>(_ item: StorageItem, as type: T.Type) -> T? {
        guard containsValue(for: item), let value = try? codableStorage.get(item, as: type) else { return nil }
        return value
    }
    
    /// Deletes the value for the given item from Storage.
    /// - Parameter item: The storable item to delete
    func delete(_ item: StorageItem) {
        try? codableStorage.delete(item)
    }
    
    // MARK: Convenience Methods
    
    /// Sets a flag for the given item.
    /// - Parameters:
    ///   - item: The storable item that the Flag represents
    func setFlag(for item: StorageItem) {
        save(Flag.isSet, as: item)
    }
    
    /// Checks if values for all the given items exist in Storage.
    /// - Parameter items: The storable item to check.
    /// - Returns: Returns `true`, if  values are found for all the given items.
    func containsValues(for items: StorageItem...) -> Bool {
        items.allSatisfy { containsValue(for: $0) }
    }
    
    /// Returns `true` if the Flag for the given item is set and `false` otherwise.
    func isFlagSet(for item: StorageItem) -> Bool {
        get(item, as: Flag.self) != nil
    }
    
    /// Retrieves the value for the given item as a Bool.
    /// - Parameter item: The storable item to look for
    /// - Parameter defaultValue: The value to return if Storage doesn't contain a valid value for the given item.
    /// - Attention: This will crash if `defaultValue` is `nil` and  the value is not set or can't be converted to a Boolean.
    func getBool(for item: StorageItem, otherwise defaultValue: Bool? = nil) -> Bool {
        guard let value = get(item, as: Bool.self) else { return defaultValueOrCrash(defaultValue) }
        return value
    }
    
    /// Retrieves the value for the given item as a Bool, if found and convertable.
    /// - Parameter item: The storable item to look for
    func getBoolIfAvailable(for item: StorageItem) -> Bool? {
        get(item, as: Bool.self)
    }
    
    /// Retrieves the value for the given item as a String.
    /// - Parameter item: The storable item to look for
    /// - Parameter defaultValue: The value to return if Storage doesn't contain a valid value for the given item.
    /// - Attention: This will crash if `defaultValue` is `nil` and the value is not set or can't be converted to a String.
    func getString(for item: StorageItem, otherwise defaultValue: String? = nil) -> String {
        guard let value = getStringIfAvailable(for: item) else { return defaultValueOrCrash(defaultValue) }
        return value
    }
    
    /// Retrieves the value for the given item as a String, if found and convertable.
    /// - Parameter item: The storable item to look for
    func getStringIfAvailable(for item: StorageItem) -> String? {
        get(item, as: String.self)
    }
    
    /// Deletes all stored values.
    func clear() {
        StorageItem.allCases.forEach { delete($0) }
    }
    
    private func defaultValueOrCrash<T>(_ defaultValue: T?) -> T {
        guard let defaultValue else { fatalError() }
        return defaultValue
    }
    
}

private class CodableStorage: CodableStorageService {
    
    typealias Item = StorageItem
    
}

enum Flag: Codable {
    case isSet
}
