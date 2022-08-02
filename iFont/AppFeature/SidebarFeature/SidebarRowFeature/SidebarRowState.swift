//
//  SidebarRowState.swift
//  iFont
//
//  Created by Jesse Deda on 8/2/22.
//

import Foundation

struct SidebarRowState: Equatable, Identifiable {
    var id: String { collection.name }
    var collection: FontCollection
}

enum SidebarRowAction: Equatable {
    case newLibrary
    case newSmartCollection
    case newBasicCollection
    case rename
    case delete
}
