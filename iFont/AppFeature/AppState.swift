//
//  AppState.swift
//  iFont
//
//  Created by Klajd Deda on 7/5/22.
//

import AppKit
import ComposableArchitecture

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
    
    var selectedCollection: FontCollection? = nil
    var selectedCollectionState: FontCollectionState? = nil
    // TODO: jdeda
    // Combine these?

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
//                state.selectedCollection = .init(type: .allFontsLibrary, fonts: [])
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
                let debug = false
                if debug {
                    let startTime = Date()
                    defer {
                        let elapsed = startTime.timeIntervalSinceNow * -1000
                        let elapsedString = String(format: "%0.3f", elapsed)
                        Logger.log("completed in: \(elapsedString) ms")
                    }
                    Logger.log("received: \(newFonts.count)")
                }
                state.fonts.append(contentsOf: newFonts)
//                let oldSelection = state.selectedCollection
                
                state.librarySection = state.librarySection.map { fontCollection in
                    let collectionType = fontCollection.type
                    let fonts = fontCollection.fonts
                    let newFonts_ = newFonts.filter(collectionType.matchingFonts)
                    
                    return FontCollection(type: collectionType, fonts: fonts + newFonts_)
                }
                
//                if let oldSelection = oldSelection { // Preserve it ...
//                    let updated = state.librarySection.first(where: { $0.type == oldSelection.type })
//                    return Effect(value: .madeSelection(updated))
//                }
                return .none
                
            case let .madeSelection(newSelection):
                // TODO: jdeda
                // make it sticky
                // 1) write it to the UserDefaults.standard
                // 2) when the app starts, the state inits, you will than read this value from the UserDefaults.standard
                state.selectedCollection = newSelection
                if let unwrapped = newSelection {
                    state.selectedCollectionState = .init(collection: unwrapped)
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
