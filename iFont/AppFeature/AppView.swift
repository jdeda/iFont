import SwiftUI
import ComposableArchitecture

struct AppView: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationView {
        Text("AppView")
        Text("Found \(viewStore.fonts.count) fonts")
        List {
          ForEach(viewStore.fonts, id: \.name) { font in
            Text(font.name)
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
