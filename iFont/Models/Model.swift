//
//  Model.swift
//  iFont
//
//  Created by Klajd Deda on 6/16/22.
//

import Foundation

struct AppError: Equatable, Error {
    var localizedDescription: String
    
    init(_ error: Error) {
        self.localizedDescription = error.localizedDescription
    }
    
    init(_ rawValue: String) {
        self.localizedDescription = rawValue
    }
}

// TODO: kdeda
// The name on this is strange
// We ought to come up with better names
enum ItemType: Equatable, Hashable, Codable {
    case font(Font)
    case fontFamily(FontFamily)
}

extension ItemType: Identifiable {
    var id: String {
        switch self {
        case let .font(font): return font.id
        case let .fontFamily(fontFamily): return fontFamily.id
        }
    }
}

extension FontFamily {
    var itemType: ItemType {
        .fontFamily(self)
    }
}

extension Font {
    var itemType: ItemType {
        .font(self)
    }
}
