//
//  SmartCollectionFilterOptionView.swift
//  iFont
//
//  Created by Jesse Deda on 8/5/22.
//

import SwiftUI
import ComposableArchitecture

struct SmartCollectionFilterOptionView: View {
    let store: Store<
        SmartCollectionFilterOptionState,
        SmartCollectionFilterOptionAction
    >
    var body: some View {
        WithViewStore(store) { viewStore in
            Text("SmartCollectionFilterOptionView")
        }
    }
}

struct SmartCollectionFilterOptionView_Previews: PreviewProvider {
    static var previews: some View {
        SmartCollectionFilterOptionView(store: SmartCollectionFilterOptionState.mockStore)
    }
}
