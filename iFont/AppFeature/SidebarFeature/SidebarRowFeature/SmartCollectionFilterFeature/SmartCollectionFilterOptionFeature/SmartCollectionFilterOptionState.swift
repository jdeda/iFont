//
//  SmartCollectionFilterOption.swift
//  iFont
//
//  Created by Jesse Deda on 8/5/22.
//

import ComposableArchitecture


struct SmartCollectionFilterOptionState: Equatable, Identifiable {
    var id: SmartCollectionFilterOption { option } // MARK: What if two options are the same?
    var option: SmartCollectionFilterOption
    var filter: SmartCollectionFilterOption.StringFilter
}

enum SmartCollectionFilterOptionAction: Equatable {
    case nothing
}

struct SmartCollectionFilterOptionEnvironment {
    
}

extension SmartCollectionFilterOptionState {
    static let reducer = Reducer<
        SmartCollectionFilterOptionState,
        SmartCollectionFilterOptionAction,
        SmartCollectionFilterOptionEnvironment
    >.combine(
        Reducer { state, action, environment in
            switch action {
            case .nothing:
                return .none
            }
        }
    )
}

extension SmartCollectionFilterOptionState {
    static let mockStore = Store(
        initialState: SmartCollectionFilterOptionState(option: .kind(nil)),
        reducer: SmartCollectionFilterOptionState.reducer,
        environment: SmartCollectionFilterOptionEnvironment()
    )
}
