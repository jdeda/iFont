//
//  FontCollectionType.swift
//  iFont
//
//  Created by Klajd Deda on 7/8/22.
//

import Foundation
import SwiftUI

/**
 Represents possible categories a FontCollection may be. A FontCollection may only be one category.
 */
enum FontCollectionType: Equatable, Codable {
    case unknown
    case allFontsLibrary       // builtin, contains all fonts from all libraries, user cannot add/edit/delete this.
    case computerLibrary       // builtin, contains all fonts from system locations, user cannot add/edit/delete this.
    case standardUserLibrary   // builtin, there is only one user collection per user, some times zero, user can ???
    case library(URL)          // some builtin, user can add, edit, or delete any that exist.
    case smart                 // some builtin, user can add, edit, or delete any that exist.
    case basic                 // some builtin, user can add, edit, or delete any that exist.
}

extension FontCollectionType: Hashable {}

extension FontCollectionType {
    var imageSystemName: String {
        switch self {
        case .unknown:              return "questionmark"
        case .allFontsLibrary:      return "f.square"
        case .computerLibrary:      return "laptopcomputer"
        case .standardUserLibrary:  return "person.crop.square"
        case .library:              return "square.stack"
        case .smart:                return "gearshape"
        case .basic:                return "square.on.square"
        }
    }

    var accentColor: Color {
        switch self {
        case .unknown:             return .gray
        case .allFontsLibrary:     return .accentColor
        case .computerLibrary:     return .accentColor
        case .standardUserLibrary: return .accentColor
        case .library:             return .accentColor
        case .smart:               return .primary
        case .basic:               return .cyan
        }
    }
    
    public func matchingFonts(_ font: Font) -> Bool {
        switch self {
        case .unknown:
            return false
        case .allFontsLibrary:
            return true
        case .computerLibrary:
            return font.url.path.starts(with: "/System/Library/Fonts")
        case .standardUserLibrary:
            return font.url.path.starts(with: NSHomeDirectory())
        case let .library(libraryURL):
            return font.url.path.starts(with: libraryURL.path)
        case .smart:
            return false
        case .basic:
            return false
        }
    }
}

extension FontCollectionType {
    
    var isLibrary: Bool {
        if self == .allFontsLibrary || self == .computerLibrary || self == .standardUserLibrary {
            return true
        }
        else if case .library(_) = self {
            return true
        }
        else {
            return false
        }
    }
    var isSmart: Bool {
        self == .smart
    }
    var isBasic: Bool {
        self == .basic
    }
}

//enum FontCollectionType: Equatable, Hashable {
//
//    enum Library: Equatable, Hashable {
//        case all(URL)
//        case macOS(URL)
//        case user(URL)
//    }
//
//    case library(Library)
//    case smart
//    case normal
//}

// TODO: jdeda
// Define more rules to CollectionType depending on self
// can it be renamed ?
// can it be removed ?
// can it be modified ?
// etc
