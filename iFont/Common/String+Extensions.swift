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
