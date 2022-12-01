//
// 💡 Storage Error
// 🎅🏽 Author: Benno Kress
//

import Foundation

enum StorageError: Error {
    
    case unableToCheck(_ item: String)
    case unableToDelete(_ item: String)
    case unableToSave(_ item: String)
    case valueNotFound(_ item: String)
    
}
