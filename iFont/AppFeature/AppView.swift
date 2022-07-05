//
//  AppView.swift
//  iFont
//
//  Created by Klajd Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                List {
                    Text("All Fonts")
                    Text("Computer")
                    Text("User")
                    Section {
                        Text("All Fonts")
                        Text("Computer")
                        Text("User")
                    } header: {
                        Text("Vegetables")
                    }
                }

                Text("Selected Collection")
                Text("Selected Collection details")
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
