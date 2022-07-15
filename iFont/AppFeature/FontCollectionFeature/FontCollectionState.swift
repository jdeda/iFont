import Foundation
import ComposableArchitecture
import AppKit

struct FontCollectionState: Equatable {
    
    // Basically this is what is going on.
    var collection: FontCollection
    var items: [ItemType]
    var selectedItem: ItemType? = nil
    var selectedPreview: ItemPreviewType = .sample
    var selectedExpansions = Set<ItemType.ID>()
    
    init(collection: FontCollection) {
        self.collection = collection
        self.items = self.collection.fontFamilies
            .sorted(by: { $0.name < $1.name })
            .map(\.itemType)
    }
    //    // FIXME: jdeda
    //    // When in production
    //    // these are some fonts in the project for quick turn around debug/test
    //    // in production we would use the real machine font paths
    ////    var fontPathURL = URL(fileURLWithPath: "/Users/kdeda/Library/Fonts")
    ////    var fontPathURL = URL(fileURLWithPath: "/System/Library/Fonts")
    //    var fontPathURL = Bundle.main.resourceURL!.appendingPathComponent("Fonts")
    //
    //    var fonts = [Font]()
    //    var familyExpansionState = Set<ItemType.ID>()
    //    var selectedItem: ItemType? = nil
    //
    //    /// derived
    //    var fontFamilies = [FontFamily]()
    //    /// derived
    //    var items = [ItemType]()
    //
    //    var detailSelection: ItemPreviewType = .sample
}

enum FontCollectionAction: Equatable {
//    case onAppear
    //    case fetchFonts
    //    case fetchFontsResult(Result<[Font], Never>)
    //    case sidebar
    //    case sidebarExpandCollapse
    case selectedItem(ItemType?)
    case toggleExpand(FontFamily)
    case selectedPreviewType(ItemPreviewType)
}

struct FontCollectionEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var fontClient: FontClient
}

extension FontCollectionState {
    static let reducer = Reducer<FontCollectionState, FontCollectionAction, FontCollectionEnvironment>.combine(
        Reducer { state, action, environment in
            switch action {
//            case .onAppear:
//                state.items = state.collection.fontFamilies.reduce(into: [ItemType](), { partial, family in
//                    partial.append(family.itemType)
//                })
//                return .none
                //
                //            case .fetchFonts:
                //                return environment
                //                    .fontClient
                //                    .fetchFonts(state.fontPathURL)
                //                    .receive(on: environment.mainQueue)
                //                    .catchToEffect()
                //                    .map(FontCollectionAction.fetchFontsResult)
                //
                //            case let .fetchFontsResult(.success(newFonts)):
                //                Logger.log("received: \(newFonts.count)")
                //                state.fonts.append(contentsOf: newFonts)
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
                //                return .none
                //
                //            case .sidebar:
                //                return .none
                //
                //                // display SelectedFont for each font in this fam
            case let .selectedItem(selectedItemType):
                // TODO: jdeda
                // make it sticky
                state.selectedItem = selectedItemType
                if let selectedItem = selectedItemType {
                    Logger.log("selectedItemType: \(selectedItemType)")
                }
                return .none
                
            case let .toggleExpand(family):
                if state.selectedExpansions.contains(family.id) {
                    state.selectedExpansions.remove(family.id)
                } else {
                    state.selectedExpansions.insert(family.id)
                }
                
                state.items = state.collection.fontFamilies.reduce(into: [ItemType](), { partialResult, nextItem in
                    partialResult.append(nextItem.itemType)
                    // if family is expanded, add its children to display
                    if state.selectedExpansions.contains(nextItem.id) {
                        partialResult.append(contentsOf: nextItem.fonts.map(\.itemType))
                    }
                })
                
                return .none
                
                //            case .sidebarExpandCollapse:
                //                NSApp.keyWindow?
                //                    .firstResponder?
                //                    .tryToPerform(#selector(NSSplitViewController.toggleSidebar), with: nil)
                //                return .none
                
            case let .selectedPreviewType(selectedPreview):
                state.selectedPreview = selectedPreview
                return .none
            }
        }
    )
    // .debug()
}

extension FontCollectionState {
    static let liveState =  FontCollectionState(collection: .init())
    static let mockState = FontCollectionState(collection: .init(
        type: .library(URL(fileURLWithPath: NSTemporaryDirectory())),
        fonts: [Font(
            url: URL(fileURLWithPath: NSTemporaryDirectory()),
            name: "KohinoorBangla",
            familyName: "KohinoorBangla")]
    ))
    //    static let mockState = .init(collection:
    //            .init(
    //    )
    //    static let mockState = FontCollectionState(
    //        fontPathURL: URL(fileURLWithPath: "/Users/kdeda/Library/Fonts"),
    //        fonts: [Font(
    //            url: URL.init(fileURLWithPath: NSTemporaryDirectory()),
    //            name: "KohinoorBangla",
    //            familyName: "KohinoorBangla")]
    //    )
}

extension FontCollectionState {
    static let liveStore = Store(
        initialState: liveState,
        reducer: FontCollectionState.reducer,
        environment: FontCollectionEnvironment(
            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
            fontClient: FontClient.live
        )
    )
    
    static let mockStore = Store(
        initialState: mockState,
        reducer: FontCollectionState.reducer,
        environment: FontCollectionEnvironment(
            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
            fontClient: FontClient.live
        )
    )
}
