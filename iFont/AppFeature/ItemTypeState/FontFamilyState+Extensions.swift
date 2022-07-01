//
//  Model+Extensions.swift
//  iFont
//
//  Created by Jesse Deda on 6/27/22.
//

import Foundation

extension Array where Element == Character {
    static var alphabet: [Character] {
        (97...122).map { Character(UnicodeScalar($0)) }
    }
    static var digits: [Character] {
        Array("123456789")
    }
}

extension String {
    static let alphabet = String(Array<Character>.alphabet)
    static let digits = String(Array<Character>.digits)
}

extension String {
    func splitInHalf() -> (left: String, right: String) {
        let start = self.startIndex
        let middle = self.index(self.startIndex, offsetBy: (self.count) / 2)
        let end = self.endIndex
        return (left: String(self[start..<middle]), right: String(self[middle..<end]))
    }
}
