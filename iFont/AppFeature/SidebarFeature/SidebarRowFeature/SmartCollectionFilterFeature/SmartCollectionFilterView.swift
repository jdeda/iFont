//
//  SmartCollectionFilterView.swift
//  iFont
//
//  Created by Jesse Deda on 8/5/22.
//

import SwiftUI
import ComposableArchitecture

struct SmartCollectionFilterView: View {
    let store: Store<SmartCollectionFilterState, SmartCollectionFilterAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HStack {
                    Picker("", selection: viewStore.binding(\.$matchAllFilterParams)) {
                        ForEach([true, false], id: \.self) {
                            Text($0 == true ? "All" : "Any")
                        }
                    }
                    .frame(width: 100)
                    Text("of the following are true")
                }
                ScrollView {
                    ForEachStore(store.scope(
                            state: \.options,
                            action: SmartCollectionFilterAction.option
                    )) { childStore in
                            EmptyView()
                    }
//                    ForEachStore(
//                        store.scope(
//                            state: \.options,
//                            action: SmartCollectionFilterAction.option
//                        ),
//                        content: SmartCollectionFilterOptionView(store:)
//                    )
                }
            }
            .frame(width: 400)
            .border(Color.red)
        }
    }
}

struct SmartCollectionFilterView_Previews: PreviewProvider {
    static var previews: some View {
        SmartCollectionFilterView(store: SmartCollectionFilterState.mockStore)
//            .padding()
    }
}
