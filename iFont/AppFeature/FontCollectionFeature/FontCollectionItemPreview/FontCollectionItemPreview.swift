//
//  ItemTypePreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct FontCollectionItemPreview: View {
    let selection: FontCollectionItemPreviewType
    let item: FontCollectionItem
    let fonts: [Font]
    
    init(selection: FontCollectionItemPreviewType, item: FontCollectionItem) {
        self.selection = selection
        self.item = item
        self.fonts = {
            switch item {
            case let .font(font):
                return [font]
            case let .fontFamily(family):
                return family.fonts
            }
        }()
    }
    
    var body: some View {
        switch selection {
        case .sample:
            SamplePreview(fonts: fonts)
//        case .repertoire:
//            RepertoirePreview(fonts: fonts)
        case .custom:
            CustomPreview(fonts: fonts)
        case .info:
            InfoPreview(fonts: fonts)
        }
    }
}

struct ItemTypePreview_Previews: PreviewProvider {
    static var previews: some View {
        FontCollectionItemPreview(
            selection: .sample,
            item: .fontFamily(mock_family)
        )
    }
}
