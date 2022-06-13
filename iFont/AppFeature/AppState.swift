import Foundation
import ComposableArchitecture

struct AppState: Equatable {
    var fontPath = "/System/Library/Fonts"
    //  var fontPath = "/Users/kdeda/Library/Fonts"
    var fonts = [Font]()
    var fontFamilies = [FontFamily]()
    var familyExpansionState = Set<String>()
    var selectedFontFamily: FontFamily? = nil
}

enum AppAction: Equatable {
    case onAppear
    case fetchFonts
    case fetchFontsResult(Result<[Font], Never>)
    case sidebar
    case selectedFontFamily(FontFamily?)
    case toggleExpand(FontFamily)
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
                
            case let .fetchFontsResult(.success(newFonts)):
                Logger.log("received: \(newFonts.count)")
                state.fonts.append(contentsOf: newFonts)
                state.fontFamilies = state.fonts.groupedByFamily().sorted(by: { $0.name.caseInsensitiveCompare($1.name) == .orderedAscending })
                return .none
                
            case .sidebar:
                return .none
                
                // display SelectedFont for each font in this fam
            case let .selectedFontFamily(family):
                state.selectedFontFamily = family
                return .none
                
            case let .toggleExpand(family):
                if state.familyExpansionState.contains(family.name) {
                    state.familyExpansionState.remove(family.name)
                } else {
                    state.familyExpansionState.insert(family.name)
                }
                return .none
            }
        }
    )
}

extension AppState {
    static let liveState = AppState(fonts: [Font]())
    static let mockState = AppState(
        fontPath: "/Users/kdeda/Library/Fonts",
        fonts: [Font(name: "KohinoorBangla", familyName: "KohinoorBangla")]
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
