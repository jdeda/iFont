import Foundation
import ComposableArchitecture

struct AppState: Equatable {
    // TODO: jdeda
    // Fix me in production
    // these are some fonts in the project for quick turn around debug/test
    // in production we would use the real machine font paths
    var fontPathURL = Bundle.main.resourceURL!.appendingPathComponent("Fonts")
    var fonts = [Font]()
    var familyExpansionState = Set<String>()
    var fontFamilies: IdentifiedArrayOf<FontFamilyState> = []
    var selectedItem: SelectedItem?
}

enum AppAction: Equatable {
    case onAppear
    case fetchFonts
    case fetchFontsResult(Result<[Font], Never>)
    case sidebar
    case toggleExpand(FontFamily)
    case fontFamily(id: FontFamilyState.ID, action: FontFamilyAction)
}

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var fontClient: FontClient
}

extension AppState {
    static let reducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
        FontFamilyState.reducer.forEach(
          state: \.fontFamilies,
          action: /AppAction.fontFamily(id:action:),
          environment: {
              FontFamilyEnvironment(
                mainQueue: $0.mainQueue,
                fontClient: $0.fontClient
              )}
        ),
        Reducer { state, action, environment in
            switch action {
            case .onAppear:
                return Effect(value: .fetchFonts)
                
            case .fetchFonts:
                return environment
                    .fontClient
                    .fetchFonts(state.fontPathURL)
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(AppAction.fetchFontsResult)
                
            case let .fetchFontsResult(.success(newFonts)):
                Logger.log("received: \(newFonts.count)")
                state.fonts.append(contentsOf: newFonts)
                let temp = state.fonts
                    .groupedByFamily()
                    .sorted(by: { $0.name.caseInsensitiveCompare($1.name) == .orderedAscending })
                    .map(FontFamilyState.init)
                
                state.fontFamilies = IdentifiedArrayOf(uniqueElements: temp)
                return .none
                
            case .sidebar:
                return .none
                
            case let .toggleExpand(family):
                if state.familyExpansionState.contains(family.name) {
                    state.familyExpansionState.remove(family.name)
                } else {
                    state.familyExpansionState.insert(family.name)
                }
                return .none
                
            case let .fontFamily(familyID, subAction):
                Logger.log("familyID: \(familyID) subAction: \(subAction)")
                return .none
            }
        }
    )
        .debug()
}

extension AppState {
    static let liveState = AppState(fonts: [Font]())
    static let mockState = AppState(
        fontPathURL: URL(fileURLWithPath: "/Users/kdeda/Library/Fonts"),
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
