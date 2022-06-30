import SwiftUI
import ComposableArchitecture

struct ItemTypeView: View {
    let store: Store<AppState, AppAction>
    var itemType: ItemType
    
    // TODO: jdeda
    // add
    // item expansion
    // item selection
    var body: some View {
        HStack {
            switch itemType {
            case let .font(font):
                Text("font: selection ...\(font.name)")
            case let .fontFamily(fontFamily):
                Text("fontFamily: selection ...\(fontFamily.name)")
                //                        case .some:
                //                            Text("some: selection ...")
                //                        case .none:
                //                            Text("none selection ...")
            }
            Spacer()
        }
    }
}

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
                // TODO: get rid of this shit
                // it is not modular ....
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

                // TODO: kdeda
                // polish this so i'm able to select a family or a font
                // use an enum case about what it selected
                // than here you can switch over them
                // clone https://github.com/pointfreeco/swift-composable-architecture.git
                // open ComposableArchitecture.xcworkspace
                // read/understand the SwitchStore
                
//                SwitchStore(viewStore.selectedItem) {
//                    CaseLet(state: /SelectionType.font, then: <#T##(Store<LocalState, LocalAction>) -> Content#>)
//                }
                switch viewStore.selectedItem {
                case let .font(font):
                    Text("font: selection ...\(font.name)")
                case let .fontFamily(fontFamily):
                    Text("fontFamily: selection ...\(fontFamily.name)")
                case .some:
                    Text("some: selection ...")
                case .none:
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
