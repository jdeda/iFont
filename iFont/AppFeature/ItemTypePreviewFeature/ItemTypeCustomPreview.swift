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
        // TODO: jdeda
        // make sure all text examples are bound to same width...
        // hopefully this simuealtaneously fixes an issue
        // where text refuses to break into a new line
        // and all you see is something like "The quick bro..."
        VStack {
            Text("\(font.attributes[.full] ?? font.name)")
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

// TODO: jdeda
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
        ItemTypeCustomPreview(
            store: FontCollectionState.mockStore,
            item: ItemType.fontFamily(FontFamily(name: "Chicken", fonts: fonts))
        )
    }
}
