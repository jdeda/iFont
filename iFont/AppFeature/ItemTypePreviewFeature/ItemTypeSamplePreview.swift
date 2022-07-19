//
//  ItemTypeSamplePreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct ItemTypeSamplePreview: View {
    let store: Store<FontCollectionState, FontCollectionAction>
    var item: ItemType
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            switch item {
            case let .font(font):
                FontSamplePreview(font: font)
            case let .fontFamily(fontFamily):
                FontFamilySamplePreview(family: fontFamily)
            }
        }
    }
}


struct ItemTypeSamplePreview_Previews: PreviewProvider {
    static var previews: some View {
        let fonts = (1...10).map { int in
            Font(
                url: URL(fileURLWithPath: NSTemporaryDirectory()),
                name: "Chicken \(int)",
                familyName: "Cheese"
            )
        }
        
        ItemTypeSamplePreview(
            store: FontCollectionState.mockStore,
            item: ItemType.fontFamily(FontFamily(name: "Cheese", fonts: fonts))
        )
    }
}

// MARK: - Helper Views

fileprivate struct FontSamplePreview: View {
    let font: Font
    
    var body: some View {
        VStack {
            Text(font.name)
                .font(.title)
                .foregroundColor(.gray)
                .padding(5)
            Text(String.alphabet.splitInHalf().left)
            Text(String.alphabet.splitInHalf().right)
            Text(String.alphabet.uppercased().splitInHalf().left)
            Text(String.alphabet.uppercased().splitInHalf().right)
            Text(String.digits)
            Spacer(minLength: 64)
        }
        .font(.custom(font.name, size: 32))
    }
}

fileprivate struct FontFamilySamplePreview: View {
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
                                FontSamplePreview(font: font)
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct FontFamilySamplePreview_Previews: PreviewProvider {
    static var previews: some View {
        FontFamilySamplePreview.init(
            family: FontFamily.init(
                name: "Cheese",
                fonts: [
                    Font(
                        url: URL.init(fileURLWithPath: NSTemporaryDirectory()),
                        name: "Cheese",
                        familyName: "Chicken")
                ]
            )
        )
    }
}


// TODO: jdeda - done
// Fix me
struct FontSamplePreview_Previews: PreviewProvider {
    static var previews: some View {
        FontSamplePreview(font: Font(
            url: URL.init(fileURLWithPath: NSTemporaryDirectory()),
            name: "Cheese",
            familyName: "Chicken"))
    }
}
