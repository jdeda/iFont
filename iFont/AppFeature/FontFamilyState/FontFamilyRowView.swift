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
            VStack(spacing: 1) {
                
                // Top row view.
                HStack {
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
                .highlightSelectionBox(viewStore.isSelected)
                .onTapGesture {
                    Logger.log("toggleSelection: \(viewStore.fontFamily.name)")
                    viewStore.send(FontFamilyAction.toggleSelection)
                }
                
                // Child row view.
                if viewStore.isExpanded {
//                    HStack {
//                        ScrollView {
                            ForEach(viewStore.fonts) { font in
                                HStack {
                                    Text("\t")
                                    Text(font.name)
                                    Spacer()
                                }
                                .padding(4)
                                // .border(Color.red)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    Logger.log("toggleSelection: \(viewStore.fontFamily.name)")
                                    viewStore.send(FontFamilyAction.toggleChildSelection(font))
                                }
                                .highlightSelectionBox(viewStore.selectedChild?.id == font.id)
                            }
//                        }
//                        Spacer()
//                            .frame(minWidth: 220, maxWidth: 600)
//                    }
                }
            }
        }
    }
}

struct FontFamilyRowView_Previews: PreviewProvider {
    static var previews: some View {
        FontFamilyRowView(store: FontFamilyState.mockStore)
    }
}
