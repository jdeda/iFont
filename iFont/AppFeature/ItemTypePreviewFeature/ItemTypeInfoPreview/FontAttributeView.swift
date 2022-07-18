//
//  FontAttributeView.swift
//  iFont
//
//  Created by Jesse Deda on 7/18/22.
//

import SwiftUI
import ComposableArchitecture

struct FontAttributePreview: View {
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
            }
        }
        else {
            EmptyView()
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
