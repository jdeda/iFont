//
//  ItemTypeInfoPreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct ItemTypeInfoPreview: View {
    let store: Store<AppState, AppAction>
    var item: ItemType
    
    var body: some View {
        Text("FontInfoPreviewView")
    }
}

// TODO: Jdeda Fix me
//struct FontInfoPreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        FontInfoPreviewView()
//    }
//}
