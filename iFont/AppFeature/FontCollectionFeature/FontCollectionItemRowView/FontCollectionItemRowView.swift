//
//  ItemTypeView.swift
//  iFont
//
//  Created by Klajd Deda on 7/1/22.
//

import SwiftUI
import ComposableArchitecture

struct FontCollectionItemRowView: View {
    let store: Store<FontCollectionState, FontCollectionAction>
    var itemType: FontCollectionItem
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            switch itemType {
            case let .font(font):
                FontRowView(font: font)
            case let .fontFamily(fontFamily):
                FontFamilyRowView(store: store, fontFamily: fontFamily)
            }
        }
    }
}

struct ItemTypeRowView_Previews: PreviewProvider {
    static var previews: some View {
        FontCollectionItemRowView(
            store: FontCollectionState.mockStore,
            itemType: FontCollectionItem.fontFamily(FontFamily(
                name: "cheese",
                fonts: mock_fonts
            ))
        )
    }
}

fileprivate struct FontRowView: View {
    let font: Font
    
    var body: some View {
        Text("\(font.attributes[.style] ?? font.name)")
            .padding(.leading, 30)
    }
}

fileprivate struct FontFamilyRowView: View {
    let store: Store<FontCollectionState, FontCollectionAction>
    var fontFamily: FontFamily
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                Image(systemName: viewStore.selectedExpansions.contains(fontFamily.id)
                      ? "chevron.down"
                      : "chevron.right")
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .contentShape(Rectangle())
                .onTapGesture {
                    Logger.log("toggleExpansion: \(fontFamily.name)")
                    viewStore.send(FontCollectionAction.toggleExpand(fontFamily))
                }
                Text(fontFamily.name)
                Spacer()
            }
        }
    }
}

fileprivate struct FontFamilyRowView_Previews: PreviewProvider {
    static var previews: some View {
        FontFamilyRowView(
            store: FontCollectionState.mockStore,
            fontFamily: FontFamily(
                name: "Chicken", fonts: mock_fonts
            )
        )
    }
}
