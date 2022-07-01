import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack(spacing: 0) {
                    List(selection: viewStore.binding(
                        get: \.selectedItem,
                        send: AppAction.selectedItem
                    )) {
                        ForEach(viewStore.items) { item in
                            ItemTypeView(store: store, itemType: item)
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
                        .help("Will show/hide the sidebar view")
                    }
                }
                
                // TODO: jdeda
                // Add the view to indicate when no item is selected ...
                VStack {
                    switch viewStore.selectedItem {
                    case let .some(item):
                        ItemTypeDetailView(store: store, itemType: item)
                    case .none:
                        Text("123")
                    }
                }
                .toolbar {
                    // TODO: jdeda
                    // Know that the toolbar can reside inside the ItemTypeDetailView
                    // 1) Add some toolbar items, such a search field, just like font book
                    // 2) Add some more detail views ...
                    ToolbarItemGroup {
                        Text("Button 1")
                        Text("1")
                    }
                }
            }
            .onAppear {
                viewStore.send(AppAction.onAppear)
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(store: AppState.mockStore)
    }
}
