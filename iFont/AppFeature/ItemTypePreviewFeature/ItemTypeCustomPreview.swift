//
//  ItemTypeCustomPreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct FontCustomPreview: View {
    let font: Font
    
    var body: some View {
        VStack {
            Text(font.name)
                .font(.title)
                .foregroundColor(.gray)
                .padding(5)
            Text(String.quickBrownFox)
            Spacer(minLength: 64)
        }
        .font(.custom(font.name, size: 32))
    }
}

struct FontFamilyCustomPreview: View {
    var family: FontFamily
    
    var body: some View {
        VStack(alignment: .center) {
            Text(family.name)
            HStack(alignment: .center) {
                List {
                    HStack {
                        Spacer()
                        VStack {
                            ForEach(family.fonts, id: \.name) { font in
                                FontCustomPreview(font: font)
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct ItemTypeCustomPreview: View {
    let store: Store<FontCollectionState, FontCollectionAction>
    var item: ItemType
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            switch item {
            case let .font(font):
                FontCustomPreview(font: font)
            case let .fontFamily(fontFamily):
                FontFamilyCustomPreview(family: fontFamily)
            }
        }
    }
}

// TODO: Jdeda Fix me
//struct FontCustomPreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        FontCustomPreviewView()
//    }
//}
