//
//  AppView.swift
//  iFont
//
//  Created by Klajd Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct FontCollectionSection: View {
    private func labeledImage(_ fontCollection: FontCollection) -> some View {
//        Label(fontCollection.type.labelString, systemImage: fontCollection.type.imageSystemName)
//            .tint(fontCollection.type.accentColor)
        HStack {
            Image(systemName: fontCollection.type.imageSystemName)
                .foregroundColor(fontCollection.type.accentColor)
                .frame(width: 20, height: 20)
            Text(fontCollection.type.labelString)
            Text("\(fontCollection.fonts.count)")
                .bold()
        }
    }
    
    var collection: [FontCollection]
    var header: String
    
    var body: some View {
        Section {
            ForEach(collection) {
                labeledImage($0)
                    .tag($0)
            }
        } header: {
            Text(header)
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
                FontCollectionSection(collection: viewStore.librarySection, header: "Library")
                FontCollectionSection(collection: viewStore.smartSection, header: "Smart Collections")
                FontCollectionSection(collection: viewStore.normalSection, header: "Collections")
            }
        }
    }
}


/*
 
 AppView {
    NavigationView {
        Sidebar
        Main
        Detail
    }
 }
 
 
 ...
 Sidebar
 ...
 
 var body: some View {
    ForEach(viewStore.navigationLinks) {
        NavigationLink(destination: Foo) {
            Label("A", systemName: "A")
        }
    }
 }
 */

struct AppView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                FontCollectionsSideBarView(store: store)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button(action: {
                                viewStore.send(.sidebarToggle)
                            }, label: {
                                Image(systemName: "sidebar.left")
                            })
                            .help("Will show/hide the sidebar view")
                            // TODO: jdeda
                            // make conditional
                        }
                    }
                
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
