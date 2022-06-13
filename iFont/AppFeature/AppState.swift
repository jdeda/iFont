import Foundation
import ComposableArchitecture

struct AppState: Equatable {
    // var fontPath = "/System/Library/Fonts"
    var fontPath = "/Users/kdeda/Library/Fonts"
    
    var fonts: [Font]
    var fontFamilies {
        fonts.groupByFamily()
    }
    
  var selectedFontFamily: FontFamily? = nil
}

enum AppAction: Equatable {
  case onAppear
  case fetchFonts
  case fetchFontsResult(Result<FontFamily, Never>)
  case sidebar
  case selectedFontFamily(FontFamily)
}

struct AppEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
  var fontClient: FontClient
}

extension AppState {
  static let reducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    Reducer { state, action, environment in
      switch action {
      case .onAppear:
        return Effect(value: .fetchFonts)
        
      case .fetchFonts:
        return environment
          .fontClient
          .fetchFonts(URL(fileURLWithPath: state.fontPath, isDirectory: true))
          .receive(on: environment.mainQueue)
          .catchToEffect()
          .map(AppAction.fetchFontsResult)
        
      case let .fetchFontsResult(.success(family)):
        Logger.log("received: \(family.fonts.count)")
          state.fonts.append(family)
          state.fontFamilies.append(family)
        return .none
        
      case .sidebar:
        return .none
        
      case let .selectedFontFamily(family):
        state.selectedFontFamily = family
        return .none
      }
    }
  )
}

extension AppState {
  static let liveState = AppState(fontFamilies: [])
  static let mockState = AppState(
    fontPath: "/Users/kdeda/Library/Fonts",
    fontFamilies: [FontFamily(name: "KohinoorBangla", fonts: [Font(name: "KohinoorBangla")])]
  )
}

extension AppState {
  static let liveStore = Store(
    initialState: liveState,
    reducer: AppState.reducer,
    environment: AppEnvironment(
      mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
      fontClient: FontClient.live
    )
  )
  
  static let mockStore = Store(
    initialState: mockState,
    reducer: AppState.reducer,
    environment: AppEnvironment(
      mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
      fontClient: FontClient.live
    )
  )
}
