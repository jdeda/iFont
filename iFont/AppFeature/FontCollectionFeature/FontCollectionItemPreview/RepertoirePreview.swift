//
//  ItemTypeRepertoirePreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct RepertoirePreview: View {
    let fonts: [Font]
    var fontSize: Double = 32
    
    var body: some View {
        Text("FontRepertoirePreviewView")
    }
}

struct ItemTypeRepertoirePreview_Previews: PreviewProvider {
    static var previews: some View {
        RepertoirePreview(fonts: mock_fonts)
    }
}
