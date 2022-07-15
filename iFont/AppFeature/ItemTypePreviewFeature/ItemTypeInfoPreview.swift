//
//  ItemTypeInfoPreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

fileprivate struct FontAttributePreview: View {
    let font: Font
    private let fontAttribute: FontAttributeKey
    
    init(_ font: Font, title: String, fontAttribute: FontAttributeKey) {
        self.font = font
        self.fontAttribute = fontAttribute
    }
    
    var body: some View {
        HStack {
            Text("\(fontAttribute.title)")
                .foregroundColor(.secondary)
                .frame(width: 150, alignment: .trailing)
            Text(font.attributes[fontAttribute] ?? " ")
                .frame(alignment: .leading)
        }
    }
}

fileprivate struct FontInfoPreview: View {
    let font: Font
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                Text(font.name)
                    .font(.custom(font.name, size: 32))
                Text(font.name)
                    .font(.caption)
            }
            .padding()
            
            HStack {
                VStack(alignment: .leading) {
//                    // debug
//                    ForEach(FontAttributeKey.allCases) { fontAttribute in
//                        FontAttributePreview(font, title: fontAttribute.title, fontAttribute: fontAttribute)
//                    }
//                    Divider()
                    Group {
                        // we don't have these easily
                        FontAttributePreview(font, title: "PostScript name", fontAttribute: .postScript)
                        FontAttributePreview(font, title: "Full name", fontAttribute: .full)
                        FontAttributePreview(font, title: "Family name", fontAttribute: .family)
                        FontAttributePreview(font, title: "Style", fontAttribute: .style)
                        // FontAttributePreview(font, title: "Kind", fontAttribute: .kind)
                        // FontAttributePreview(font, title: "Language", fontAttribute: .language)
                        // FontAttributePreview(font, title: "Script", fontAttribute: .script)
                        FontAttributePreview(font, title: "Version", fontAttribute: .version)
                    }
                    Group {
                        // FontAttributePreview(font, title: "Location", fontAttribute: .location)
                        FontAttributePreview(font, title: "Unique name", fontAttribute: .unique)
                        FontAttributePreview(font, title: "Designer", fontAttribute: .designer)
                        FontAttributePreview(font, title: "Copyright", fontAttribute: .copyright)
                        FontAttributePreview(font, title: "Trademark", fontAttribute: .trademark)
                        // FontAttributePreview(font, title: "Enabled", fontAttribute: .enabled)
                        FontAttributePreview(font, title: "Copy protected", fontAttribute: .copyright)
                        // FontAttributePreview(font, title: "Embedding", fontAttribute: .embedding)
                        // FontAttributePreview(font, title: "Glyph count", fontAttribute: .glyphCount)
                    }
                }
            }
            Spacer()
        }
    }
}

struct FontInfoPreview_Previews: PreviewProvider {
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
        
        VStack {
            Text("FontInfoPreview")
            FontInfoPreview(font: Font(
                url: URL(fileURLWithPath: NSTemporaryDirectory()),
                name: "Chicken",
                familyName: "Cheese",
                attributes: attributes
            ))
        }
    }
}

fileprivate struct FontFamilyInfoPreview: View {
    let family: FontFamily
    
    var body: some View {
        List {
            ForEach(family.fonts, id: \.name) { font in
                FontInfoPreview(font: font)
            }
        }
    }
}


struct ItemTypeInfoPreview: View {
    let store: Store<FontCollectionState, FontCollectionAction>
    var item: ItemType
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            switch item {
            case let .font(font):
                FontInfoPreview(font: font)
            case let .fontFamily(fontFamily):
                FontFamilyInfoPreview(family: fontFamily)
            }
        }
    }
}

// TODO: jdeda
// Fix me
//struct FontInfoPreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        FontInfoPreviewView()
//    }
//}

//
//struct FontFamilyInfoPreview: View {
//    let family: FontFamily
//
//    var body: some View {
//        List {
//            ForEach(family.fonts, id: \.name) { font in
//                FontInfoPreview(font: font)
//                    .padding()
//            }
//        }
//    }
//}
