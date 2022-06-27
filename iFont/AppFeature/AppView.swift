import SwiftUI
import ComposableArchitecture

struct FontRow: View {
    var font: Font
    
    var body: some View {
        HStack {
            Text(font.name)
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
                List(selection: viewStore.binding(
                    get: \.selectedItem,
                    send: AppAction.selectedItem
                )) {
                    ForEachStore(
                        self.store.scope(
                            state: \.fontFamilies,
                            action: AppAction.fontFamily(id:action:)
                        ),
                        content: FontFamilyRowView.init(store:)
                    )
//
//                    ForEach(viewStore.fontFamilies, id: \.family.name) { family in
//                        FontFamilyRow(store: store, family: family)
//                            .tag(family.selectionType)
//                        if viewStore.familyExpansionState.contains(family.name) {
//                            ForEach(family.fonts, id: \.name) { font in
//                                FontRow(font: font)
//                                    .tag(font.selectionType)
//                            }
//                            .offset(x: 20, y: 0)
//                        }
//                    }
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
                case let .fontFamily(familyState):
                    Text("fontFamily: selection ...\(familyState.fontFamily.name)")
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
