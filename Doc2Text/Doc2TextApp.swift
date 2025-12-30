import SwiftUI

@main
struct Doc2TextApp: App {
    var body: some Scene {
        WindowGroup {
          ContentView().preferredColorScheme(.light)
        }.windowResizability(.contentSize)
    }
}
