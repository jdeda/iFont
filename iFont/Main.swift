import SwiftUI
import Combine

@main
struct Main: App {
  init() {
//    let foo = FontClient.live.fetchFonts(URL(fileURLWithPath: "/System/Library/Fonts", isDirectory: true))
//      .sink(receiveValue: <#T##(([NSFont]) -> Void)##(([NSFont]) -> Void)##([NSFont]) -> Void#>)
  }
  
  var body: some Scene {
    WindowGroup {
      AppView(store: AppState.liveStore)
    }
  }
}

/**
 TODO:
 1. how to read binary files (.ttf, .ttc, .otf)
 2. how to translate binary data into swift objects
 */
