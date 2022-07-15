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
    let targetAttributeKey: FontAttributeKey
    let title: String
    
    init(_ font: Font, title: String, target: FontAttributeKey) {
        self.font = font
        self.title = title
        self.targetAttributeKey = target
    }
    
    var body: some View {
        HStack {
            Text("\(title)")
                .foregroundColor(.secondary)
                .frame(width: 150, alignment: .trailing)
            Text(font.attributes[targetAttributeKey] ?? " ")
                .frame(alignment: .leading)
        }
    }
}
struct FontInfoPreview: View {
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
                    Group {
                        FontAttributePreview(font, title: "PostScript name", target: .postScript)
                        FontAttributePreview(font, title: "Full name", target: .full)
                        FontAttributePreview(font, title: "Family name", target: .family)
                        FontAttributePreview(font, title: "Style", target: .style)
                        //                        FontAttributePreview(font, title: "Kind", target: .kind)
                        //                        FontAttributePreview(font, title: "Language", target: .language)
                        //                        FontAttributePreview(font, title: "Script", target: .script)
                        FontAttributePreview(font, title: "Version", target: .version)
                    }
                    Group {
                        //                        FontAttributePreview(font, title: "Location", target: .location)
                        FontAttributePreview(font, title: "Unique name", target: .unique)
                        FontAttributePreview(font, title: "Copyright", target: .copyright)
                        FontAttributePreview(font, title: "Trademark", target: .trademark)
                        //                        FontAttributePreview(font, title: "Enabled", target: .enabled)
                        FontAttributePreview(font, title: "Copy protected", target: .copyright)
                        //                        FontAttributePreview(font, title: "Embedding", target: .embedding)
                        //                        FontAttributePreview(font, title: "Glyph count", target: .glyphCount)
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
        
        
        FontInfoPreview(font: Font(
            url: URL(fileURLWithPath: NSTemporaryDirectory()),
            name: "Chicken",
            familyName: "Cheese",
            attributes: attributes
        ))
    }
}

struct FontFamilyInfoPreview: View {
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

// TODO: Jdeda Fix me
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
