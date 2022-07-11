//
//  FontCollectionType.swift
//  iFont
//
//  Created by Klajd Deda on 7/8/22.
//

import Foundation
import SwiftUI

enum FontCollectionType: Equatable {
    case unknown
    case allFonts
    case computer
    case user          // there is only one user collection per user, some times zero
    case library(URL)
    case smart
    case normal
}

extension FontCollectionType: Hashable {}

extension FontCollectionType {
    var imageSystemName: String {
        switch self {
        case .unknown:      return "questionmark"
        case .allFonts:     return "f.square"
        case .computer:     return "laptopcomputer"
        case .user:         return "laptopcomputer"
        case .library:      return "person.crop.square"
        case .smart:        return "gearshape"
        case .normal:       return "square.on.square"
        }
    }

    var labelString: String {
        switch self {
        case .unknown:      return "Unknown"
        case .allFonts:     return "All Fonts"
        case .computer:     return "Computer"
        case .user:         return "User"
        case .library:      return "User"
        case .smart:        return "standardSmart"
        case .normal:       return "userDefined"
        }
    }

    var accentColor: Color {
        switch self {
        case .unknown:      return .gray
        case .allFonts:     return .accentColor
        case .computer:     return .accentColor
        case .user:         return .accentColor
        case .library:      return .accentColor
        case .smart:        return .primary
        case .normal:       return .cyan
        }
    }
    
    public func matchingFonts(_ font: Font) -> Bool {
        switch self {
        case .unknown:
            return false
        case .allFonts:
            return true
        case .computer:
            return false
        case .user:
            return font.url.path.starts(with: NSHomeDirectory())
        case let .library(libraryURL):
            return font.url.path.starts(with: libraryURL.path)
        case .smart:
            return false
        case .normal:
            return false
        }
    }

}

//enum FontCollectionType: Equatable {
//    case unknown
//    case allLibrary([URL: FontCollection])
//    case macOSLibrary([URL: FontCollection])
//    case library([URL: FontCollection])
//    case smart([FontCollection])
//    case normal([FontCollection])
//}

//enum FontCollectionType: Equatable {
//    case unknown
//    case allLibrary
//    case macOSLibrary
//    case library
//    case smart
//    case normal
//}


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

//enum FontCollectionType {
//    case unknown
//    case allFontLibrary         // builtin, contains all fonts from all over
//    case computerLibrary        // builtin, contains all fonts from system locations
//    case standardUserLibrary    // builtin, contains all fonts from current User's locations
//    case userDefinedLibrary            // user added, to contain fonts from a particular directory (or many)
//    case standardSmart          // a few build in ones, like english or fixed width ...
//    case userDefinedSmart
//    // plus, user can also add to this list
//    case userDefinedNormal            // a few build in ones, plus whatever the user wants
//    case standardNormal
//}
//
//
//extension FontCollectionType {
//    var imageSystemName: String {
//        switch self {
//
//        case .unknown:             return "questionmark"
//
//        case .allFontLibrary:      return "f.square"
//        case .computerLibrary:     return "laptopcomputer"
//        case .standardUserLibrary: return "person.crop.square"
//        case .userDefinedLibrary:  return "f.square"
//
//        case .standardSmart:       return "gearshape"
//        case .userDefinedSmart:     return "gearshape"
//
//        case .standardNormal:   return "square.on.square"
//        case .userDefinedNormal:   return "square.on.square"
//        }
//    }
//
//    var labelString: String {
//        switch self {
//
//        case .unknown:             return "unknown"
//
//        case .allFontLibrary:      return "All Fonts"
//        case .computerLibrary:     return "Computer"
//        case .standardUserLibrary: return "User"
//        case .userDefinedLibrary:  return "userLibrary"
//
//        case .standardSmart:       return "standardSmart"
//        case .userDefinedSmart:    return "standardSmart"
//
//        case .standardNormal:      return "userDefined"
//        case .userDefinedNormal:   return "userDefined"
//        }
//    }
//
//    var accentColor: Color {
//        switch self {
//
//        case .unknown:             return .gray
//        case .allFontLibrary:      return .accentColor
//        case .computerLibrary:     return .accentColor
//        case .standardUserLibrary: return .accentColor
//        case .userDefinedLibrary:  return .accentColor
//
//        case .standardSmart:       return .primary
//        case .userDefinedSmart:    return .primary
//
//        case .standardNormal:      return .cyan
//        case .userDefinedNormal:   return .cyan
//        }
//    }
//}


// TODO: jdeda
// Define more rules to CollectionType
// can it be renamed ?
// can it be removed ?
// can it be modified ?
// etc
