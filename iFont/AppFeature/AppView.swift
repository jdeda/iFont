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
                FontCollectionsSideBarView(store: store)

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
                    // When you hide/unhide the app we get here anew
                    // App should load fonts only on start up and never again!
                    viewStore.send(AppAction.onAppear)
                }
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(store: AppState.mockStore)
    }
}


struct FontCollectionSection: View {
    var header: String
    var collection: [FontCollection]
    
    var body: some View {
        Section(header) {
            ForEach(collection) {
                labeledImage($0)
                    .tag($0)
            }
        }
    }
    
    private func labeledImage(_ fontCollection: FontCollection) -> some View {
        HStack {
            Image(systemName: fontCollection.type.imageSystemName)
                .foregroundColor(fontCollection.type.accentColor)
                .frame(width: 20, height: 20)
            Text(fontCollection.type.labelString)
            Text("\(fontCollection.fonts.count)")
                .bold()
        }
    }
}

struct FontCollectionsSideBarView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            List(selection: viewStore.binding(
                get: \.selectedCollection,
                send: AppAction.madeSelection
            )) {
                FontCollectionSection(header: "Library", collection: viewStore.librarySection)
                FontCollectionSection(header: "Smart Collections", collection: viewStore.smartSection)
                FontCollectionSection(header: "Collections", collection: viewStore.normalSection)
            }
            .toolbar {
                    Button(action: {
                        viewStore.send(.sidebarToggle)
                    }, label: {
                        Image(systemName: "sidebar.left")
                    })
            }
        }
    }
}
