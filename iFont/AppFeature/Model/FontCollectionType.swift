//
//  FontCollectionType.swift
//  iFont
//
//  Created by Klajd Deda on 7/8/22.
//

import Foundation

//enum FontCollectionType {
//    case allFontLibrary([(URL)])
//    case computerLibrary(URL: .init(fileURLWithPath: "/System/Library/Fonts"))
//    case standardUserLibrary(URL : .init(fileURLWithPath: "/USER/Library/Fonts"))
//}

enum FontCollectionType {
    case unknown
    case allFontLibrary         // builtin, contains all fonts from all over
    case computerLibrary        // builtin, contains all fonts from system locations
    case standardUserLibrary    // builtin, contains all fonts from current User's locations
    case userLibrary            // user added, to contain fonts from a particular directory (or many)
    case standardSmart          // a few build in ones, like english or fixed width ...
                                // plus, user can also add to this list
    case userDefined            // a few build in ones, plus whatever the user wants
}


extension FontCollectionType {
    var imageSystemName: String {
        switch self {
            
        case .unknown:             return "f.square"
        case .allFontLibrary:      return "f.square"
        case .computerLibrary:     return "laptopcomputer"
        case .standardUserLibrary: return "person.crop.square"
        case .userLibrary:         return "f.square"
        case .standardSmart:       return "f.square"
        case .userDefined:         return "f.square"
        }
    }
    
    var labelString: String {
        switch self {
            
        case .unknown:             return "unknown"
        case .allFontLibrary:      return "All Fonts"
        case .computerLibrary:     return "Computer"
        case .standardUserLibrary: return "User"
        case .userLibrary:         return "userLibrary"
        case .standardSmart:       return "standardSmart"
        case .userDefined:         return "userDefined"
        }
    }
}


// TODO: jdeda
// Define more rules to CollectionType
// can it be renamed ?
// can it be removed ?
// can it be modified ?
// etc
