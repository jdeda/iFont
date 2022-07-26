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
        LazyVStack {
            ForEach(family.fonts, id: \.name) { font in
                FontInfoPreview(font: font)
            }
        }
    }
}

struct FontFamilyInfoPreview_Previews: PreviewProvider {
    static var previews: some View {        
        FontFamilyInfoPreview(family: FontFamily(
            name: "Cheese",
            fonts: mock_fonts
        ))
    }
}
