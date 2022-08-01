//
//  SidebarState.swift
//  iFont
//
//  Created by Jesse Deda on 8/1/22.
//

import SwiftUI
import ComposableArchitecture

struct SidebarState: Equatable {
    @BindableState var selectedCollection: FontCollection.ID?
    var collections: [FontCollection]
}

enum SidebarAction: BindableAction, Equatable {
    case binding(BindingAction<SidebarState>)
    case sidebarToggle
}

struct SidebarEnvironment { }

extension SidebarState {
    static let reducer = Reducer<SidebarState, SidebarAction, SidebarEnvironment>.combine(
        Reducer { state, action, environment in
            switch action {
            case .binding:
                return .none
                
            case .sidebarToggle:
                NSApp.keyWindow?
                    .firstResponder?
                    .tryToPerform(#selector(NSSplitViewController.toggleSidebar), with: nil)
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
