//
//  SmartCollectionFilterOptionView.swift
//  iFont
//
//  Created by Jesse Deda on 8/5/22.
//

import SwiftUI
import ComposableArchitecture

struct OptionPicker: View {
    @Binding var selection: SmartCollectionFilterOption.StringFilter
    let stringFilters: [SmartCollectionFilterOption.StringFilter]
    
    var body: some View {
        HStack {
            Picker("", selection: $selection) {
                ForEach(stringFilters, id: \.self) {
                    Text($0.string)
                }
            }
        }
    }
}

struct KindPicker: View {
    @Binding var selection: SmartCollectionFilterOption.FontKind

    var body: some View {
        HStack {
            Picker("", selection: $selection) {
                ForEach(SmartCollectionFilterOption.StringFilter.allCases, id: \.self) {
                    Text($0.string)
                }
            }
        }
    }
}

struct SmartCollectionFilterOptionView: View {
    let store: Store<
        SmartCollectionFilterOptionState,
        SmartCollectionFilterOptionAction
    >
    var body: some View {
        WithViewStore(store) { viewStore in
            Group {
                switch viewStore.option {
                case let .kind(kind):
                    EmptyView()
                case let .style(style):
                    EmptyView()
                case let .styleName(string):
                    EmptyView()
                case let .familyName(string):
                    EmptyView()
                case let .postscriptName(string):
                    EmptyView()
                }
            }
            .frame(width: 400, height: 200)
        }
    }
}

struct SmartCollectionFilterOptionView_Previews: PreviewProvider {
    static var previews: some View {
        SmartCollectionFilterOptionView(store: SmartCollectionFilterOptionState.mockStore)
    }
}
