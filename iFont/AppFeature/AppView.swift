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

    func labeledImage(systemName: String, label: String) -> some View {
        HStack {
            Image(systemName: systemName)
                .frame(width: 20, height: 20)
            Text(label)
        }
    }

    func labeledImage(systemName: String, label: String, accent: Color) -> some View {
        HStack {
            Image(systemName: systemName)
                .foregroundColor(accent)
                .frame(width: 20, height: 20)
            Text(label)
        }
    }

    func labeledImage(_ fontCollection: FontCollection) -> some View {
        HStack {
            Image(systemName: fontCollection.type.imageSystemName)
                .foregroundColor(.accentColor)
                .frame(width: 20, height: 20)
            Text(fontCollection.type.labelString)
            Text("\(fontCollection.fonts.count)")
                .bold()
        }
    }

    var body: some View {
        WithViewStore(self.store) { viewStore in
            // TODO: jdeda
            // make it so i can select a font collection ...
            List {
                Section {
                    ForEach(viewStore.fontLibraries) { fontCollection in
                        labeledImage(fontCollection)
                    }
                } header: {
                    Text("Libraries")
                }
                Section {
                    labeledImage(systemName: "gearshape", label: "English")
                    labeledImage(systemName: "gearshape", label: "Fixed Width")
                } header: {
                    Text("Smart Collections")
                }
                Section {
                    labeledImage(systemName: "square.on.square", label: "Fun", accent: .cyan)
                    labeledImage(systemName: "square.on.square", label: "Modern", accent: .cyan)
                    labeledImage(systemName: "square.on.square", label: "PDF", accent: .cyan)
                    labeledImage(systemName: "square.on.square", label: "Traditional", accent: .cyan)
                    labeledImage(systemName: "square.on.square", label: "Web", accent: .cyan)
                    labeledImage(systemName: "square.on.square", label: "All", accent: .cyan)
                } header: {
                    Text("Collections")
                }
            }
        }
    }
}

/**
 Library
    - FontCollection that has access to file system: if its the system/library/fonts directory, it is immutable
 Smart Collection
    - FontCollection derived from a library
 Collection
    - FontCollection
 
 A whole new type is unncessary...
 
 Ok but how should the AppState handle the FontCollections?
 Well now we have a FontCollectionFeature, so we'd have to hold on to a bunch of these...
 or derive a FontCollectionState whenever we select a specific FontCollection...
 */
struct AppView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                FontCollectionsSideBarView(store: store)
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
