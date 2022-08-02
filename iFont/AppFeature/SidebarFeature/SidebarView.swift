//
//  SidebarView.swift
//  iFont
//
//  Created by Jesse Deda on 8/1/22.
//

import SwiftUI
import ComposableArchitecture

//struct FontCollectionSidebarItem: Identifiable {
//    var id: String { name }
//    let name: String
//    let type: FontCollectionType
//    let count: Int
//}

/**
 Basically here is what happens if you properly scope:
 1. refactor sidebar state to hold
 - libraryFontCollections
 - smartFontCollections
 - normalFontCollections
 2. create a sidebarow state, action, environment, reducer, mockStore,
 3. in the sidebar view, must do a scope
 
 Now, if you leave in boilerplate, you just add 99 lines of code
 */

/**
 Fundamental problem:
    Given a list, I want to split it into sections so I can render/behave those sections accordingly...
    How do I do this in the most elegant way possible?
 
    Let's break it down:
        1. we have a parent with a collection of items
        2. we need to scope into a filtered version of those collections (to represent a section)
 
    Limitations of TCA:
        1. whenever we scope, we use a keypath...so we can't filter on the spot...so we have to do so in the state...
            - why is this a thing? why can't i just put in a piece of data? why does this involve a keypath?
        2. list needs a tag....well we can't do this in our ForEachStore because we don't have tag data handy...
          the childStore can't give us anything...so basically we'd have to put a tag within the view we init by the childstore
                    
 */
struct SidebarView: View {
    let store: Store<SidebarState, SidebarAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List(selection: viewStore.binding(\.$selectedCollection)) {
                Section("Libraries") {
                    ForEachStore(store.scope(
                        state: \.libraryCollections,
                        action: SidebarAction.row
                    )) { childStore in
                        SidebarRowView(store: childStore)
                    }
                }
                Section("Smart Collections") {
                    ForEachStore(store.scope(
                        state: \.smartCollections,
                        action: SidebarAction.row
                    )) { childStore in
                        SidebarRowView(store: childStore)
                    }
                }
                Section("Collections") {
                    ForEachStore(store.scope(
                        state: \.basicCollections,
                        action: SidebarAction.row
                    )) { childStore in
                        SidebarRowView(store: childStore)
                    }
                }
            }
            .toolbar {
                Button(action: {
                    viewStore.send(.toggleHideSidebar)
                }, label: {
                    Image(systemName: "sidebar.left")
                })
            }
        }
    }
}
// MARK: Original
//struct SidebarView: View {
//    let store: Store<SidebarState, SidebarAction>
//
//    var body: some View {
//        WithViewStore(store) { viewStore in
//            List(selection: viewStore.binding(\.$selectedCollection)) {
//                Section("Libraries") {
//                    ForEach(viewStore.collections.filter { $0.type.isLibrary }) { collection in                        SidebarRowView(collection: collection)
//                            .tag(collection.name)
//                            .contextMenu {
//                                SidebarContextMenu(collection: collection)
//                            }
//                    }
//                }
////                Section("Smart Collections") {
////                    ForEach(viewStore.collections.filter { $0.type.isSmart }) { collection in
////                        SidebarRowView(collection: collection)
////                            .tag(collection.name)
////                            .contextMenu {
////                                ContextMenu(collection: collection)
////                            }
////                    }
////                }
////                Section("Collections") {
////                    ForEach(viewStore.collections.filter { $0.type.isBasic }) { collection in
////                        SidebarRowView(collection: collection)
////                            .tag(collection.name)
////                            .contextMenu {
////                                ContextMenu(collection: collection)
////                            }
////                    }
////                }
//            }
//            .toolbar {
//                Button(action: {
//                    viewStore.send(.toggleHideSidebar)
//                }, label: {
//                    Image(systemName: "sidebar.left")
//                })
//            }
//        }
//    }
//
//    private struct SidebarRowView: View {
//        let collection: FontCollection
//        var body: some View {
//            HStack {
//                Image(systemName: collection.type.imageSystemName)
//                    .foregroundColor(collection.type.accentColor)
//                    .frame(width: 20, height: 20)
//                Text(collection.name)
//                Text("\(collection.fonts.count)")
//                    .bold()
//            }
//        }
//    }
//
//    private struct SidebarContextMenu: View {
//        var collection: FontCollection
//
//        var body: some View {
//            Button {
//                // viewStore.send(.newLibrary)
//            } label: {
//                Text("New Library")
//            }
//            Button {
//                // viewStore.send(.newCollection)
//            } label: {
//                Text("New Collection")
//            }
//            Button {
//                // viewStore.send(.newSmartCollection)
//            } label: {
//                Text("New Smart Collection")
//            }
//
//            Divider()
//
//            if collection.type.canRenameOrDelete {
//                Button {
//                    // viewStore.send(.rename)
//                } label: {
//                    Text("Rename \"\(collection.name)\"")
//                }
//                Button {
//                    // viewStore.send(.delete)
//                } label: {
//                    Text("Delete \"\(collection.name)\"")
//                }
//            }
//            else {
//                Text("Rename \"\(collection.name)\"")
//                Text("Delete \"\(collection.name)\"")
//            }
//        }
//    }
//}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(store: SidebarState.mockStore)
    }
}
