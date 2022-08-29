//
//  SidebarState.swift
//  iFont
//
//  Created by Jesse Deda on 8/1/22.
//

import SwiftUI
import ComposableArchitecture

struct SidebarState: Equatable {
    // TODO: jdeda
    // In reality, only the sidebar cares about an identifier for an ID
    // may be better to create a type for this instead of
    // adding an id to FontCollection
    @BindableState var selectedCollection: FontCollection.ID?
    var libraryCollections: IdentifiedArrayOf<SidebarRowState>
    var smartCollections: IdentifiedArrayOf<SidebarRowState>
    var basicCollections: IdentifiedArrayOf<SidebarRowState>
    
    init(selectedCollection: FontCollection.ID? = nil, collections: [FontCollection] = []) {
        self.selectedCollection = selectedCollection
        
        let names = Set(collections.map(\.name))

        self.libraryCollections = .init(uniqueElements: collections.filter(\.type.isLibrary).map {
            var nonValidNames = names
            nonValidNames.remove($0.name)
            return .init(collection: $0, nonValidNames: nonValidNames)
        })
        self.smartCollections = .init(uniqueElements: collections.filter(\.type.isSmart).map {
            var nonValidNames = names
            nonValidNames.remove($0.name)
            return .init(collection: $0, nonValidNames: nonValidNames)
        })
        self.basicCollections = .init(uniqueElements: collections.filter(\.type.isBasic).map {
            var nonValidNames = names
            nonValidNames.remove($0.name)
            return .init(collection: $0, nonValidNames: nonValidNames)
        })
    }
}

enum SidebarAction: BindableAction, Equatable {
    case binding(BindingAction<SidebarState>)
    case toggleHideSidebar
    case libraryCollectionRow(id: SidebarRowState.ID, action: SidebarRowAction)
    case smartCollectionRow(id: SidebarRowState.ID, action: SidebarRowAction)
    case basicCollectionRow(id: SidebarRowState.ID, action: SidebarRowAction)
    case row(id: SidebarRowState.ID, action: SidebarRowAction)
    case recievedFontCollectionItemDrop(FontCollectionItemDnD)
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
                return Effect(value: .row(id: id, action: action))
                
            case let .smartCollectionRow(id, action):
                return Effect(value: .row(id: id, action: action))
                
            case let.basicCollectionRow(id, action):
                return Effect(value: .row(id: id, action: action))
                
            case let .row(id, action):
                if let newName = (/SidebarRowAction.renameInTextField).extract(from: action) {
                    let names = Set(
                        state.libraryCollections.map(\.collection.name) +
                        state.smartCollections.map(\.collection.name) +
                        state.basicCollections.map(\.collection.name)
                    )
                    
                    state.libraryCollections.forEach {
                        var nonValidNames = names
                        nonValidNames.remove($0.collection.name)
                        state.libraryCollections[id: $0.id]!.nonValidNames = nonValidNames
                    }
                    state.smartCollections.forEach {
                        var nonValidNames = names
                        nonValidNames.remove($0.collection.name)
                        state.smartCollections[id: $0.id]!.nonValidNames = nonValidNames
                    }
                    state.basicCollections.forEach {
                        var nonValidNames = names
                        nonValidNames.remove($0.collection.name)
                        state.basicCollections[id: $0.id]!.nonValidNames = nonValidNames
                    }
                }
                return .none
                
            case let .recievedFontCollectionItemDrop(item):
                let found = unyummers(item)
                return .none
            }
        }
    )
        .binding()
//        .debug()
}

extension SidebarState {
    static let mockStore = Store(
        initialState: SidebarState(collections: []),
        reducer: SidebarState.reducer,
        environment: SidebarEnvironment()
    )
}
