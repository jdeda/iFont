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
        defaultValue: UUID()
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
    case createNewLibraryFontsResult(libraryID: FontCollection.ID, fonts: [Font])
    case createNewLibraryCompleted
    case deleteCollection(FontCollection.ID)
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
            
            struct CreateFontCollectionID: Hashable {}
            
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
                
                
            // TODO: This executes twice everytime...why? Debounce hot fixes it but...this is a band-aid.
            case .sidebar(.binding(\.$selectedCollection)):
                struct SidebarSelectionUpdateID: Hashable {}
                return Effect(value: .sidebarSelection(state.sidebar.selectedCollection))
                    .debounce(id: SidebarSelectionUpdateID(), for: 0.05, scheduler: environment.mainQueue)

            case let .sidebar(action):
                
//                /**
//                 Must know which row...
//                 */
//                if let droppedItem = (/SidebarAction.recievedFontCollectionItemDrop).extract(from: action) {
//                    return Effect(value: .processItemDrop(droppedItem))
//                }

                guard let (rowID, rowAction) = (/SidebarAction.row).extract(from: action)
                else { return .none }
                
                guard let index = state.collections.firstIndex(where: { $0.id == rowID })
                else { return .none }
                
                switch rowAction {
                case let .newLibrary(directory):
                    return Effect(value: .createNewLibrary(directory))
                    
                case let .newSmartCollection: // Popup menu.
                    return .none
                    
                case .newBasicCollection: // Create a new one
                    state.collections.append(.init(type: .basic, name: state.getDefaultName()))
                    state.selectedCollectionID = state.collections.last!.id
                    state.sidebar = .init(selectedCollection: state.selectedCollectionID, collections: state.collections)
                    return .none
                    
                case .rename: // How?
//                    if !state.collections[index].type.canRenameOrDelete {
//                        // Do...
//                    }
//                    state.sidebar = .init(selectedCollection: state.selectedCollectionID, collections: state.collections)
                    return .none
                    
                case .delete:
                    return Effect(value: .deleteCollection(rowID))
                
                case let .renameInTextField(newName):
                    // TODO: Jdeda
                    // Must handle invalid renaming!
                    // i.e. have an alert!

                    state.collections[index].name = newName
                    state.selectedCollectionState?.collection.name = newName
                    return .none
                    
                case let .recievedFontCollectionItemDrop(drop):
                    // dnd -> itemCodable -> fonts
                    // check if selected state needs to be updated
                    // tho tech this is impossible
                    let item = unyummers(drop)
                    switch item {
                    case let .font(font):
                        state.collections[index].fonts.append(font)
                    case let .fontFamily(family):
                        state.collections[index].fonts.append(contentsOf: family.fonts)
                    }
//                    state.collections[index].fonts.app
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
                let newLibrary = FontCollection(type: .library(directory), name: state.getDefaultName())
                state.collections.append(newLibrary)
                
                let fetchFonts = environment.fontClient.fetchFonts(directory)
                    .receive(on: environment.mainQueue)
                    .eraseToEffect()
                    .map {
                        AppAction.createNewLibraryFontsResult(libraryID: newLibrary.id, fonts: $0)
                    }
                
                let fetchFontsCompletion = Effect<AppAction, Never>(value: AppAction.createNewLibraryCompleted)
                
                return Effect.concatenate(fetchFonts, fetchFontsCompletion)
                    .cancellable(id: CreateFontCollectionID())
                
            case let .createNewLibraryFontsResult(libraryID, newFonts):
                // If you open an empty directory you will never get here.
                // Indexing here is dangerous.
                
                // Update the new library.
                let newLibraryIndex = state.collections.firstIndex(where: { $0.id == libraryID })!
                state.collections[newLibraryIndex].fonts.append(contentsOf: newFonts)
                
                // Update the allFonts collection.
                let allFontsIndex = state.collections.firstIndex(where: { $0.type == .allFontsLibrary })!
                state.collections[allFontsIndex].fonts.append(contentsOf: newFonts)
                
                state.sidebar = .init(selectedCollection: state.selectedCollectionID, collections: state.collections)
                return .none
                
            case .createNewLibraryCompleted:
                return .none
                
            case let .deleteCollection(collectionID):
                // Indexing here is dangerous.
                
                // Delete collection with matchingID
                let deletionIndex = state.collections.firstIndex(where: { $0.id == collectionID })!
                if state.collections[deletionIndex].type.canRenameOrDelete {
                    state.collections.remove(at: deletionIndex)
                    
                    // Recompute allFonts collection.
                    let allFontIndex = state.collections.firstIndex(where: { $0.type == .allFontsLibrary })!
                    state.collections[allFontIndex].fonts = state.collections.reduce(into: []) { partial, collection in
                        if collection.type.isLibrary && collection.type != .allFontsLibrary {
                            partial.append(contentsOf: collection.fonts)
                        }
                    }
                }
                
                // Update selection.
                if state.selectedCollectionID == collectionID {
                    state.selectedCollectionID = nil
                    state.selectedCollectionState = nil
                }
                
                // Update sidebar.
                state.sidebar = .init(selectedCollection: state.selectedCollectionID, collections: state.collections)
                
                // Cancel effect that would be adding fonts to this specific collection.
                // TODO: Jdeda
                // This is currently canceling any font creation effect.
                return .cancel(id: CreateFontCollectionID())
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
