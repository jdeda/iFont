import SwiftUI
import ComposableArchitecture
    
struct FontCollectionView: View {
    let store: Store<FontCollectionState, FontCollectionAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
        
                // The Item List.
                List(selection: viewStore.binding(\.$selectedItemID)) {
                    ForEach(viewStore.items) { item in
                        FontCollectionItemRowView(store: store, itemType: item)
                            .tag(item.id)
                    }
                }
                .animation(.default, value: viewStore.selectedExpansions)
                
                // The Item Preview.
                switch viewStore.selectedItem {
                case let .some(item):
                    FontCollectionItemPreview(selection: viewStore.selectedPreview, item: item)
                case .none:
                    Text("No fonts selected")
                }
            }
            .navigationTitle(viewStore.state.collection.name)
            .navigationSubtitle("\(viewStore.collection.fonts.count) fonts")
            .toolbar {
                Picker("Detail View", selection: viewStore.binding(\.$selectedPreview)) {
                    // TODO: Jdeda
                    // Finish Repetoire preview.
                    ForEach(Array<FontCollectionItemPreviewType>([.sample, .custom, .info]), id: \.self) { $0.image }
//                    ForEach(FontCollectionItemPreviewType.allCases, id: \.self) { $0.image }
                }
                .pickerStyle(.segmented)
            }
        }
    }
}

struct FontCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        FontCollectionView(store: FontCollectionState.mockStore)
    }
}
