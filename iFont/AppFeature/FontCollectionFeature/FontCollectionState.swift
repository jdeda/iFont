import Foundation
import ComposableArchitecture
import AppKit

struct FontCollectionState: Equatable {
    
    var collection: FontCollection
    var items: [ItemType] // Derived from self.collection
//    var selectedItem: ItemType? = nil
    var selectedItem: ItemType? = UserDefaults.standard.getCodable(forKey: "selectedItem")
    var selectedPreview: ItemPreviewType = .sample
    var selectedExpansions = Set<ItemType.ID>()
    
    init(collection: FontCollection) {
        self.collection = collection
        self.items = self.collection.fontFamilies
            .sorted(by: { $0.name < $1.name })
            .map(\.itemType)
    }
}

enum FontCollectionAction: Equatable {
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
            case let .selectedItem(selectedItem):
                // TODO: jdeda - review!
                // make it sticky
                state.selectedItem = selectedItem
                UserDefaults.standard.setCodable(forKey: "selectedItem", value: selectedItem)
                if let unwrapped = selectedItem {
                    Logger.log("selectedItemType: \(unwrapped)")
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
                    // If family is expanded, add its children to display.
                    if state.selectedExpansions.contains(nextItem.id) {
                        partialResult.append(contentsOf: nextItem.fonts.map(\.itemType))
                    }
                })
                
                return .none
                
            case let .selectedPreviewType(selectedPreview):
                state.selectedPreview = selectedPreview
                return .none
            }
        }
    )
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
