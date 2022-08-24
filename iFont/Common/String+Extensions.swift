//
//  String+Extensions.swift
//
//  Created by Klajd Deda on 7/17/20.
//  Copyright © 2020 id-design. All rights reserved.
//

import Foundation

public extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard !prefix.isEmpty
        else { return self }
        guard self.hasPrefix(prefix)
        else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func date(withDateFormat dateFormat: String) -> Date {
        let formatter = DateFormatter()
        
        formatter.calendar = Calendar.autoupdatingCurrent
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = dateFormat
        
        return formatter.date(from: self) ?? Date.distantPast
    }
    
    func paddingStart(_ length: Int, with string: String = " ") -> String {
        guard count < length else { return self }
        
        let padLength = length - count
        if padLength < string.count {
            return string[string.startIndex..<string.index(string.startIndex, offsetBy: padLength)] + self
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return padding[padding.startIndex..<padding.index(padding.startIndex, offsetBy: padLength)] + self
        }
    }
    
    func paddingEnd(_ length: Int, with string: String = " ") -> String {
        guard count < length else { return self }
        
        let padLength = length - count
        if padLength < string.count {
            return self + string[string.startIndex..<string.index(string.startIndex, offsetBy: padLength)]
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return self + padding[padding.startIndex..<padding.index(padding.startIndex, offsetBy: padLength)]
        }
    }
}

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


extension String {
    func accumulatingStrings() -> [String] {
        var accumulated: [String] = []
        for i in 0..<self.count {
            let A = self.startIndex
            let B = self.index(self.startIndex, offsetBy: i)
            accumulated.append(String(self[A...B]))
        }
        return accumulated
    }
}
