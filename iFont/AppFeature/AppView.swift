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
                SidebarView(store: store)

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
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(store: AppState.mockStore)
    }
}

// TODO: jdeda
// This view's logic isn't very clear:
// - we should have a ForEach here but we don't
// - there are tags hidden in these extra views which is unsettling
// - seems to fit the purview of navigation links, something to think about.
fileprivate struct SidebarView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            List(selection: viewStore.binding(
                get: \.selectedCollection,
                send: AppAction.madeSelection
            )) {
                fontCollectionsSection(header: "Library", viewStore.librarySection)
                fontCollectionsSection(header: "Smart Collections", viewStore.smartSection)
                fontCollectionsSection(header: "Collections", viewStore.normalSection)
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

    private func fontCollectionsSection(header: String, _ collections: [FontCollection]) -> some View {
        Section(header) {
            ForEach(collections) { collection in
                HStack {
                    Image(systemName: collection.type.imageSystemName)
                        .foregroundColor(collection.type.accentColor)
                        .frame(width: 20, height: 20)
                    Text(collection.type.labelString)
                    Text("\(collection.fonts.count)")
                        .bold()
                }
                    .tag(collection)
            }
        }
    }
}
