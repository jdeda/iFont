//
//  AppState.swift
//  iFont
//
//  Created by Klajd Deda on 7/5/22.
//

import Foundation
import ComposableArchitecture

struct AppState: Equatable {
    
    /** Immutable. App must have these. App must load these before launching...? */
    let macOSFontsDirectory: URL = .init(fileURLWithPath: "/System/Library/Fonts")
    let macOSFonts: [FontCollection]
    
    var fontDirectories: [URL] = [
        .init(fileURLWithPath: "/System/Library/Fonts"),
        .init(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Library/Fonts"),
        Bundle.main.resourceURL!.appendingPathComponent("Fonts")
    ]
    
    var fonts: [Font] = []
    var fontLibraries: [URL: FontCollection] =  [:]
    var fontCollections: [String: FontCollection] = [:]
    var selectedCollection: FontCollection? = nil
}

enum AppAction: Equatable {
    case onAppear
    case fetchFonts
    case fetchFontsResult(Result<[Font], Never>)
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
                Logger.log("received: \(newFonts[0].url.path)")
                
                state.fonts.append(contentsOf: newFonts)
                
                return .none
                
            }
        }
    )
        // .debug()
}

//// This is the source of truth for my app
//// also referred as: SSOT
//struct AppState: Equatable {
//    // FIXME: jdeda
//    // When in production
//    // make sure all these paths are in
//    var builtInURLs = [
//        URL(fileURLWithPath: "/System/Library/Fonts"),
//        URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Library/Fonts"),
//        Bundle.main.resourceURL!.appendingPathComponent("Fonts")
//    ]
//    var fonts = [Font]()
//    var fontLibraries = FontCollection.fontLibraries // fonts are derived from self.fonts
//    var fontCollections = [FontCollection]() /// derived
//    var selectedItem: FontCollection? = nil
//}
//
//enum AppAction: Equatable {
//    case onAppear
//    case fetchFonts
//    case fetchFontsResult(Result<[Font], Never>)
//}
//
//struct AppEnvironment {
//    var mainQueue: AnySchedulerOf<DispatchQueue>
//    var fontClient: FontClient
//}
//
//extension AppState {
//    static let reducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
//        Reducer { state, action, environment in
//            switch action {
//            case .onAppear:
//                return Effect(value: .fetchFonts)
//
//            case .fetchFonts:
//                let foo = state.builtInURLs
//                    .publisher
//                    .flatMap {
//                        environment.fontClient.fetchFonts($0)
//                    }
//                    .receive(on: environment.mainQueue)
//                    .catchToEffect()
//                    .map(AppAction.fetchFontsResult)
//
//                return foo
//
//            case let .fetchFontsResult(.success(newFonts)):
//                // Logger.log("received: \(newFonts.count)")
//                Logger.log("received: \(newFonts[0].url.path)")
//
//                state.fonts.append(contentsOf: newFonts)
//                // TODO: jdeda
//                // Derive fontLibraries and fontCollections.
//                // Initially do it here. Could make a new effect to handle this (if its alot)
//
//
//                return .none
//
//            }
//        }
//    )
//        // .debug()
//}

extension AppState {
    static let liveState = AppState(fonts: [Font]())
    static let mockState = AppState(
        builtInURLs: [URL(fileURLWithPath: "/Users/kdeda/Library/Fonts")],
        fonts: [Font(
            url: URL.init(fileURLWithPath: NSTemporaryDirectory()),
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
