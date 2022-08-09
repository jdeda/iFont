//
//  SmartCollectionOption.swift
//  iFont
//
//  Created by Jesse Deda on 8/5/22.
//

import Foundation

//[.isEqual, .isNotEqual, .beginsWith, .endsWith, .contains]


enum SmartCollectionFilterOption: Equatable, Hashable, Identifiable {
    var id: Self { self }

    case kind(FontKind?)
    case style(FontStyle?)
//    case styleName(String?, Set<Self.StringFilter>?) // [.isEqual, .isNotEqual, .beginsWith, .endsWith, .contains]
    case styleName(String?) // [.isEqual, .isNotEqual, .beginsWith, .endsWith, .contains]
    case familyName(String?) // [.isEqual, .isNotEqual, .beginsWith, .endsWith, .contains]
    case postscriptName(String?) // [.isEqual, .isNotEqual, .beginsWith, .endsWith, .contains]

    enum FontKind: Equatable, Hashable, CaseIterable {
        case TrueType
        case OpenType
        case PostScript

        var string: String {
            switch self {
            case .TrueType:
                return "TrueType"
            case .OpenType:
                return "OpenType"
            case .PostScript:
                return "PostScript"

            }
        }
    }

    enum FontStyle: Equatable, Hashable, CaseIterable {
        case regular
        case light
        case medium
        case italic
        case bold
        case black
        case condensed
        
        var string: String {
            switch self {

            case .regular:
                return "Regular"
            case .light:
                return "Light"
            case .medium:
                return "Medium"
            case .italic:
                return "Italic"
            case .bold:
                return "Bold"
            case .black:
                return "Black"
            case .condensed:
                return "Condensed"
            }
        }
    }

    enum StringFilter: Equatable, Hashable, CaseIterable {
        case isEqual
        case isNotEqual
        case beginsWith
        case endsWith
        case contains
        
        var string: String {
            switch self {
            case .isEqual:
                return "is"
            case .isNotEqual:
                return "is not"
            case .beginsWith:
                return "begins with"
            case .endsWith:
                return "ends with"
            case .contains:
                return "contains"
            }
        }
    }
}
