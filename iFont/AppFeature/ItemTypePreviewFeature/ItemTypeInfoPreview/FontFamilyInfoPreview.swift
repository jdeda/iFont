//
//  FontFamilyInfoPreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/18/22.
//

import SwiftUI
import ComposableArchitecture


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

struct FontFamilyInfoPreview_Previews: PreviewProvider {
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
        
        let fonts = (1...10).map { int in
            Font(
                url: URL(fileURLWithPath: NSTemporaryDirectory()),
                name: "Chicken \(int)",
                familyName: "Cheese",
                attributes: attributes
            )
        }
        
        VStack {
            Text("FontFamilyInfoPreview")
            FontFamilyInfoPreview(family: FontFamily(
                name: "Cheese",
                fonts: fonts
            ))
        }
    }
}
