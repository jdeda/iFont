import SwiftUI
import ComposableArchitecture

/**
 1. collections you selected
 2. list view
 3. information view(s)
 */
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
                switch viewStore.selectedItem {
                case let .font(font):
                    // One for the Selected Font
                    Text("font: selection ...\(font.name)")
                case let .fontFamily(fontFamily):
                    // One for the Selected Family
                    Text("fontFamily: selection ...\(fontFamily.name)")
                case .none:
                    // One for no Selection
                    Text("none selection ...")
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
