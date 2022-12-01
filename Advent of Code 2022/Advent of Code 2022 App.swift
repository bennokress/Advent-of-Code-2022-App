//
// 💡 Advent of Code 2022 App
// 🎅🏽 Author: Benno Kress
//

import SwiftUI

@main
struct AdventOfCode2022App: App {
    
    var body: some Scene {
        WindowGroup {
            #if os(macOS)
                MainScreen()
                    .frame(minWidth: 1280, maxWidth: .infinity, minHeight: 800, maxHeight: .infinity, alignment: .center)
            #else
                MainScreen()
            #endif
        }
    }
    
}
