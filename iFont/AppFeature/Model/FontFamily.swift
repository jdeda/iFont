//
//  FontFamily.swift
//  iFont
//
//  Created by Klajd Deda on 7/5/22.
//

import Foundation
import CoreText

struct FontFamily: Equatable, Hashable, Codable {
    let name: String
    var fonts: [Font]
}

extension FontFamily: Identifiable {
    var id: String {
        name
    }
}

extension FontFamily {
    var faces: [String: String] {
        var map = [String: String]()
        let foundFaces = fonts.map { font -> String in
            if(font.name.count == name.count) {
                map[font.name] = "Regular"
                return "Regular"
            }
            let fontName = font.name
            let offset = fontName.index(fontName.startIndex, offsetBy: name.count)
            let end = fontName.endIndex
            let face = String(fontName[offset..<end])
            let newFace = face.replacingOccurrences(of: "-", with: " ")
            
            // TODO: kdeda
            // Space between words
            // Replace Hyphens with spaces
            map[font.name] = newFace
            return newFace
        }
        return map
    }
    
    func fontsSorted(by sortFunc:(_ lhs: Font, _ rhs: Font) -> Bool) -> FontFamily {
        var newFamily = self
        
        newFamily.fonts = self.fonts.sorted(by: sortFunc)
        return newFamily
    }
    
    var fontsSortedByName: FontFamily {
        fontsSorted(by: { $0.name < $1.name })
    }
}
