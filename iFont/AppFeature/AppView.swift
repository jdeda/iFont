import SwiftUI
import ComposableArchitecture

struct AppView: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationView {
        Text("AppView")
        Text("Found \(viewStore.fontFamilies.count) fonts")
        List {
          ForEach(viewStore.fontFamilies, id: \.name) { font in
            HStack {
              Button {
                // TODO: is this bad (the argument)?
                viewStore.send(AppAction.selectedFontFamily(font))
                // Do nothing for now.
              } label: {
                Image(systemName: "chevron.right")
              }
              Text(font.name)
            }
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
