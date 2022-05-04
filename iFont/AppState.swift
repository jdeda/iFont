import ComposableArchitecture

struct AppState: Equatable {
  
}

enum AppAction: Equatable {
case clickedViewAllFontsButton
}

struct AppEnvironment {}

let AppReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
  Reducer { state, action, environment in
    switch action {
    case .clickedViewAllFontsButton:
      return .none
    }
  }
)
