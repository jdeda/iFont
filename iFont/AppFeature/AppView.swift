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
                    .frame(minWidth: 220, maxWidth: 320)
                    Divider()
                    Text("Font count: \(viewStore.fonts.count)")
                        .padding(5)
                }
                
                // TODO: jdeda
                // Create the corresponding views here
                if let item = viewStore.selectedItem {
                    ItemTypeView(store: store, itemType: item)
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
