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
 
 Attempt A: N-forEach
 - this does not work. we scope n times and forEach on a reducer n times...
 
 */
struct MyDelegate {
    let viewStore: ViewStore<SidebarState, SidebarAction>
}

struct SidebarView: View {
    let store: Store<SidebarState, SidebarAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List(selection: viewStore.binding(\.$selectedCollection)) {
                Section("Libraries") {
                    ForEachStore(
                        store.scope(
                            state: \.libraryCollections,
                            action: SidebarAction.libraryCollectionRow
                        ),  content: SidebarRowView.init(store:)
                    )
                }
                Section("Smart Collections") {
                    ForEachStore(
                        store.scope(
                            state: \.smartCollections,
                            action: SidebarAction.smartCollectionRow
                        ),  content: SidebarRowView.init(store:)
                    )
                }
                Section("Collections") {
                    ForEachStore(store.scope(
                        state: \.basicCollections,
                        action: SidebarAction.basicCollectionRow
                    )) { childStore in
                        // MARK: Is this is what is causing double writes
                        // as seen when renaming an item from this collection?
                        
                        SidebarRowView(store: childStore)
                        // TODO: Please use a Delegate for more flexibility
//                            .onDrop(
//                                of: JSONItemProvider.readableTypeIdentifiersForItemProvider,
//                                isTargeted: nil
//                            ) { ips in
//                                Logger.log("yummers: '\(ips)'")
//                                return true
//                            }
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
}
    
    struct SidebarView_Previews: PreviewProvider {
        static var previews: some View {
            SidebarView(store: SidebarState.mockStore)
        }
    }
