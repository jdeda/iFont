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
                VStack(spacing: 0) {
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
                    Text("Font count: \(viewStore.fonts.count)")
                        .padding(5)
                }
                .frame(minWidth: 220, idealWidth: 280, maxWidth: 380)
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            viewStore.send(.sidebarExpandCollapse)
                        }, label: {
                            Image(systemName: "sidebar.left")
                        })
                        .help("Will show/hide the sidebar view") // TODO: Jdeda make conditional
                    }
                }
                
                // TODO: jdeda: - DONE
                // Add the view to indicate when no item is selected ...
                VStack {
                    switch viewStore.selectedItem {
                    case let .some(item):
                        ItemTypePreview(store: store, selection: viewStore.detailSelection, item: item)
                    case .none:
                        Text("No fonts selected")
                    }
                }
                
                // TODO: jdeda - DONE(ish)
                // Know that the toolbar can reside inside the ItemTypeDetailView
                // 1) Add some toolbar items, such a search field, just like font book
                // 2) Add some more detail views ...
                .toolbar {
                    Picker("Detail View", selection: viewStore.binding(
                        get: \.detailSelection,
                        send: FontCollectionAction.clickedDetailSelection)
                    ) {
                        ForEach(ItemPreviewType.allCases, id: \.self) { $0.image }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .onAppear {
                viewStore.send(FontCollectionAction.onAppear)
            }
        }
    }
}

struct FontCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        FontCollectionView(store: FontCollectionState.mockStore)
    }
}
