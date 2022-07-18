//
//  FontInfoPreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/18/22.
//

import SwiftUI
import ComposableArchitecture

fileprivate struct FontAttributePreview: View {
    private let font: Font
    private let fontAttributeKey: FontAttributeKey
    
    init(_ font: Font, fontAttributeKey: FontAttributeKey) {
        self.font = font
        self.fontAttributeKey = fontAttributeKey
    }
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("\(fontAttributeKey.title)")
                .foregroundColor(.secondary)
                .frame(width: 150, alignment: .topTrailing)
            Text(font.attributes[fontAttributeKey] ?? " ")
        }
    }
}

struct FontAttributePreview_Previews: PreviewProvider {
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
            FontAttributePreview(
                Font(
                    url: URL(fileURLWithPath: NSTemporaryDirectory()),
                    name: "Chicken",
                    familyName: "Cheese",
                    attributes: attributes
                ),
                fontAttributeKey: .copyright
            )
            .frame(width: 400, height: 100)
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
                    ForEach(FontAttributeKey.allCases) { attribute in
                        FontAttributePreview(font, fontAttributeKey: attribute)
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
