//
//  ItemTypePreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct ItemTypePreview: View {
    let store: Store<FontCollectionState, FontCollectionAction>
    var selection: ItemPreviewType
    var item: ItemType
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            
            // We previously said that these views will hold onto a store as we may have buttons in these views
            // i.e. resize slider.
            switch selection {
            case .sample:
                ItemTypeSamplePreview(store: store, item: item)
            case .repertoire:
                ItemTypeRepertoirePreview(store: store, item: item)
            case .custom:
                ItemTypeCustomPreview(store: store, item: item)
            case .info:
                ItemTypeInfoPreview(store: store, item: item)
            }
        }
    }
}
