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
        NavigationView {
            Sidebar(store: store)
            Content(store: store)
        }
    }
}

private struct Sidebar: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            List(selection: viewStore.binding(
                get: \.selectedCollection,
                send: AppAction.madeSelection
            )) {
                fontSection("Library", collection: viewStore.librarySection)
                fontSection("Smart Collections", collection: viewStore.smartSection)
                fontSection("Collections", collection: viewStore.normalSection)
            }
            .toolbar {
                Button(action: toggleSidebar) {
                    Image(systemName: "sidebar.left")
                }
            }
        }
    }
    
    private func fontSection(_ header: String, collection: [FontCollection]) -> some View {
        Section(header) {
            ForEach(collection) { collection in
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
    
    private func toggleSidebar() {
        NSApp.keyWindow?
            .firstResponder?
            .tryToPerform(#selector(NSSplitViewController.toggleSidebar), with: nil)
    }
}



private struct Content: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(store) { viewStore in
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

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(store: AppState.mockStore)
    }
}
