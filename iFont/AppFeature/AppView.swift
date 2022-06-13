import SwiftUI
import ComposableArchitecture

struct SelectedFamily: View {
    var family: FontFamily

    var body: some View {
        Text(family.name)
    }
}

struct AppView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                Text("Found \(viewStore.fontFamilies.count) fonts")
                List(selection: viewStore.binding(
                    get: \.selectedFontFamily,
                    send: AppAction.selectedFontFamily
                )) {
                    ForEach(viewStore.fontFamilies, id: \.name) { family in
                        HStack {
                            Image(systemName: viewStore.familyExpansionState.contains(family.name)
                                  ? "chevron.down"
                                  : "chevron.right"
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                Logger.log("onTapGesture: \(family.name)")
                                viewStore.send(AppAction.toggleExpand(family))
                            }
                            Text(family.name)
                        }
                        .tag(family)
                    }
                }
                switch viewStore.selectedFontFamily {
                case let .some(family):
                    SelectedFamily(family: family)
                case .none:
                    Text("No selection ...")
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
