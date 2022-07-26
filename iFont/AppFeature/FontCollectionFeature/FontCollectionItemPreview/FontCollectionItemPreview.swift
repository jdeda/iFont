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
    
    init(selection: FontCollectionItemPreviewType, item: FontCollectionItem) {
        self.selection = selection
        self.item = item
    }
    
    var body: some View {
        switch selection {
        case .sample:
            SamplePreview(fonts: itemToFonts(item))
        case .repertoire:
            RepertoirePreview(fonts: itemToFonts(item))
        case .custom:
            CustomPreview(fonts: itemToFonts(item))
        case .info:
            InfoPreview(fonts: itemToFonts(item))
        }
    }
    
    private func itemToFonts(_ item: FontCollectionItem) -> [Font] {
        switch item {
        case let .font(font):
            return [font]
        case let .fontFamily(family):
            return family.fonts
        }
    }
}

struct ItemTypePreview_Previews: PreviewProvider {
    static var previews: some View {
        FontCollectionItemPreview(
            selection: .sample,
            item: .fontFamily(FontFamily(name: "Cheese", fonts: mock_fonts))
        )
    }
}

//struct FontCollectionItemPreview: View {
//    var selection: FontCollectionItemPreviewType
//    var item: FontCollectionItem
//
//    var body: some View {
//        switch selection {
//        case .sample:
//            SamplePreview(item: item)
//        case .repertoire:
//            RepertoirePreview(item: item)
//        case .custom:
//            CustomPreview(item: item)
//        case .info:
//            InfoPreview(item: item)
//        }
//    }
//}

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
