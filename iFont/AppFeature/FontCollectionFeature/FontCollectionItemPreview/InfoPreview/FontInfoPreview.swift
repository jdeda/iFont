//
//  FontInfoPreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/18/22.
//

import SwiftUI
import ComposableArchitecture

struct FontInfoPreview: View {
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

struct FontInfoPreview_Previews: PreviewProvider {
    static var previews: some View {
        FontInfoPreview(font: Font(
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
                url: URL(fileURLWithPath: NSTemporaryDirectory()),
                name: "Chicken",
                familyName: "Cheese",
                attributes: mock_font_attributes
            ),
            fontAttributeKey: .copyright
        )
    }
}
