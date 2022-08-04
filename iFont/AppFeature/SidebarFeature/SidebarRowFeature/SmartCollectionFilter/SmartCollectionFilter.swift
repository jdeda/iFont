//
//  SmartCollectionFilter.swift
//  iFont
//
//  Created by Jesse Deda on 8/4/22.
//

import ComposableArchitecture

struct SmartCollectionFilter: Equatable {
    
}

struct SmartCollectionFilterState: Equatable {
    
}

enum SmartCollectionFilterAction: Equatable {
    case nothing
}

struct SmartCollectionFilterEnvironment { }

extension SmartCollectionFilterState {
    static let reducer = Reducer<
        SmartCollectionFilterState,
        SmartCollectionFilterAction,
        SmartCollectionFilterEnvironment
    >
        .combine(
        Reducer { state, action, environment in
            switch action {
                case .nothing:
                    return .none
            }
        }
    )
}

extension SmartCollectionFilterState {
    static let mockStore = Store.init(
        initialState: SmartCollectionFilterState(),
        reducer: SmartCollectionFilterState.reducer,
        environment: SmartCollectionFilterEnvironment()
    )
}
