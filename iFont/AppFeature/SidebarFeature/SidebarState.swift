//
//  SidebarState.swift
//  iFont
//
//  Created by Jesse Deda on 8/1/22.
//

import Foundation
import ComposableArchitecture

struct SidebarState: Equatable {
    @BindableState var selectedCollection: FontCollection.ID?
    var collections: [FontCollection]
}

enum SidebarAction: BindableAction, Equatable {
    case binding(BindingAction<SidebarState>)
}

struct SidebarEnvironment { }

extension SidebarState {
    static let reducer = Reducer<SidebarState, SidebarAction, SidebarEnvironment>.combine(
        Reducer { state, action, environment in
            switch action {
            case .binding:
                return .none
            }
        }
    )
        .binding()
}

extension SidebarState {
    static let mockStore = Store(
        initialState: SidebarState(collections: []),
        reducer: SidebarState.reducer,
        environment: SidebarEnvironment()
    )
}
