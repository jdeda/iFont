//
//  ItemTypeView.swift
//  iFont
//
//  Created by Klajd Deda on 7/1/22.
//

import SwiftUI
import ComposableArchitecture

struct ItemTypeView: View {
    let store: Store<AppState, AppAction>
    var itemType: ItemType
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                switch itemType {
                case let .font(font):
                    // TODO: jdeda
                    // Build a FontRowView similar to the FontFamilyRowView
                    Text("font: selection ...\(font.name)")
                case let .fontFamily(fontFamily):
                    FontFamilyRowView(store: store, fontFamily: fontFamily)
                }
                Spacer()
            }
        }
    }
}
