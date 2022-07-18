import SwiftUI
import ComposableArchitecture

extension ItemPreviewType {
    var image: Image {
        switch self {
        case .sample:
            return Image(systemName: "text.aligncenter")

        case .repertoire:
            return Image(systemName: "square.grid.2x2")
            
        case .custom:
            return Image(systemName: "character.cursor.ibeam")
            
        case .info:
            return Image(systemName: "info.circle")
        }
    }
}

struct FontCollectionView: View {
    let store: Store<FontCollectionState, FontCollectionAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                
                // The First Column
                VStack(spacing: 0) {
                    // TODO: Jdeda
                    // Animate expansions
                    // Display fonts face not ugly name
                    List(selection: viewStore.binding(
                        get: \.selectedItem,
                        send: FontCollectionAction.selectedItem
                    )) {
                        ForEach(viewStore.items) { item in
                            ItemTypeRowView(store: store, itemType: item)
                                .tag(item)
                        }
                    }
                    Divider()
                    Text("Font count: \(viewStore.collection.fonts.count)")
                        .padding(5)
                }
                
                // The Second Column, or the detail
                VStack {
                    switch viewStore.selectedItem {
                    case let .some(item):
                        ItemTypePreview(store: store, selection: viewStore.selectedPreview, item: item)
                    case .none:
                        Text("No fonts selected")
                    }
                }
                .toolbar {
                    Picker("Detail View", selection: viewStore.binding(
                        get: \.selectedPreview,
                        send: FontCollectionAction.selectedPreviewType)
                    ) {
                        ForEach(ItemPreviewType.allCases, id: \.self) { $0.image }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .background(Color.init(NSColor.controlBackgroundColor))
        }
    }
}

struct FontCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        FontCollectionView(store: FontCollectionState.mockStore)
    }
}
