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
    var libraryCollections: IdentifiedArrayOf<SidebarRowState>
    var smartCollections: IdentifiedArrayOf<SidebarRowState>
    var basicCollections: IdentifiedArrayOf<SidebarRowState>
    
    init(selectedCollection: FontCollection.ID? = nil, collections: [FontCollection] = []) {
        self.selectedCollection = selectedCollection
        self.libraryCollections = .init(uniqueElements: collections.filter(\.type.isLibrary).map(SidebarRowState.init))
        self.smartCollections   = .init(uniqueElements: collections.filter(\.type.isSmart).map(SidebarRowState.init))
        self.basicCollections   = .init(uniqueElements:collections.filter(\.type.isBasic).map(SidebarRowState.init))
    }
}

enum SidebarAction: BindableAction, Equatable {
    case binding(BindingAction<SidebarState>)
    case toggleHideSidebar
    case row(id: SidebarRowState.ID, action: SidebarRowAction)
}

struct SidebarEnvironment { }

extension SidebarState {
    static let reducer = Reducer<SidebarState, SidebarAction, SidebarEnvironment>.combine(
        SidebarRowState.reducer.forEach(
            state: \.libraryCollections,
            action: /SidebarAction.row(id:action:),
            environment: { _ in .init()}
        ),
        SidebarRowState.reducer.forEach(
            state: \.smartCollections,
            action: /SidebarAction.row(id:action:),
            environment: { _ in .init()}
        ),
        SidebarRowState.reducer.forEach(
            state: \.basicCollections,
            action: /SidebarAction.row(id:action:),
            environment: { _ in .init()}
        ),
        Reducer { state, action, environment in
            switch action {
            case .binding:
                return .none
                
            case .toggleHideSidebar:
                NSApp.keyWindow?
                    .firstResponder?
                    .tryToPerform(#selector(NSSplitViewController.toggleSidebar), with: nil)
                return .none
                
            case let .row(id, action):
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
