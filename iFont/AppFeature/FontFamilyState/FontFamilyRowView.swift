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
                    Image(systemName: viewStore.isSelected // fontFamily.familyExpansionState.contains(viewStore.fontFamily.name)
                          ? "chevron.down"
                          : "chevron.right"
                    )
                    // .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        Logger.log("onTapGesture: \(viewStore.fontFamily.name)")
                        // TODO: implement action
                        // viewStore.send(AppAction.toggleExpand(family))
                    }
                    Text(viewStore.fontFamily.name)
                    Spacer()
                }
            }
        }
    }
}

// TODO: add the preview
