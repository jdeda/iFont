//
//  ItemTypeRepertoirePreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct ItemTypeRepertoirePreview: View {
    let store: Store<FontCollectionState, FontCollectionAction>
    var item: ItemType
    
    var body: some View {
        Text("FontRepertoirePreviewView")
    }
}

// TODO: Jdeda Fix me
//struct FontRepertoirePreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        FontRepertoirePreviewView()
//    }
//}
