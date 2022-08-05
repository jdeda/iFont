//
//  SmartCollectionFilter.swift
//  iFont
//
//  Created by Jesse Deda on 8/4/22.
//

import ComposableArchitecture

struct SmartCollectionFilter: Equatable {
    var options: IdentifiedArrayOf<SmartCollectionFilterOption> = []
}


struct SmartCollectionFilterState: Equatable {
    @BindableState var matchAllFilterParams: Bool = true
    var options: [SmartCollectionFilterOptionState] = []
}

enum SmartCollectionFilterAction: BindableAction, Equatable {
    case binding(BindingAction<SmartCollectionFilterState>)
    case option(id: SmartCollectionFilterOptionState.ID, action: SmartCollectionFilterOptionAction)
}

struct SmartCollectionFilterEnvironment { }

extension SmartCollectionFilterState {
    static let reducer = Reducer<
        SmartCollectionFilterState,
        SmartCollectionFilterAction,
        SmartCollectionFilterEnvironment
    >.combine(
        Reducer { state, action, environment in
            switch action {
            case .binding:
                return .none
            case let .option(id, optionAction):
                return .none
            }
        }.binding()
    )
}

extension SmartCollectionFilterState {
    static let mockStore = Store.init(
        initialState: SmartCollectionFilterState(
            matchAllFilterParams: false,
            options: [
                .init(option: .kind(nil)),
                .init(option: .style(nil)),
                .init(option: .styleName(nil)),
                .init(option: .familyName(nil)),
                .init(option: .postscriptName(nil))
            ]
        ),
        reducer: SmartCollectionFilterState.reducer,
        environment: SmartCollectionFilterEnvironment()
    )
}
