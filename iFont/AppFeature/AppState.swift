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
    
    // TODO: Jdeda
    // Combine these? Also, maybe better to have an array
    // so the app doesn't have to recompute the state
    // and you keep selections, etc.
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
    
    var sidebar: SidebarState = .init()
    var newLibrary: FontCollection = .init(type: .basic, name: "Untitled")
    
    private func getDefaultName() -> String {
        var count = 1
        var name = "Untitled"
        while true {
            if collections.contains(where: { $0.name == name }) {
                name = "Untitled \(count)"
            }
            else {
                return name
            }
            count += 1
        }
    }
    
    private func validName(_ name: String) -> Bool {
        collections.contains { $0.name == name }
    }
}

enum AppAction: Equatable {
    case onAppear
    case fetchAllFonts
    case fetchAllFontsResult(Result<[Font], Never>)
    case sidebar(SidebarAction)
    case sidebarSelection(FontCollection.ID?)
    case fontCollection(FontCollectionAction)
    case createNewLibrary(URL)
    case createNewLibraryFontsResult([Font])
    case createNewLibraryCompleted
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
                return Effect(value: .fetchAllFonts)
                
            case .fetchAllFonts:
                let foo = state.fontDirectories
                    .publisher
                    .flatMap {
                        environment.fontClient.fetchFonts($0)
                    }
                    .receive(on: environment.mainQueue)
                    .catchToEffect(AppAction.fetchAllFontsResult)
//                    .catchToEffect()
//                    .map(AppAction.fetchAllFontsResult)
                // rename handleNewFonts or fetchAllFontsCompletion
                
                return foo
                
            case let .fetchAllFontsResult(.success(newFonts)):
                let startTime = Date()
                defer { Log4swift[Self.self].debug("fetchFontsResult received: \(newFonts.count) in: \(startTime.elapsedTime) ms") }
                
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
                    .debounce(id: SidebarSelectionID(), for: 0.05, scheduler: environment.mainQueue)

            case let .fetchAllFontsResult(.failure(error)):
                return .none

                
            case .sidebar(.binding(\.$selectedCollection)):
                return Effect(value: .sidebarSelection(state.sidebar.selectedCollection))
                
            case let .sidebar(action):
                guard let (rowID, rowAction) = (/SidebarAction.row).extract(from: action)
                else { return .none }
                
                guard let index = state.collections.firstIndex(where: { $0.id == rowID })
                else { return .none }
                
                switch rowAction {
                case let .newLibrary(directory): // Popup menu.
                    return Effect(value: .createNewLibrary(directory))
                    
                case let .newSmartCollection(filter, baseID): // Popup menu.
//                    return Effect(value: .createNewSmartCollection(filter, baseID))
                    return .none
                    
                case .newBasicCollection: // Create a new one
//                    return Effect(value: .createNewBasicCollection)
                    state.collections.append(.init(type: .basic, name: state.getDefaultName()))
                    state.selectedCollectionID = state.collections.last!.id
                    state.sidebar = .init(selectedCollection: state.selectedCollectionID, collections: state.collections)
                    return .none
                    
                case .rename: // How?
                    if !state.collections[index].type.canRenameOrDelete {
                        // Do...
                    }
                    state.sidebar = .init(selectedCollection: state.selectedCollectionID, collections: state.collections)
                    return .none
                    
                case .delete: // Delete at index.
                    if state.collections[index].type.canRenameOrDelete {
                        state.collections.remove(at: index)
                    }
                    state.sidebar = .init(selectedCollection: state.selectedCollectionID, collections: state.collections)
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
                
            case let .fontCollection(fontCollectionAction):
                return .none
                
            case let .createNewLibrary(directory):
                state.newLibrary = .init(
                    type: .library(directory),
                    name: state.getDefaultName()
                )
                state.collections.append(state.newLibrary)
                // state.newLibraryFetching = true
                
                let fetchFonts = environment.fontClient.fetchFonts(directory)
                    .receive(on: environment.mainQueue)
                    .eraseToEffect(AppAction.createNewLibraryFontsResult)
                let completed = Effect<AppAction, Never>(value: AppAction.createNewLibraryCompleted)
                
                return Effect.concatenate(fetchFonts, completed)

            case let .createNewLibraryFontsResult(libraryID, newFonts):
                // if u open a directory w/ no file u will never get here
                
                // Update all fonts and its dependencies!
                // If somehow the name of the library changes while being updated...
                // If someone added or removed the library while being updated...
                // Then tactical nuke...
                
                // Update newLibrary.
                state.newLibrary.fonts.append(contentsOf: newFonts)
                
                // Put newLibrary in all the collections.
                let newLibraryIndex = state.collections.firstIndex(where: { $0.name == state.newLibrary.name })!
                state.collections[newLibraryIndex].fonts.append(contentsOf: newFonts)
                
                // Update allFonts.
                let allFontsIndex = state.collections.firstIndex(where: { $0.type == .allFontsLibrary })!
                state.collections[allFontsIndex].fonts.append(contentsOf: newFonts)
                
                // Update sidebar.
                state.sidebar = .init(selectedCollection: state.newLibrary.id, collections: state.collections)

                return .none
                
            case .createNewLibraryCompleted:
                // state.newLibraryFetching = false
                return .none


            }
        }
    )
}

extension AppState {
    static let liveState = AppState()
    static let mockState = AppState(
        fontDirectories: [URL(fileURLWithPath: "/Users/kdeda/Library/Fonts")]
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
