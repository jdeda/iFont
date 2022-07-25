import SwiftUI
import ComposableArchitecture

struct FontCollectionView: View {
    let store: Store<FontCollectionState, FontCollectionAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                // The First Column
                VStack(spacing: 0) {
                    // TODO: Jdeda
                    // - Animate expansions
                    // - There are duplicate fonts?
                    List(selection: viewStore.binding(\.$selectedItemID)) {
                        ForEach(viewStore.items) { item in
                            FontCollectionItemRowView(store: store, itemType: item)
                                .tag(item.id)
                        }
                    }
                    Divider()
                    Text("Font count: \(viewStore.collection.fonts.count)")
                        .padding(5)
                }
                .frame(minWidth: 260, maxWidth: 380)
//                .toolbar {
//                    Button(action: {}) {
//                        Label("", systemImage: "plus")
//                    }
//                    Button(action: {}) {
//                        Label("", systemImage: "checkmark.square")
//                    }
//                }

                // The Second Column, or the detail
                VStack {
                    switch viewStore.selectedItem {
                    case let .some(item):
                        FontCollectionItemPreview(store: store, selection: viewStore.selectedPreview, item: item)
                    case .none:
                        Text("No fonts selected")
                    }
                }
                .toolbar {
                    Picker("Detail View", selection: viewStore.binding(
                        get: \.selectedPreview,
                        send: FontCollectionAction.selectedPreviewType)
                    ) {
                        ForEach(FontCollectionItemPreviewType.allCases, id: \.self) { $0.image }
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
