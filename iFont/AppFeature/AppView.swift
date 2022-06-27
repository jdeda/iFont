import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                ScrollView {
                    LazyVStack(spacing: 2) {
                        ForEachStore(
                            self.store.scope(
                                state: \.fontFamilies,
                                action: AppAction.fontFamily(id:action:)
                            ),
                            content: FontFamilyRowView.init(store:)
                        )
                    }
                }
                
                Text("selection font")
//                // TODO: kdeda
//                // polish this so i'm able to select a family or a font
//                // use an enum case about what it selected
//                // than here you can switch over them
//                // clone https://github.com/pointfreeco/swift-composable-architecture.git
//                // open ComposableArchitecture.xcworkspace
//                // read/understand the SwitchStore
//                
//                //                SwitchStore(viewStore.selectedItem) {
//                //                    CaseLet(state: /SelectionType.font, then: <#T##(Store<LocalState, LocalAction>) -> Content#>)
//                //                }
                switch viewStore.selectedItem {
                case let .fontFamily(fontFamily):
                    Text("fontFamily: selection ...\(fontFamily.name)")
                case let .font(font):
                    Text("font: selection ...\(font.name)")
                case .some:
                    Text("some: selection ...")
                case .none:
                    Text("none selection ...")
                }
            }
            .frame(minWidth: 220, maxWidth: 600)
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
