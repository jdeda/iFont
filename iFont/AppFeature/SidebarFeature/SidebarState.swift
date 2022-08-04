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
        self.basicCollections   = .init(uniqueElements: collections.filter(\.type.isBasic).map(SidebarRowState.init))
    }
    
//    private func validName(_ name: String) -> Bool {
//        libraryCollections.contains(where: { $0.collection.name == name }) ||
//        smartCollections.contains(where: { $0.collection.name == name }) ||
//        basicCollections.contains(where: { $0.collection.name == name })
//    }
//
//    private func validDirectory(_ url: URL) -> Bool {
//        libraryCollections.map(\.collection.type)
//    }
}

enum SidebarAction: BindableAction, Equatable {
    case binding(BindingAction<SidebarState>)
    case toggleHideSidebar
    case libraryCollectionRow(id: SidebarRowState.ID, action: SidebarRowAction)
    case smartCollectionRow(id: SidebarRowState.ID, action: SidebarRowAction)
    case basicCollectionRow(id: SidebarRowState.ID, action: SidebarRowAction)
    case row(id: SidebarRowState.ID, action: SidebarRowAction)
}

struct SidebarEnvironment { }

extension SidebarState {
    static let reducer = Reducer<SidebarState, SidebarAction, SidebarEnvironment>.combine(
        SidebarRowState.reducer.forEach(
            state: \.libraryCollections,
            action: /SidebarAction.libraryCollectionRow(id:action:),
            environment: { _ in .init()}
        ),
        SidebarRowState.reducer.forEach(
            state: \.smartCollections,
            action: /SidebarAction.smartCollectionRow(id:action:),
            environment: { _ in .init()}
        ),
        SidebarRowState.reducer.forEach(
            state: \.basicCollections,
            action: /SidebarAction.basicCollectionRow(id:action:),
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
                
            case let .libraryCollectionRow(id, action):
//                return .none
                return Effect(value: .row(id: id, action: action))
                
            case let .smartCollectionRow(id, action):
//                return .none
                return Effect(value: .row(id: id, action: action))
                
            case let.basicCollectionRow(id, action):
//                return .none
                return Effect(value: .row(id: id, action: action))
                
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
