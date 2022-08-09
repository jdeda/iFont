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
                SidebarView(store: store.scope(
                    state: \.sidebar,
                    action: AppAction.sidebar
                ))
                
                IfLetStore(
                    store.scope(
                        state: \.selectedCollectionState,
                        action: AppAction.fontCollection
                    ),
                    then: FontCollectionView.init(store:),
                    else: { Text("No collection selected") }
                )
                
                .onAppear {
                    // TODO: kdeda
                    // When you hide/unhide the app we get here...
                    // App should load fonts only on start up and or if asked!
                    viewStore.send(AppAction.onAppear)
                }
            }
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(store: AppState.mockStore)
    }
}
