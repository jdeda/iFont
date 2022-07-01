//
//  ItemTypeDetailView.swift
//  iFont
//
//  Created by Jesse Deda on 7/1/22.
//

import SwiftUI

import ComposableArchitecture

struct ItemTypeDetailView: View {
    let store: Store<AppState, AppAction>
    var itemType: ItemType
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                switch itemType {
                case let .font(font):
                    FontDetailView(font: font)
                case let .fontFamily(fontFamily):
                    FontFamilyDetailView(family: fontFamily)
                }
                Spacer()
            }
        }
    }
}
