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
                            .onDrag { .init(object: yummers(item)) }
                            .contextMenu {
                                
                                // Allow deletion only collection type is basic.
                                if viewStore.collection.type.isBasic {
                                    Button {
                                        viewStore.send(.delete(item))
                                    } label: {
                                        Text("Delete")
                                    }
                                }
                                else {
                                    Text("Delete")
                                }
                                
                                Divider()
                                
                                
                                // Allow panel only if item is a font.
                                switch item {
                                case let .font(font):
                                    Button {
                                        let panel = NSOpenPanel()
                                        panel.directoryURL = font.url
                                        panel.canChooseFiles = false
                                        panel.canChooseDirectories = false
                                        panel.allowsMultipleSelection = false
                                    } label: {
                                        Text("Show in finder")
                                    }
                                }
                                case .fontFamily(family):
                                    return Text("Show in finder")
                            }
//                            .onDrag { .init(object: item.jsonItemProvider()) }
//                            .onDrag {
//
//                                 Works.
//                                let rv = NSItemProvider(object: item.jsonItemProvider())
//
//                                Logger.log("yummers: '\(rv)'")
//                                return rv
//
//                                 working version
//                                 let url = URL(fileURLWithPath: "/Users/kdeda/Development/third-parties/jesse/iFont/iFont.xcodeproj")
//                                 let rv = NSItemProvider.init(item: NSSecureCoding?, typeIdentifier: "public.jpeg")
//                                 Logger.log("yummers: '\(rv)'")
//                                 return rv
//                            }
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
