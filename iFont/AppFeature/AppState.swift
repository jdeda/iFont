//
//  AppState.swift
//  iFont
//
//  Created by Klajd Deda on 7/5/22.
//

import AppKit
import ComposableArchitecture
import Log4swift
import SwiftCommons

// Single Source of Truth (SSOT) for the App.
struct AppState: Equatable {

    // FIXME: jdeda
    // When in production, make sure all these paths are in
    var fontDirectories: Set<URL> = [
        .init(fileURLWithPath: "/System/Library/Fonts"),
        //        .init(fileURLWithPath: "/Library/Fonts"),
        //        .init(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Library/Fonts"),
        Bundle.main.resourceURL!.appendingPathComponent("Fonts")
    ]

    // TODO: jdeda
    // These are never used anywhere...
    var fonts: [Font] = []

    // TODO: Jdeda
    // Combine these? Also, maybe better to have an array
    // so the app doesn't have to recompute the state?
    var selectedCollectionState: FontCollectionState?
    @UserDefaultsValue (
        key: "AppState.persistentSelectedCollectionID",
        defaultValue: ""
    )
    var selectedCollectionID: FontCollection.ID?

    var collections: [FontCollection] = [
            .init(type: .allFontsLibrary, fonts: [], name: "All Fonts"),
            .init(type: .computerLibrary, fonts: [], name: "Computer"),
            .init(type: .standardUserLibrary, fonts: [], name: "User"),
            .init(type: .smart, fonts: [], name: "English"),
            .init(type: .smart, fonts: [], name: "Fixed Width"),
            .init(type: .basic, fonts: [], name: "Fun"),
            .init(type: .basic, fonts: [], name: "Modern"),
            .init(type: .basic, fonts: [], name: "PDF"),
            .init(type: .basic, fonts: [], name: "Traditional"),
            .init(type: .basic, fonts: [], name: "Web")
    ]
    
    var sidebar: SidebarState = .init(collections: [])
}

enum AppAction: Equatable {
    case onAppear
    case fetchFonts
    case fetchFontsResult(Result<[Font], Never>)
    case fontCollection(FontCollectionAction)
    case sidebar(SidebarAction)
    case sidebarSelection(FontCollection.ID?)
}

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var fontClient: FontClient
}

extension AppState {
    static let reducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
        SidebarState.reducer.pullback(
            state: \.sidebar,
            action: /AppAction.sidebar,
            environment: { _ in .init() }
        ),
        FontCollectionState.reducer.optional().pullback(
            state: \.selectedCollectionState,
            action: /AppAction.fontCollection,
            environment: { appEnvironment in
                    .init(
                        mainQueue: appEnvironment.mainQueue,
                        fontClient: appEnvironment.fontClient
                    )
            }
        ),
        Reducer { state, action, environment in
            switch action {
            case .onAppear:
                return Effect(value: .fetchFonts)
                
            case .fetchFonts:
                let foo = state.fontDirectories
                    .publisher
                    .flatMap {
                        environment.fontClient.fetchFonts($0)
                    }
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(AppAction.fetchFontsResult)
                
                return foo
                
            case let .fetchFontsResult(.success(newFonts)):
                
                let startTime = Date()
                defer { Log4swift[Self.self].debug("fetchFontsResult received: \(newFonts.count) in: \(startTime.elapsedTime) ms") }
                
                state.fonts.append(contentsOf: newFonts)

                state.collections = state.collections.map {
                    if $0.type.isLibrary {
                        return .init(
                            type: $0.type,
                            fonts: $0.fonts + newFonts.filter($0.type.matchingFonts),
                            name: $0.name
                        )
                    }
                    else {
                        return $0
                    }
                }
            
                state.sidebar = .init(selectedCollection: state.selectedCollectionID, collections: state.collections)
                
                struct SidebarSelectionID: Hashable {}
                return Effect(value: .sidebarSelection(state.sidebar.selectedCollection))
                    .debounce(id: SidebarSelectionID(), for: 0.1, scheduler: environment.mainQueue)
                
            case let .fontCollection(fontCollectionAction):
                return .none
                
            case let .sidebar(sidebarAction):
                switch sidebarAction {
                case .binding(\.$selectedCollection):
                    return Effect(value: .sidebarSelection(state.sidebar.selectedCollection))
                case .binding:
                    return .none
                }
                
            case let .sidebarSelection(newSelectionID):
                
                let startTime = Date()
                Log4swift[Self.self].debug("started action: .madeSelection")
                defer { Log4swift[Self.self].debug("madeSelection completed in: \(startTime.elapsedTime) ms\n") }
                   
                guard var newSelection = state.collections.first(where: { $0.id == newSelectionID})
                else { return .none }
                newSelection.fontFamilies = newSelection.fonts.groupedByFamily()
                
                state.selectedCollectionID = newSelectionID
                state.selectedCollectionState = .init(collection: newSelection)
                
                return .none
            }
        }
    )
}

extension AppState {
    static let liveState = AppState(fonts: [Font]())
    static let mockState = AppState(
        fontDirectories: [URL(fileURLWithPath: "/Users/kdeda/Library/Fonts")],
        fonts: [Font(
            url: URL(fileURLWithPath: NSTemporaryDirectory()),
            name: "KohinoorBangla",
            familyName: "KohinoorBangla")]
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
