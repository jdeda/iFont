import SwiftUI
import Combine

@main
struct Main: App {
    var body: some Scene {
        WindowGroup {
            AppView(store: AppState.liveStore)
        }
    }
}
