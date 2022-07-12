//
//  AppView.swift
//  iFont
//
//  Created by Klajd Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct FontCollectionsSideBarView: View {
    let store: Store<AppState, AppAction>
    
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
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            List(selection: viewStore.binding(
                get: \.selectedCollection,
                send: AppAction.madeSelection
            )) {
                Section {
                    ForEach(viewStore.librarySection) { fontCollection in
                        labeledImage(fontCollection)
                            .tag(fontCollection)
                    }
                } header: {
                    Text("Libraries")
                }
                //                Section {
                //                    labeledImage(systemName: "gearshape", label: "English")
                //                    labeledImage(systemName: "gearshape", label: "Fixed Width")
                //                } header: {
                //                    Text("Smart Collections")
                //                }
                //                Section {
                //                    labeledImage(systemName: "square.on.square", label: "Fun", accent: .cyan)
                //                    labeledImage(systemName: "square.on.square", label: "Modern", accent: .cyan)
                //                    labeledImage(systemName: "square.on.square", label: "PDF", accent: .cyan)
                //                    labeledImage(systemName: "square.on.square", label: "Traditional", accent: .cyan)
                //                    labeledImage(systemName: "square.on.square", label: "Web", accent: .cyan)
                //                    labeledImage(systemName: "square.on.square", label: "All", accent: .cyan)
                //                } header: {
                //                    Text("Collections")
                //                }
            }
        }
    }
}

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
                    else: {
                        Text("No collection selected")
                    }
                )
                .onAppear {
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
