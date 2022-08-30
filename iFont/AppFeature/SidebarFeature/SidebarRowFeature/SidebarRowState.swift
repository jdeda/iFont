//
//  SidebarRowState.swift
//  iFont
//
//  Created by Jesse Deda on 8/2/22.
//

import Foundation
import ComposableArchitecture

struct SidebarRowState: Equatable, Identifiable {
    let id: UUID
    //    var id: String { collection.name }
    var collection: FontCollection;
    
    var nonValidNames: Set<String>
    
    init(collection: FontCollection, nonValidNames: Set<String> = []) {
        self.id = collection.id
        self.collection = collection
        self.nonValidNames = nonValidNames
    }
}

enum SidebarRowAction: Equatable {
    case newLibrary(directory: URL)
    case newSmartCollection
    case newBasicCollection
    case rename
    case delete
    case renameInTextField(String)
    case recievedFontCollectionItemDrop(FontCollectionItemDnD)
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
            case let .renameInTextField(newName):
                state.collection.name = newName

                // TODO: Jdeda
                // This is not working...very weird behavior.
//                if !state.nonValidNames.contains(newName) {
//                    state.collection.name = newName
//                }
//                else {
//                    state.collection.name = "\(state.collection.name)"
//                }
                return .none
            case let .recievedFontCollectionItemDrop(drop):
                return .none
            }
        }
    )
        .debug()
}

extension SidebarRowState {
    static let mockStore = Store(
        initialState: SidebarRowState(
//            id: UUID(),
            collection: .init(
                type: .basic,
                fonts: mock_fonts,
                fontFamilies: mock_fonts.groupedByFamily(),
                name: "Mock Fonts"
            )
        ),
        reducer: SidebarRowState.reducer,
        environment: SidebarRowEnvironment()
    )
}
