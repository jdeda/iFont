//
//  ItemTypeInfoPreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct InfoPreview: View {
    let fonts: [Font]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(fonts) { font in
                    FontInfoPreview(font: font)
                }
            }
        }
    }
}

struct ItemTypeInfoPreview_Previews: PreviewProvider {
    static var previews: some View {
        InfoPreview(fonts: mock_fonts)
    }
}


// MARK: This is what we had before changing the switch statement to just a list. This is more convoluted.
//struct InfoPreview: View {
//    var item: FontCollectionItem
//
//    var body: some View {
//        ScrollView {
//            switch item {
//            case let .font(font):
//                FontInfoPreview(font: font)
//            case let .fontFamily(fontFamily):
//                FontFamilyInfoPreview(family: fontFamily)
//            }
//        }
//    }
//}
//
//struct ItemTypeInfoPreview_Previews: PreviewProvider {
//    static var previews: some View {
//
//        let attributes: [FontAttributeKey: String] =  {
//            var ats = Dictionary(
//                uniqueKeysWithValues: zip(
//                    FontAttributeKey.allCases,
//                    String.alphabet.accumulatingStrings()
//                )
//            )
//            ats[.copyright] = String.alphabet + String.alphabet + String.alphabet + String.alphabet
//            return ats
//        }()
//
//        let fonts = (1...10).map { int in
//            Font(
//                url: URL(fileURLWithPath: NSTemporaryDirectory()),
//                name: "Chicken \(int)",
//                familyName: "Cheese",
//                attributes: attributes
//            )
//        }
//
//        InfoPreview(
//            item: FontCollectionItem.fontFamily(FontFamily(
//                name: "Cheese",
//                fonts: fonts)
//            )
//        )
//    }
//}

fileprivate struct FontInfoPreview: View {
    var font: Font
    
    init(font: Font) {
        self.font = font
        self.font.attributes = font.fetchFontAttributes
    }
    
    var body: some View {
        VStack {
            
            // Title.
            VStack(alignment: .center) {
                Text(font.attributes[.full] ?? font.name)
                    .font(.custom(font.name, size: 20))
                Text(font.attributes[.full] ?? font.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            
            // List of Attributes.
            HStack {
                VStack(alignment: .leading) {
                    ForEach(FontAttributeKey.allCases) { attribute in
                        FontAttributePreview(font, fontAttributeKey: attribute)
                    }
                }
                Spacer()
            }
            Spacer()
        }
    }
}

fileprivate struct FontInfoPreview_Previews: PreviewProvider {
    static var previews: some View {
        FontInfoPreview(font: Font(
            descriptor: .init(),
            url: URL(fileURLWithPath: NSTemporaryDirectory()),
            name: "Chicken",
            familyName: "Cheese",
            attributes: mock_font_attributes
        ))
    }
}


fileprivate struct FontAttributePreview: View {
    private let font: Font
    private let fontAttributeKey: FontAttributeKey
    
    init(_ font: Font, fontAttributeKey: FontAttributeKey) {
        self.font = font
        self.fontAttributeKey = fontAttributeKey
    }
    
    var body: some View {
        if let attribute = font.attributes[fontAttributeKey] {
            HStack(alignment: .firstTextBaseline) {
                Text("\(fontAttributeKey.title)")
                    .foregroundColor(.secondary)
                    .frame(width: 150, alignment: .topTrailing)
                Text(attribute)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        else {
            EmptyView()
        }
    }
}

fileprivate struct FontAttributePreview_Previews: PreviewProvider {
    static var previews: some View {
        FontAttributePreview(
            Font(
                descriptor: .init(),
                url: URL(fileURLWithPath: NSTemporaryDirectory()),
                name: "Chicken",
                familyName: "Cheese",
                attributes: mock_font_attributes
            ),
            fontAttributeKey: .copyright
        )
    }
}
