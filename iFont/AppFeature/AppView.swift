import SwiftUI
import ComposableArchitecture

struct AppView: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      Text("Fonts: \(viewStore.fonts.count)")
      NavigationView {
        Text("AppView")
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
