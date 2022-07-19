//
//  ItemTypeInfoPreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct ItemTypeInfoPreview: View {
    let store: Store<FontCollectionState, FontCollectionAction>
    var item: ItemType
        
    var body: some View {
        switch item {
        case let .font(font):
            FontInfoPreview(font: font)
        case let .fontFamily(fontFamily):
            FontFamilyInfoPreview(family: fontFamily)
        }
    }
}

// TODO: jdeda - done
// Fix me
struct ItemTypeInfoPreview_Previews: PreviewProvider {
    static var previews: some View {
        
        let attributes: [FontAttributeKey: String] =  {
            var ats = Dictionary(
                uniqueKeysWithValues: zip(
                    FontAttributeKey.allCases,
                    String.alphabet.accumulatingStrings()
                )
            )
            ats[.copyright] = String.alphabet + String.alphabet + String.alphabet + String.alphabet
            return ats
        }()
        
        let fonts = (1...10).map { int in
            Font(
                url: URL(fileURLWithPath: NSTemporaryDirectory()),
                name: "Chicken \(int)",
                familyName: "Cheese",
                attributes: attributes
            )
        }
        
        ItemTypeInfoPreview(
            store: FontCollectionState.mockStore,
            item: ItemType.fontFamily(FontFamily(
                name: "Cheese",
                fonts: fonts)
            )
        )
    }
}
    
