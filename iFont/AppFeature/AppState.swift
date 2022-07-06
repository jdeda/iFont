//
//  AppState.swift
//  iFont
//
//  Created by Klajd Deda on 7/5/22.
//

import Foundation
import ComposableArchitecture

struct AppState: Equatable {
    // var fontPathURL = "/System/Library/Fonts"
    // var fontPathURL = "/Users/kdeda/Library/Fonts"
    
    // FIXME: jdeda
    // When in production
    // these are some fonts in the project for quick turn around debug/test
    // in production we would use the real machine font paths
    //var fontPathURL = URL(fileURLWithPath: "/System/Library/Fonts")
    var fontPathURL = Bundle.main.resourceURL!.appendingPathComponent("Fonts")
    var fonts = [Font]()
    var fontCollections = [FontCollection]() /// derived
    var selectedItem: FontCollection? = nil
}

enum AppAction: Equatable {
    case onAppear
    case fetchFonts
    case fetchFontsResult(Result<[Font], Never>)
//    case sidebar
//    case selectedItem(ItemType?)
//    case toggleExpand(FontFamily)
//    case sidebarExpandCollapse
//    case clickedDetailSelection(ItemPreviewType)
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
                return environment
                    .fontClient
                    .fetchFonts(state.fontPathURL)
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(AppAction.fetchFontsResult)
                
            case let .fetchFontsResult(.success(newFonts)):
                Logger.log("received: \(newFonts.count)")
                state.fonts.append(contentsOf: newFonts)
                
                // TODO: jdeda
                // Create the Users, Computer FontCollection
                state.fontCollections = [FontCollection]()
                /**
                 Collections belong either in the program itself...
                 or to the file system...
                 how to create this array?
                 - if the font.url is from a specific directory...
                 then it belongs to the collection of that directory
                 thus you need a Dictionary<FontCollection.url, FontCollection>
                 then with that directory...
                 
                    while scanning all fonts
                    if
                    state.fontCollections.forEach { collection in
                        
                    }
                 
                 
                 alternatively
                 - when you are reading, you were given a directory url...
                 so this is the FontCollection url...
                 so stuff the fonts into this collection and you are done
                 */
                
                
                
//                state.fontFamilies = state.fonts
//                    .groupedByFamily()
//                    .sorted(by: { $0.name.caseInsensitiveCompare($1.name) == .orderedAscending })
//
//                state.items = state.fontFamilies.reduce(into: [ItemType](), { partialResult, nextItem in
//                    partialResult.append(nextItem.itemType)
//                    // if family is expanded, add its children to display
//                    if state.familyExpansionState.contains(nextItem.id) {
//                        partialResult.append(contentsOf: nextItem.fonts.map(\.itemType))
//                    }
//                })
                return .none
                
//            case .sidebar:
//                return .none
//
//                // display SelectedFont for each font in this fam
//            case let .selectedItem(selectedItemType):
//                state.selectedItem = selectedItemType
//                if let selectedItem = selectedItemType {
//                    Logger.log("selectedItemType: \(selectedItemType)")
//                }
//                return .none
//
//            case let .toggleExpand(family):
//                if state.familyExpansionState.contains(family.id) {
//                    state.familyExpansionState.remove(family.id)
//                } else {
//                    state.familyExpansionState.insert(family.id)
//                }
//
//                state.items = state.fontFamilies.reduce(into: [ItemType](), { partialResult, nextItem in
//                    partialResult.append(nextItem.itemType)
//                    // if family is expanded, add its children to display
//                    if state.familyExpansionState.contains(nextItem.id) {
//                        partialResult.append(contentsOf: nextItem.fonts.map(\.itemType))
//                    }
//                })
//
//                return .none
//
//            case .sidebarExpandCollapse:
//                NSApp.keyWindow?
//                    .firstResponder?
//                    .tryToPerform(#selector(NSSplitViewController.toggleSidebar), with: nil)
//                return .none
//
//            case let .clickedDetailSelection(newSelection):
//                state.detailSelection = newSelection
//                return .none
            }
        }
    )
        // .debug()
}

extension AppState {
    static let liveState = AppState(fonts: [Font]())
    static let mockState = AppState(
        fontPathURL: URL(fileURLWithPath: "/Users/kdeda/Library/Fonts"),
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
