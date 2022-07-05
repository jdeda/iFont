//
//  ItemTypeCustomPreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct ItemTypeCustomPreview: View {
    let store: Store<AppState, AppAction>
    var item: ItemType
    
    var body: some View {
        Text("FontCustomPreviewView")
    }
}

// TODO: Jdeda Fix me
//struct FontCustomPreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        FontCustomPreviewView()
//    }
//}
