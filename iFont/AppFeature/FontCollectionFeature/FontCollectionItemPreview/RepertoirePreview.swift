//
//  ItemTypeRepertoirePreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct RepertoirePreview: View {
    let store: Store<FontCollectionState, FontCollectionAction>
    var item: FontCollectionItem
    
    var body: some View {
        Text("FontRepertoirePreviewView")
    }
}

// TODO: jdeda - done
// Fix me
struct ItemTypeRepertoirePreview_Previews: PreviewProvider {
    static var previews: some View {
        let fonts = (1...10).map { int in
            Font(
                url: URL(fileURLWithPath: NSTemporaryDirectory()),
                name: "Chicken \(int)",
                familyName: "Cheese"
            )
        }
        
        RepertoirePreview(
            store: FontCollectionState.mockStore,
            item: FontCollectionItem.fontFamily(FontFamily(name: "Cheese", fonts: fonts))
        )
    }
}
