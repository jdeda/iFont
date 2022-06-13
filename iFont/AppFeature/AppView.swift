import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                Text("Found \(viewStore.fontFamilies.count) fonts")
                List {
                    ForEach(viewStore.fontFamilies, id: \.name) { font in
                        Button {
                            viewStore.send(AppAction.selectedFontFamily(font))
                        } label: {
                            HStack {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                Text(font.name)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                Text(viewStore.selectedFontFamily?.name ?? "None")
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
