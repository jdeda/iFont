//
//  ItemTypePreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct FontCollectionItemPreview: View {
    var selection: FontCollectionItemPreviewType
    var item: FontCollectionItem
    
    var body: some View {
        switch selection {
        case .sample:
            SamplePreview(item: item)
        case .repertoire:
            RepertoirePreview(item: item)
        case .custom:
            CustomPreview(item: item)
        case .info:
            InfoPreview(item: item)
        }
    }
}


struct ItemTypePreview_Previews: PreviewProvider {
    static var previews: some View {
        let fonts = (1...10).map { int in
            Font(
                url: URL(fileURLWithPath: NSTemporaryDirectory()),
                name: "Chicken \(int)",
                familyName: "Cheese"
            )
        }
        
        FontCollectionItemPreview(
            selection: .sample,
            item: FontCollectionItem.fontFamily(FontFamily(name: "Cheese", fonts: fonts))
        )
    }
}

//struct FontCollectionItemPreview: View {
//    let store: Store<FontCollectionState, FontCollectionAction>
//    var selection: FontCollectionItemPreviewType
//    var item: FontCollectionItem
//
//    var body: some View {
//        WithViewStore(self.store) { viewStore in
//
//            // We previously said that these views will hold onto a store as we may have buttons in these views
//            // i.e. resize slider.
//
//            switch selection {
//            case .sample:
//                SamplePreview(store: store, item: item)
//            case .repertoire:
//                RepertoirePreview(store: store, item: item)
//            case .custom:
//                CustomPreview(store: store, item: item)
//            case .info:
//                InfoPreview(store: store, item: item)
//            }
//        }
//    }
//}
//
//
//struct ItemTypePreview_Previews: PreviewProvider {
//    static var previews: some View {
//        let fonts = (1...10).map { int in
//            Font(
//                url: URL(fileURLWithPath: NSTemporaryDirectory()),
//                name: "Chicken \(int)",
//                familyName: "Cheese"
//            )
//        }
//
//        FontCollectionItemPreview(
//            store: FontCollectionState.mockStore,
//            selection: .sample,
//            item: FontCollectionItem.fontFamily(FontFamily(name: "Cheese", fonts: fonts))
//        )
//    }
//}
