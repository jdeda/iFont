//
//  AppState.swift
//  iFont
//
//  Created by Klajd Deda on 7/5/22.
//

import Foundation
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
    
    var selectedCollection: FontCollection? = nil // TODO: Combine these?
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
                Logger.log("received: \(newFonts.count)")
                state.fonts.append(contentsOf: newFonts)
                state.librarySection = state.librarySection.map {
                    .init(type: $0.type, fonts: $0.fonts + newFonts.filter($0.type.matchingFonts))
                }

                return .none
                
            case let .madeSelection(newSelection):
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
