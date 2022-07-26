import Foundation
import ComposableArchitecture
import AppKit

struct FontCollectionState: Equatable {
    var collection: FontCollection
    
    var items: [FontCollectionItem] // Derived from self.collection
    @BindableState var selectedItemID: FontCollectionItem.ID?
    var selectedItem: FontCollectionItem?
    
    // var selectedItem: ItemType? = UserDefaults.standard.getCodable(forKey: "selectedItem")
    // wip
    var selectedExpansions = Set<FontCollectionItem.ID>()
    var selectedPreview: FontCollectionItemPreviewType = .sample
    
    init(collection: FontCollection) {
        self.collection = collection
        self.items = self.collection.fontFamilies.map(\.itemType)
    }
}

enum FontCollectionAction: BindableAction, Equatable {
    case binding(BindingAction<FontCollectionState>)
    case toggleExpand(FontFamily)
    case selectedPreviewType(FontCollectionItemPreviewType)
}

struct FontCollectionEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var fontClient: FontClient
}

extension FontCollectionState {
    static let reducer = Reducer<FontCollectionState, FontCollectionAction, FontCollectionEnvironment>.combine(
        Reducer { state, action, environment in
            switch action {
            case .binding(\.$selectedItemID):
                // TODO: jdeda - review!
                // make it sticky
                // UserDefaults.standard.setCodable(forKey: "selectedItem", value: selectedItem)
                // wip
                
                if let index = state.items.firstIndex(where: { $0.id == state.selectedItemID }) {
                    let itemType = state.items[index]
                    
                    state.selectedItem = itemType
                    Logger.log("selectedItemType: \(itemType)")
                    switch itemType {
                    case .font: ()
                    case let .fontFamily(fontFamily):
                        state.items[index] = fontFamily.fontsSortedByName.itemType
                    }
                } else {
                    state.selectedItem = nil
                }
                return .none
                
            case .binding:
                return .none
                
                // TODO: jdeda
                // There is a bug where expanding a family causes that family fonts to merge into another family
                // (perhaps the one selected before it) and the family dissapears (the one that was supposed to be expanded).
                // Upon unexpanding the family that merged the other family, there are duplicates left.
            case let .toggleExpand(family):
                if state.selectedExpansions.contains(family.id) {
                    state.selectedExpansions.remove(family.id)
                } else {
                    state.selectedExpansions.insert(family.id)
                }
                
                state.items = state.collection.fontFamilies.reduce(into: [FontCollectionItem](), { partialResult, fontFamily in
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
            .binding()
    )
}

extension FontCollectionState {
    static let liveState =  FontCollectionState(collection: .init())
    static let mockState = FontCollectionState(collection: .init(
        type: .library(URL(fileURLWithPath: NSTemporaryDirectory())),
        fonts: (1...10).map {
            .init(
                url: URL(fileURLWithPath: NSTemporaryDirectory()),
                name: "Chicken \($0)",
                familyName: "Cheese \($0)"
            )
        },
        fontFamilies: (1...10).map {
            .init(
                url: URL(fileURLWithPath: NSTemporaryDirectory()),
                name: "Chicken \($0)",
                familyName: "Cheese \($0)"
            )
        }.groupedByFamily()
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
