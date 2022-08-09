//
//  SidebarRowState.swift
//  iFont
//
//  Created by Jesse Deda on 8/2/22.
//

import Foundation
import ComposableArchitecture

struct SidebarRowState: Equatable, Identifiable {
    var id: String { collection.name }
    var collection: FontCollection
}

enum SidebarRowAction: Equatable {
    case newLibrary(directory: URL)
    case newSmartCollection(filter: SmartCollectionFilterState, baseID: FontCollection.ID)
    case newBasicCollection
    case rename
    case delete
}

struct SidebarRowEnvironment { }

extension SidebarRowState {
    static let reducer = Reducer<SidebarRowState, SidebarRowAction, SidebarRowEnvironment>.combine(
        Reducer { state, action, environment in
            switch action {
            case let .newLibrary(directory: URL):
                return .none
            case .newSmartCollection:
                return .none
            case .newBasicCollection:
                return .none
            case .rename:
                return .none
            case .delete:
                return .none
            }
        }
    )
}

extension SidebarRowState {
    static let mockStore = Store(
        initialState: SidebarRowState(collection: .init(
            type: .basic,
            fonts: mock_fonts,
            fontFamilies: mock_fonts.groupedByFamily(),
            name: "Mock Fonts"
        )),
        reducer: SidebarRowState.reducer,
        environment: SidebarRowEnvironment()
    )
}
