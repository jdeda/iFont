//
//  ItemTypeCustomPreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct CustomPreview: View {
    let store: Store<FontCollectionState, FontCollectionAction>
    var item: FontCollectionItem
    
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

// TODO: jdeda - done
// Fix me
struct ItemTypeCustomPreview_Previews: PreviewProvider {
    static var previews: some View {
        let fonts = (1...10).map { int in
            Font(
                url: URL(fileURLWithPath: NSTemporaryDirectory()),
                name: "Chicken \(int)",
                familyName: "Cheese"
            )
        }
        CustomPreview(
            store: FontCollectionState.mockStore,
            item: FontCollectionItem.fontFamily(FontFamily(name: "Chicken", fonts: fonts))
        )
    }
}


fileprivate struct FontCustomPreview: View {
    let font: Font
    
    var body: some View {
        VStack {
            Text("\(font.attributes[.full] ?? font.name)")
                .font(.title)
                .foregroundColor(.gray)
                .padding(5)
            HStack {
            Text(String.quickBrownFox)
                .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            Spacer(minLength: 64)
        }
        .font(.custom(font.name, size: 32))
    }
}

fileprivate struct FontFamilyCustomPreview: View {
    var family: FontFamily
    
    var body: some View {
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