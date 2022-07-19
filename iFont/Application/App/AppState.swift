//
//  AppState.swift
//  iFont
//
//  Created by Klajd Deda on 7/5/22.
//

import ComposableArchitecture
import IdentifiedCollections

/*
 
 AppState {
    var fontCollections = IdentifiedArrayOf<FontCollectionState>()
 }
 
 ...
 
 FontCollectionState {
    let id: UUID
    let name: String
 }
 
 FontCollectionAction {
    case fetchFonts
 }
 
 ...
 
 */


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
    
    var fontCollections: IdentifiedArrayOf<FontCollectionState> = [
        // library
        .init(type: .allFontsLibrary, fonts: []),
        .init(type: .computerLibrary, fonts: []),
        .init(type: .standardUserLibrary, fonts: []),
        
        // smart
        .init(type: .smart, fonts: []),
        .init(type: .smart, fonts: []),
        
        // normal
        .init(type: .basic, fonts: []),
        .init(type: .basic, fonts: []),
        .init(type: .basic, fonts: [])
    ].map { FontCollectionState(collection: $0) }
        .identifiedArray
//    var selectedCollection: FontCollection? = nil
//    var selectedCollectionState: FontCollectionState? = nil
    
    var librarySection: [FontCollection] = [
        .init(type: .allFontsLibrary, fonts: []),
        .init(type: .computerLibrary, fonts: []),
        .init(type: .standardUserLibrary, fonts: [])97
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
//    case madeSelection(FontCollection?)
//    case fontCollection(FontCollectionAction)
    case fontCollections(id: FontCollectionState.ID, action: FontCollectionAction)
}

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var fontClient: FontClient
}

extension AppState {
    static let reducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
        FontCollectionState.reducer.forEach(
          state: \.fontCollections,
          action: /AppAction.fontCollections(id:action:),
          environment: {
              .init(
                  mainQueue: $0.mainQueue,
                  fontClient: $0.fontClient
              )
          }
        ),
        
//        FontCollectionState.reducer.optional().pullback(
//            state: \.selectedCollectionState,
//            action: /AppAction.fontCollection,
//            environment: { appEnvironment in
//                    .init(
//                        mainQueue: appEnvironment.mainQueue,
//                        fontClient: appEnvironment.fontClient
//                    )
//            }
//        ),
        Reducer { state, action, environment in
            switch action {
            case .onAppear:
//                state.selectedCollection = UserDefaults.standard.getCodable(forKey: "selectedCollection")
                return Effect(value: .fetchFonts)
                
            case .fetchFonts:
                return environment.fontClient.fetchAllFonts(Array(state.fontDirectories))
                    .receive(on: environment.mainQueue)
                    .catchToEffect(AppAction.fetchFontsResult)
                
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
                
                state.librarySection = state.librarySection.map {
                    FontCollection(
                        type: $0.type,
                        fonts: $0.fonts + newFonts.filter($0.type.matchingFonts)
                    )
                }
                
//                if let oldSelection = oldSelection { // Preserve it ...
//                    // TODO: jdeda
//                    // Setting defaults here every time slows runtime dramatically.
//                    // One should only save selection after everything has loaded in...
//                    let updated = state.librarySection.first(where: { $0.type == oldSelection.type })
//                    return Effect(value: .madeSelection(updated))
//                }
                return .none
                
//            case let .madeSelection(newSelection):
//                // TODO: jdeda - review!
//                // make it sticky
//                // 1) write it to the UserDefaults.standard
//                // 2) when the app starts, the state inits, you will than read this value from the UserDefaults.standard
//                state.selectedCollection = newSelection
////                UserDefaults.standard.setCodable(forKey: "selectedCollection", value: newSelection)
//                if let unwrapped = newSelection {
//                    state.selectedCollectionState = .init(collection: unwrapped)
//                }
//                else {
//                    state.selectedCollectionState = nil
//                }
//                return .none
                
//            case let .fontCollection(fontCollectionAction):
//                return .none
                
                // TODO: Jdeda
                // This is doing a lot of magic behind the scenes
                // This must be refactored to SwiftUI
                
            case .fontCollections:
                return .none
            }
        }
    )
}



extension AppState {
    static let liveStore = Store(
        initialState: AppState(fonts: [Font]()),
        reducer: AppState.reducer,
        environment: AppEnvironment(
            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
            fontClient: FontClient.live
        )
    )
    
    static let mockStore = Store(
        initialState: AppState(
            fontDirectories: [URL(fileURLWithPath: "/Users/kdeda/Library/Fonts")],
            fonts: [Font(
                url: URL(fileURLWithPath: NSTemporaryDirectory()),
                name: "KohinoorBangla",
                familyName: "KohinoorBangla")]
        ),
        reducer: AppState.reducer,
        environment: AppEnvironment(
            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
            fontClient: FontClient.live
        )
    )
}


private extension Array where Element: Identifiable {
    var identifiedArray: IdentifiedArrayOf<Element> {
        .init(uniqueElements: self)
    }
}
