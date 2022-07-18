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
    
    
    // TODO: Jdeda
    // Fix: the right side view (the attribute string) should always start flush with the left side
    // and expand downwards into new lines if necessary
    var body: some View {
        HStack {
            Text("\(fontAttributeKey.title)")
                .foregroundColor(.secondary)
                .frame(width: 150, alignment: .trailing)
            Text(font.attributes[fontAttributeKey] ?? " ")
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
