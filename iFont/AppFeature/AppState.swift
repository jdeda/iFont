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
    
    let macOSFontsDirectory: URL = .init(fileURLWithPath: "/System/Library/Fonts")
    
    // FIXME: jdeda
    // When in production, make sure all these paths are in
    // Only libraries can have directories.
    var fontDirectories: Set<URL> = [
        .init(fileURLWithPath: "/System/Library/Fonts"),
        .init(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Library/Fonts"),
        Bundle.main.resourceURL!.appendingPathComponent("Fonts")
    ]
    
    var fonts: [Font] = []
    var allFontsLibrary: FontCollection {
        .init(type: .allLibrary, fonts: fonts, fontFamilies: fonts.groupedByFamily())
    }
    var fontLibraries: [URL: FontCollection] =  [:] // Derived from self.fonts.
    var fontCollections: [String: FontCollection] = [:] // Derived from self.fonts.
    var selectedCollection: FontCollection? = nil
    var selectedCollectionState: FontCollectionState {
        .init()
    }
}

enum AppAction: Equatable {
    case onAppear
    case fetchFonts
    case fetchFontsResult(Result<[Font], Never>)
    case madeSelection(FontCollection?)
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
                
                
                // Nice and imperarative.
                state.fontLibraries = state.fontDirectories.reduce(into: [URL: FontCollection](), { partial, url in
                    if state.macOSFontsDirectory == url {
                        partial[url] = .init(type: .macOSLibrary, fonts: [], fontFamilies: [])
                    }
                    else {
                        partial[url] = .init(type: .library, fonts: [], fontFamilies: [])
                    }
                })
                for font in state.fonts { // N^4
                    for fontDirectoryURL in state.fontDirectories {
                        if font.url.absoluteString.contains(fontDirectoryURL.absoluteString) {
                            state.fontLibraries[fontDirectoryURL]!.fonts.append(font)
                        }
                    }
                }
                
                // This is if you want to know the actual directory a font is in...
                //                // N^2. Could be N if font had a directory field.
                //                for font in state.fonts {
                //                    let fontDirectoryURL = font.url.deletingLastPathComponent()
                //                    print("\n\n\nFinding....")
                //                    print(font.url.absoluteString, "\n")
                //                    print(fontDirectoryURL.absoluteString, "\n")
                //                    state.fontDirectories.forEach {
                //                        print($0.absoluteString, "\n")
                //                    }
                //                    if state.fontDirectories.contains(fontDirectoryURL) {
                //                        state.fontLibraries[fontDirectoryURL]!.fonts.append(font)
                //                    }
                //                    else {
                //                        // Bad news...
                //                    }
                //                    print("Done. \n\n\n")
                //                }
                return .none
                
            case let .madeSelection(newSelection):
                state.selectedCollection = newSelection
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
