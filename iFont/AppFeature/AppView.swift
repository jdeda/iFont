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

//fileprivate struct SidebarView: View {
//    @Binding var selection: FontCollection.ID?
//    let librarySection: [FontCollection.ID]
//    let smartSection: [FontCollection.ID]
//    let normalSection: [FontCollection.ID]
//
//    init(_ binding: FontCollection.ID, collections: [FontCollection]) {
//        self.selection = binding
//        self.librarySection = collections.filter {
//            if $0.type == .allFontsLibrary || $0.type == .computerLibrary || $0.type == .standardUserLibrary {
//                return true
//            }
//            else if case FontCollectionType.library(_) = $0.type {
//                return true
//            }
//            else {
//                return false
//            }
//        }.map(\.id)
//        self.smartSection = collections.filter { $0.type == .smart }.map(\.id)
//        self.normalSection = collections.filter { $0.type == .basic }.map(\.id)
//    }
//
//    var body: some View {
//        List(selection: $selection) {
//            FontCollectionsSection(header: "Libraries", librarySection)
//            FontCollectionsSection(header: "Smart Collections",smartSection)
//            FontCollectionsSection(header: "Collections", normalSection)
//        }
//        .toolbar {
//            Button(action: {
//                // Do stuff...
//            }, label: {
//                Image(systemName: "sidebar.left")
//            })
//        }
//    }
//
//    private struct FontCollectionsSection: View {
//        let header: String
//        let ids: [FontCollection.ID]
//
//        init(header: String, _ ids: [FontCollection.ID]) {
//            self.header = header
//            self.ids = ids
//        }
//
//        var body: some View {
//            Section(header) {
//                ForEach(ids, id: \.self) { id in
//                    HStack {
////                        Image(systemName: collection.type.imageSystemName)
////                            .foregroundColor(collection.type.accentColor)
////                            .frame(width: 20, height: 20)
//                        Text(id)
////                        Text("\(collection.fonts.count)")
////                            .bold()
//                    }
//                    .tag(id)
//                }
//            }
//        }
//    }
//}

////// TODO: jdeda
////// This view's logic isn't very clear:
////// - we should have a ForEach here but we don't
////// - there are tags hidden in these extra views which is unsettling
////// - seems to fit the purview of navigation links, something to think about.
//fileprivate struct SidebarView: View {
//    let store: Store<AppState, AppAction>
//    // you rally just need:
//    // (fontCollection.id, fontCollection.name)
//    // since the id is the name.......
//    // we could just take the name!
//
//    var body: some View {
//        WithViewStore(self.store) { viewStore in
//            List(selection: viewStore.binding(
//                get: \.selectedCollection,
//                send: AppAction.madeSelection
//            )) {
//                fontCollectionsSection(header: "Libraries", viewStore.librarySection)
//                fontCollectionsSection(header: "Smart Collections", viewStore.smartSection)
//                fontCollectionsSection(header: "Collections", viewStore.normalSection)
//            }
//            .toolbar {
//                    Button(action: {
//                        viewStore.send(.sidebarToggle)
//                    }, label: {
//                        Image(systemName: "sidebar.left")
//                    })
//            }
//        }
//    }
//
//    private func fontCollectionsSection(header: String, _ collections: [FontCollection]) -> some View {
//        Section(header) {
//            ForEach(collections) { collection in
//                HStack {
//                    Image(systemName: collection.type.imageSystemName)
//                        .foregroundColor(collection.type.accentColor)
//                        .frame(width: 20, height: 20)
//                    Text(collection.name)
//                    Text("\(collection.fonts.count)")
//                        .bold()
//                }
//                    .tag(collection)
//            }
//        }
//    }
//}

//fileprivate struct SidebarView: View {
//    let store: Store<AppState, AppAction>
//
//    var body: some View {
//        WithViewStore(self.store) { viewStore in
//            List(selection: viewStore.binding(
//                get: \.selectedCollection,
//                send: AppAction.madeSelection
//            )) {
//                fontCollectionsSection(header: "Libraries", viewStore.librarySection)
//                fontCollectionsSection(header: "Smart Collections", viewStore.smartSection)
//                fontCollectionsSection(header: "Collections", viewStore.normalSection)
//            }
//            .toolbar {
//                    Button(action: {
//                        viewStore.send(.sidebarToggle)
//                    }, label: {
//                        Image(systemName: "sidebar.left")
//                    })
//            }
//        }
//    }
//
//    private func fontCollectionsSection(header: String, _ collections: [FontCollection]) -> some View {
//        Section(header) {
//            ForEach(collections) { collection in
//                HStack {
//                    Image(systemName: collection.type.imageSystemName)
//                        .foregroundColor(collection.type.accentColor)
//                        .frame(width: 20, height: 20)
//                    Text(collection.name)
//                    Text("\(collection.fonts.count)")
//                        .bold()
//                }
//                    .tag(collection)
//            }
//        }
//    }
//}
