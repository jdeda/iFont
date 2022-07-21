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
    var selectedCollection: FontCollection? = nil
    var selectedCollectionState: FontCollectionState? = nil
    
    var librarySection: [FontCollection] = [
        .init(type: .allFontsLibrary, fonts: []),
        .init(type: .computerLibrary, fonts: []),
        .init(type: .standardUserLibrary, fonts: [])
    ]
    
    var smartSection: [FontCollection] = [
        .init(type: .smart, fonts: []),
        .init(type: .smart, fonts: []),
    ]
    
    var normalSection: [FontCollection] = [
        .init(type: .basic, fonts: []),
        .init(type: .basic, fonts: []),
        .init(type: .basic, fonts: [])
    ]
}

enum AppAction: Equatable {
    case onAppear
    case fetchFonts
    case fetchFontsResult(Result<[Font], Never>)
    case madeSelection(FontCollection?)
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
                defer { Log4swift[Self.self].debug("completed in: \(startTime.elapsedTime) ms") }
                Log4swift[Self.self].debug("received: \(newFonts.count)")
                
                // Add new fonts and update libraries.
                state.fonts.append(contentsOf: newFonts)
                state.librarySection = state.librarySection.map {
                    .init(type: $0.type, fonts: $0.fonts + newFonts.filter($0.type.matchingFonts))
                }
                
                // TODO: jdeda
                // UserDefaults should only save selection when program ends...it is very slow.
                if let selectedCollection = state.selectedCollection { // Preserve it ...
                    let updated = state.librarySection.first(where: { $0.type == selectedCollection.type })
                    return Effect(value: .madeSelection(updated))
                }
                return .none
                
                // TODO: jdeda
                // If the user clicks the library in the UI, 2this runs twice.
                // if the user uses the keyboard, this runs once.
            case let .madeSelection(newSelection):
                
                // Debug.
                let startTime = Date()
                print("\nstarted action: .madeSelection")
                defer { print("completed in: \(startTime.elapsedTime) ms\n") }
                
                // TODO: jdeda - review!
                // Make the selection sticky
                // 1) write it to the UserDefaults.standard
                // 2) when the app starts, the state inits, you will than read this value from the UserDefaults.standard
                
                // UserDefaults.standard.setCodable(forKey: "selectedCollection", value: newSelection)
                
                // Set new selection.
                state.selectedCollection = newSelection
                if var fontCollection = newSelection {
                    fontCollection.fontFamilies = fontCollection.fonts.groupedByFamily()
                    state.selectedCollectionState = .init(collection: fontCollection)
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
