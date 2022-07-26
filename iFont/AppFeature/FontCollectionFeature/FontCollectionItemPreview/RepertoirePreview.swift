//
//  ItemTypeRepertoirePreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct RepertoirePreview: View {
    var item: FontCollectionItem
    
    var body: some View {
        Text("FontRepertoirePreviewView")
    }
}

struct ItemTypeRepertoirePreview_Previews: PreviewProvider {
    static var previews: some View {
        RepertoirePreview(item: .fontFamily(.init(name: "Cheese",fonts: mock_fonts)))
    }
}
