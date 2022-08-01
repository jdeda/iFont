//
//  SidebarView.swift
//  iFont
//
//  Created by Jesse Deda on 8/1/22.
//

import SwiftUI
import ComposableArchitecture

struct SidebarView: View {
    let store: Store<SidebarState, SidebarAction>
   
    var body: some View {
        WithViewStore(store) { viewStore in
            List(selection: viewStore.binding(\.$selectedCollection)) {
                FontCollectionsSection(header: "Libraries", viewStore.collections.filter { $0.type.isLibrary })
                FontCollectionsSection(header: "Smart Collections", viewStore.collections.filter { $0.type.isSmart })
                FontCollectionsSection(header: "Collections", viewStore.collections.filter { $0.type.isBasic })
            }
            .toolbar {
                    Button(action: {
                        viewStore.send(.sidebarToggle)
                    }, label: {
                        Image(systemName: "sidebar.left")
                    })
            }
        }
    }
    
    private struct FontCollectionsSection: View {
        let header: String
        let collection: [FontCollection]
        
        init(header: String, _ collection: [FontCollection]) {
            self.header = header
            self.collection = collection
        }
        
        var body: some View {
            Section(header) {
                ForEach(collection) { collection in
                    HStack {
                        Image(systemName: collection.type.imageSystemName)
                            .foregroundColor(collection.type.accentColor)
                            .frame(width: 20, height: 20)
                        Text(collection.name)
                        Text("\(collection.fonts.count)")
                            .bold()
                    }
                    .tag(collection.name)
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
