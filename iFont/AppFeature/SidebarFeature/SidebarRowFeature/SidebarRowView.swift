//
//  SidebarRowView.swift
//  iFont
//
//  Created by Jesse Deda on 8/2/22.
//

import SwiftUI
import ComposableArchitecture

struct SidebarRowView: View {
    let store: Store<SidebarRowState, SidebarRowAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                Image(systemName: viewStore.collection.type.imageSystemName)
                    .foregroundColor(viewStore.collection.type.accentColor)
                    .frame(width: 20, height: 20)
                Text(viewStore.collection.name)
                Text("\(viewStore.collection.fonts.count)")
                    .bold()
            }
            .tag(viewStore.collection.id)
            .contextMenu {
                Button {
                     viewStore.send(.newLibrary)
                } label: {
                    Text("New Library")
                }
                Button {
                    viewStore.send(.newBasicCollection)
                } label: {
                    Text("New Collection")
                }
                Button {
                     viewStore.send(.newSmartCollection)
                } label: {
                    Text("New Smart Collection")
                }

                Divider()

                if viewStore.collection.type.canRenameOrDelete {
                    Button {
                         viewStore.send(.rename)
                    } label: {
                        Text("Rename \"\(viewStore.collection.name)\"")
                    }
                    Button {
                         viewStore.send(.delete)
                    } label: {
                        Text("Delete \"\(viewStore.collection.name)\"")
                    }
                }
                else {
                    Text("Rename \"\(viewStore.collection.name)\"")
                    Text("Delete \"\(viewStore.collection.name)\"")
                }
            }
        }
    }
}

struct SidebarRowView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarRowView(store: SidebarRowState.mockStore)
    }
}
