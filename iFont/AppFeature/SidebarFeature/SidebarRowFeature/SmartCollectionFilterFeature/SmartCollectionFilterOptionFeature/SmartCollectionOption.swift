//
//  SmartCollectionOption.swift
//  iFont
//
//  Created by Jesse Deda on 8/5/22.
//

import Foundation

enum SmartCollectionFilterOption: Equatable, Hashable, Identifiable {
    var id: Self { self }

    case kind(FontKind?)
    case style(FontStyle?)
    case styleName(String?)
    case familyName(String?)
    case postscriptName(String?)

    enum FontKind: Equatable, Hashable, CaseIterable {
        case TrueType
        case OpenType
        case PostScript
    }

    enum FontStyle: Equatable, Hashable, CaseIterable {
        case regular
        case light
        case medium
        case italic
        case bold
        case black
        case condensed
    }

    enum StringFilter: Equatable, Hashable, CaseIterable {
        case isEqual
        case isNotEqual
        case beginsWith
        case endsWith
        case contains
    }
}
