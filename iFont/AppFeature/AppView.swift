import SwiftUI
import ComposableArchitecture

struct FontFamilyRow: View {
    let store: Store<AppState, AppAction>
    var family: FontFamily
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                HStack {
                    Image(systemName: viewStore.familyExpansionState.contains(family.name)
                          ? "chevron.down"
                          : "chevron.right"
                    )
                    // .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        Logger.log("onTapGesture: \(family.name)")
                        viewStore.send(AppAction.toggleExpand(family))
                    }
                    Text(family.name)
                    Spacer()
                }
            }
        }
    }
}

struct FontRow: View {
    var font: Font
    
    var body: some View {
        HStack {
            Text(font.name)
            Spacer()
        }
    }
}

struct AppView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                List(selection: viewStore.binding(
                    get: \.selectedItem,
                    send: AppAction.selectedItem
                )) {
                    ForEach(viewStore.fontFamilies, id: \.name) { family in
                        FontFamilyRow(store: store, family: family)
                            .tag(family.selectionType)
                        if viewStore.familyExpansionState.contains(family.name) {
                            ForEach(family.fonts, id: \.name) { font in
                                FontRow(font: font)
                                    .tag(font.selectionType)
                            }
                            .offset(x: 20, y: 0)
                        }
                    }
                }
                .frame(minWidth: 220, maxWidth: 320)
                Text("No selection ...")

                // TODO: kdeda
                // polish this so i'm able to select a family or a font
                // use an enum case about what it selected
                // than here you can switch over them
                // clone https://github.com/pointfreeco/swift-composable-architecture.git
                // open ComposableArchitecture.xcworkspace
                // read/understand the SwitchStore
                
//                switch viewStore.selectedFontFamily {
//                case let .some(family):
//                    FontFamilyView(family: family)
//                case .none:
//                    Text("No selection ...")
//                }
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
