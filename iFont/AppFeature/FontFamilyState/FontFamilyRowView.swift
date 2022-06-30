//
//  FontFamilyRow.swift
//  iFont
//
//  Created by Klajd Deda on 6/27/22.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct FontFamilyRowView: View {
    let store: Store<FontFamilyState, FontFamilyAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                HStack {
                    // TODO: move 'familyExpansionState' this to my state
                    // fontFamily.familyExpansionState.contains(viewStore.fontFamily.name)
                    Image(systemName: viewStore.isExpanded ? "chevron.down" : "chevron.right")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        Logger.log("toggleExpansion: \(viewStore.fontFamily.name)")
                        viewStore.send(FontFamilyAction.toggleExpansion)
                    }
                    Text(viewStore.fontFamily.name)
                    Spacer()
                }
//                .onTapGesture {
//                    Logger.log("toggleSelection: \(viewStore.fontFamily.name)")
//                    viewStore.send(FontFamilyAction.toggleSelection)
//                }
            }
            // this is the right way
            // .background(viewStore.isSelected ? Color.red : Color.clear)
            
            // this is the Vanilla SwiftUI way, we are expected to be inside a list
            // and thus need to furnish a tag to the list ...
//            .tag(viewStore.selectionType)
        }
    }
}

struct FontFamilyRowView_Previews: PreviewProvider {
    static var previews: some View {
        FontFamilyRowView(store: FontFamilyState.mockStore)
    }
}
