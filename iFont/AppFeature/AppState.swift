import Foundation
import ComposableArchitecture

struct AppState: Equatable {
    var fontPath = "/System/Library/Fonts"
    var fonts: [Font]
}

enum AppAction: Equatable {
    case onAppear
    case fetchFonts
    case fetchFontsResult(Result<[Font], Never>)
    case sidebar
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
                
            case let .fetchFontsResult(.success(fonts)):
                Logger.log("received: \(fonts.count)")
                state.fonts.append(contentsOf: fonts)
                return .none
                
            case .sidebar:
                return .none
            }
        }
    )
}

extension AppState {
    static let liveState = AppState(fonts: [])
    static let mockState = AppState(
        fontPath: "/Users/kdeda/Library/Fonts",
        fonts: [Font(fontName: "KohinoorBangla")]
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
