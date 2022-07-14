//
//  Font.swift
//  iFont
//
//  Created by Klajd Deda on 7/5/22.
//

import AppKit
import CoreText

struct Font: Equatable, Hashable {
    var url: URL
    var name: String
    var familyName: String
    var attributes: [FontAttributeKey: String] = [:]
}

extension Font: Identifiable {
    var id: String {
        name
    }
}

extension Array where Element == Font {
    func groupedByFamily() -> [FontFamily] {
        let foo = self
            .reduce(into: [String: [Font]]()) { partial, font in
                partial[font.familyName, default: []].append(font)
            }
            .map { FontFamily.init(name: $0.0, fonts: $0.1) }
        return foo
    }
}

//extension Font {
//    var fontAttributes: [String: String] {
//        let ctFont = CTFontCreateWithName(self.name as CFString, 12.0, nil)
//        // this does not fail because it will return a substitute font
//        // ie: Helvetica
//        // so make sure we get our guy here ...
//        guard (ctFont as NSFont).fontName == self.name
//        else {
//            Logger.log("error: 'could not create the proper font: \(self.name)'")
//            return [String: String]()
//        }
//
//        // TODO: kdeda
//        // extract as much as possible info from the NSFont
//        return FontAttribute.allCases.reduce(into: [String: String](), { partialResult, nextItem in
//            if let value = CTFontCopyName(ctFont, nextItem.nameKey) as String? {
//                Logger.log("\(nextItem.nameKey): \(value)")
//                partialResult[nextItem.nameKeyString] = value
//            }
//        })
//    }
//}
