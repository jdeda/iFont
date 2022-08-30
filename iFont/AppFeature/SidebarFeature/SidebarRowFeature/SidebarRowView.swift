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
    @FocusState private var usernameFieldIsFocused: Bool
    
    
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                Image(systemName: viewStore.collection.type.imageSystemName)
                    .foregroundColor(viewStore.collection.type.accentColor)
                    .frame(width: 20, height: 20)
                if viewStore.collection.type.canRenameOrDelete {
                    TextField("", text: viewStore.binding(
                        get: \.collection.name,
                        send: SidebarRowAction.renameInTextField
                    ))
                    .focused($usernameFieldIsFocused)
                }
                else {
                    Text(viewStore.collection.name)
                }
                //                Text("\(viewStore.collection.fonts.count)")
                //                    .bold()
            }
            
            .tag(viewStore.collection.id)
            .onDrop(
                if: viewStore.collection.type.isBasic,
                for: FontCollectionItemDnD.typeIdentifier,
                perform: { ips in
                    guard let ip = ips.first(where: {  $0.hasItemConformingToTypeIdentifier(FontCollectionItemDnD.typeIdentifier)
                    })
                    else { return false }

                    ip.loadObject(ofClass: FontCollectionItemDnD.self) { reading, _ in
                        guard let item = reading as? FontCollectionItemDnD
                        else { return }
                        DispatchQueue.main.async {
                            viewStore.send(.recievedFontCollectionItemDrop(item))
                        }
                    }
                    return true
                })
//            .onDrop(of: FontCollectionItemDnD.typeIdentifier) { ips in
//                guard let ip = ips.first(where: {  $0.hasItemConformingToTypeIdentifier(FontCollectionItemDnD.typeIdentifier)
//                })
//                else { return false }
//
//                ip.loadObject(ofClass: FontCollectionItemDnD.self) { reading, _ in
//                    guard let item = reading as? FontCollectionItemDnD
//                    else { return }
//                    DispatchQueue.main.async {
//                        viewStore.send(.recievedFontCollectionItemDrop(item))
//                    }
//                }
//                return true
//            }
            .contextMenu {
                Button {
                    let panel = NSOpenPanel()
                    panel.canChooseFiles = false
                    panel.canChooseDirectories = true
                    panel.allowsMultipleSelection = false
                    let reponse = panel.runModal()
                    if reponse == NSApplication.ModalResponse.OK {
                        if let url = panel.url {
                            viewStore.send(.newLibrary(directory: url))
                        }
                    }
                } label: {
                    Text("New Library")
                }
                Button {
                    //                     viewStore.send(.newSmartCollection)
                } label: {
                    Text("New Smart Collection")
                }
                Button {
                    viewStore.send(.newBasicCollection)
                } label: {
                    Text("New Collection")
                }
                
                Divider()
                
                if viewStore.collection.type.canRenameOrDelete {
                    // TODO: Jdeda
                    // Implement rename feature.
                    Button {
                        usernameFieldIsFocused = true
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
