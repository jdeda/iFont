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
struct SidebarView: View {
    let store: Store<SidebarState, SidebarAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List(selection: viewStore.binding(\.$selectedCollection)) {
                Section("Libraries") {
                    ForEach(viewStore.collections.filter { $0.type.isLibrary }) { collection in                        SidebarRowView(collection: collection)
                            .tag(collection.name)
                            .contextMenu {
                                Button(
                                    action: { viewStore.send(.tappedAddLibraryButton) },
                                    label: { Text("New Library") }
                                )
                                Button(
                                    action: { viewStore.send(.tappedAddSmartCollectionButton) },
                                    Text("New Smart Collection")
                                )
                                Button(
                                    action: { viewStore.send(.tappedAddCollectionButton) },
                                    label: { Text("New Collection") }
                                )
                                Divider()
                                if collection.type.canRenameOrDelete {
                                    Button(
                                        action: { viewStore.send(.tappedRenameButton) },
                                        Text("Rename \"\(collection.name)\"")
                                    )
                                    Button(
                                        action: { viewStore.send(.tappedDeleteButton) },
                                        Text("Delete \"\(collection.name)\"")
                                    )
                                }
                                else {
                                    Text("Rename \"\(collection.name)\"")
                                    Text("Delete \"\(collection.name)\"")
                                }
                            }
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
    
    private struct SidebarRowView: View {
        let collection: FontCollection
        var body: some View {
            HStack {
                Image(systemName: collection.type.imageSystemName)
                    .foregroundColor(collection.type.accentColor)
                    .frame(width: 20, height: 20)
                Text(collection.name)
                Text("\(collection.fonts.count)")
                    .bold()
            }
        }
    }
    
    private struct SidebarContextMenu: View {
        var collection: FontCollection
        
        var body: some View {
            Button {
                // viewStore.send(.newLibrary)
            } label: {
                Text("New Library")
            }
            Button {
                // viewStore.send(.newCollection)
            } label: {
                Text("New Collection")
            }
            Button {
                // viewStore.send(.newSmartCollection)
            } label: {
                Text("New Smart Collection")
            }
            
            Divider()
            
            if collection.type.canRenameOrDelete {
                Button {
                    // viewStore.send(.rename)
                } label: {
                    Text("Rename \"\(collection.name)\"")
                }
                Button {
                    // viewStore.send(.delete)
                } label: {
                    Text("Delete \"\(collection.name)\"")
                }
            }
            else {
                Text("Rename \"\(collection.name)\"")
                Text("Delete \"\(collection.name)\"")
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
