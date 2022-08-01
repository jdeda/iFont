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

    var fonts: [Font] = []

    // TODO: Jdeda
    // Combine these?
    // This does not support saving expansions and or selections
    // in other FontCollection selections...i.e. if you switch
    // from "Computer" to anything else, then you lose the selection
    // and expansions you had in "Computer".
//    var selectedCollection: FontCollection? = nil
    var selectedCollectionState: FontCollectionState? = nil
    @UserDefaultsValue (
        key: "AppState.persistentSelectedCollectionID",
        defaultValue: ""
    )
    var persistentSelectedCollectionID: FontCollection.ID?

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
}


//// Single Source of Truth (SSOT) for the App.
//struct AppState: Equatable {
//
//    // FIXME: jdeda
//    // When in production, make sure all these paths are in
//    var fontDirectories: Set<URL> = [
//        .init(fileURLWithPath: "/System/Library/Fonts"),
//        //        .init(fileURLWithPath: "/Library/Fonts"),
//        //        .init(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Library/Fonts"),
//        Bundle.main.resourceURL!.appendingPathComponent("Fonts")
//    ]
//
//    var fonts: [Font] = []
//
//    // TODO: Jdeda
//    // Combine these?
//    // This does not support saving expansions and or selections
//    // in other FontCollection selections...i.e. if you switch
//    // from "Computer" to anything else, then you lose the selection
//    // and expansions you had in "Computer".
//    var selectedCollection: FontCollection? = nil
//    var selectedCollectionState: FontCollectionState? = nil
//    @UserDefaultsValue (
//        key: "AppState.persistentSelectedCollectionID",
//        defaultValue: ""
//    )
//    var persistentSelectedCollectionID: String
//
//    var collections: [FontCollection] = [
//            .init(type: .allFontsLibrary, fonts: [], name: "All Fonts"),
//            .init(type: .computerLibrary, fonts: [], name: "Computer"),
//            .init(type: .standardUserLibrary, fonts: [], name: "User"),
//            .init(type: .smart, fonts: [], name: "English"),
//            .init(type: .smart, fonts: [], name: "Fixed Width"),
//            .init(type: .basic, fonts: [], name: "Fun"),
//            .init(type: .basic, fonts: [], name: "Modern"),
//            .init(type: .basic, fonts: [], name: "PDF"),
//            .init(type: .basic, fonts: [], name: "Traditional"),
//            .init(type: .basic, fonts: [], name: "Web")
//
//    ]
//
//    var librarySection: [FontCollection] = [
//        .init(type: .allFontsLibrary, fonts: [], name: "All Fonts"),
//        .init(type: .computerLibrary, fonts: [], name: "Computer"),
//        .init(type: .standardUserLibrary, fonts: [], name: "User"),
//    ]
//
//    var smartSection: [FontCollection] = [
//        .init(type: .smart, fonts: [], name: "English"),
//        .init(type: .smart, fonts: [], name: "Fixed Width")
//    ]
//
//    var normalSection: [FontCollection] = [
//        .init(type: .basic, fonts: [], name: "Fun"),
//        .init(type: .basic, fonts: [], name: "Modern"),
//        .init(type: .basic, fonts: [], name: "PDF"),
//        .init(type: .basic, fonts: [], name: "Traditional"),
//        .init(type: .basic, fonts: [], name: "Web")
//    ]
//}

enum AppAction: Equatable {
    case onAppear
    case fetchFonts
    case fetchFontsResult(Result<[Font], Never>)
    case madeSelection(FontCollection.ID?)
    case fontCollection(FontCollectionAction)
    case sidebarToggle
}

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var fontClient: FontClient
}

extension AppState {
    static let reducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
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
                // state.selectedCollection = UserDefaults.standard.getCodable(forKey: "selectedCollection")
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
                
                // Debug.
                let startTime = Date()
                defer { Log4swift[Self.self].debug("fetchFontsResult received: \(newFonts.count) in: \(startTime.elapsedTime) ms") }
                
                // Add new fonts and update libraries.
                state.fonts.append(contentsOf: newFonts)

                // Update libraries within collections.
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
                
                // Update selection ..
                if let selectedCollection = (state.collections.first { $0.id == state.persistentSelectedCollectionID }) {
                    struct MadeSelectionID: Hashable {}
                    return Effect(value: .madeSelection(selectedCollection.id))
                        .debounce(id: MadeSelectionID(), for: 0.1, scheduler: environment.mainQueue)
                }
                
                return .none
                
                // TODO: jdeda
                // If the user clicks the library in the UI, this runs twice.
                // if the user uses the keyboard, this runs once.
                case let .madeSelection(newSelection):
                    
                    // Debug.
                    let startTime = Date()
                    Log4swift[Self.self].debug("started action: .madeSelection")
                    defer { Log4swift[Self.self].debug("madeSelection completed in: \(startTime.elapsedTime) ms\n") }
                    
                    // Set new selection.
                    state.persistentSelectedCollectionID = newSelection ?? ""
                
                    // Derive FontCollectionState from newSelection.
                    if var fontCollectionID = newSelection {
                        if let index = (state.collections.firstIndex { $0.id == fontCollectionID }) {
                            state.collections[index].fontFamilies = state.collections[index].fonts.groupedByFamily()
                            state.selectedCollectionState = .init(collection: state.collections[index])
                        }
                        else {
                            // TODO: jdeda
                            // Handle this better at some point please, app should not nuke itself.
                            fatalError("Something went horribly wrong...")
                        }
                    }
                    else {
                        state.selectedCollectionState = nil
                    }
                
                    return .none
                
            case let .fontCollection(fontCollectionAction):
                return .none
                
            case .sidebarToggle:
                NSApp.keyWindow?
                    .firstResponder?
                    .tryToPerform(#selector(NSSplitViewController.toggleSidebar), with: nil)
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
