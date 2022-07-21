import Foundation
import ComposableArchitecture
import AppKit

struct FontCollectionState: Equatable {
    
    var collection: FontCollection
    var items: [ItemType] // Derived from self.collection
    var selectedItemID: ItemType.ID? = nil
    // var selectedItem: ItemType? = UserDefaults.standard.getCodable(forKey: "selectedItem")
    // wip
    var selectedPreview: ItemPreviewType = .sample
    var selectedExpansions = Set<ItemType.ID>()
    
    var selectedItem: ItemType? {
        items.first(where: { $0.id == selectedItemID })
    }

    init(collection: FontCollection) {
        self.collection = collection
        self.items = self.collection.fontFamilies.map(\.itemType)
    }
}

enum FontCollectionAction: Equatable {
    case selectedItemID(ItemType.ID?)
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
            case let .selectedItemID(selectedItemID):
                // TODO: jdeda - review!
                // make it sticky
                
                state.selectedItemID = selectedItemID
                // UserDefaults.standard.setCodable(forKey: "selectedItem", value: selectedItem)
                // wip
                
                if let index = state.items.firstIndex(where: { $0.id == selectedItemID }) {
                    let itemType = state.items[index]

                    Logger.log("selectedItemType: \(itemType)")
                    switch itemType {
                    case .font: ()
                    case let .fontFamily(fontFamily):
                        state.items[index] = fontFamily.fontsSortedByName.itemType
                    }
                }
                return .none
                
                // TODO: jdeda - review!
                // Fix bug where upon the first time making a new expansion, the list resorts of the sort.
                // The list is probably being updated entirely when it shouldn't
                // There is another bug where there are duplicate fonts which break expansions
                // i.e. the fonts will display after expanded, but remain displayed even if
                // expansion is unexpanded, and which consecutive expansions wil show other
                // fonts...maybe this is some id issues between families and or fonts...
            case let .toggleExpand(family):
                if state.selectedExpansions.contains(family.id) {
                    state.selectedExpansions.remove(family.id)
                } else {
                    state.selectedExpansions.insert(family.id)
                }
                
                // The "resorting/reshuffling" is occuring because you are reducing over the state.fontFamilies
                // which has no particular order but the state.items does...thus obviously you lose order and
                // this explains why it only happens once...items are sorted at init time
                state.items = state.collection.fontFamilies.reduce(into: [ItemType](), { partialResult, fontFamily in
                    partialResult.append(fontFamily.itemType)
                    
                    // If family is expanded, add its children to display.
                    if state.selectedExpansions.contains(fontFamily.id) {
                        partialResult.append(contentsOf: fontFamily.fontsSortedByName.fonts.map(\.itemType))
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
