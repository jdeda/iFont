//
//  ItemType.swift
//  iFont
//
//  Created by Klajd Deda on 7/21/22.
//

import Foundation

enum FontCollectionItem: Equatable, Hashable, Codable {
    case font(Font)
    case fontFamily(FontFamily)
}

extension FontCollectionItem: Identifiable {
    var id: String {
        switch self {
        case let .font(font): return font.id
        case let .fontFamily(fontFamily): return fontFamily.id
        }
    }
}

extension FontFamily {
    var itemType: FontCollectionItem {
        .fontFamily(self)
    }
}

extension Font {
    var itemType: FontCollectionItem {
        .font(self)
    }
}
