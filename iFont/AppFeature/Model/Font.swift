//
//  Font.swift
//  iFont
//
//  Created by Klajd Deda on 7/5/22.
//

import AppKit
import CoreText

struct Font: Equatable, Hashable, Codable {
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

// TODO: jdeda
// This is extremely slow.
extension Array where Element == Font {
    func groupedByFamily() -> [FontFamily] {
        let foo = self
            .reduce(into: [String: [Font]]()) { partial, font in
                partial[font.familyName, default: []].append(font)
            }
            .map { FontFamily(name: $0.0, fonts: $0.1) }
            .sorted(by: { $0.name < $1.name })
        return foo
    }
}

// MARK: CTFontCreateWithName will default to TimesNewRoman if init fails.
extension Font {
    var fontStyle: String? {
        let ctFont = CTFontCreateWithName(self.name as CFString, 12.0, nil)
        guard (ctFont as NSFont).fontName == self.name
        else { return nil }
        return CTFontCopyName(ctFont, FontAttributeKey.style.key) as String?
    }
    
    var fontFullName: String? {
        let ctFont = CTFontCreateWithName(self.name as CFString, 12.0, nil)
        guard (ctFont as NSFont).fontName == self.name
        else { return nil }
        return CTFontCopyName(ctFont, FontAttributeKey.full.key) as String?
    }
}
extension Font {
    // For more look into
    // CTFont.h
    // CTFontDescriptor.h
    var fetchFontAttributes: [FontAttributeKey: String] {
        let ctFont = CTFontCreateWithName(self.name as CFString, 12.0, nil)
        // this does not fail because it will return a substitute font
        // ie: Helvetica
        // so make sure we get our guy here ...
        guard (ctFont as NSFont).fontName == self.name
        else {
            Logger.log("error: 'could not create the proper font: \(self.name)'")
            return [FontAttributeKey: String]()
        }
        
        // TODO: kdeda
        // extract as much as possible info from the NSFont
        return FontAttributeKey.allCases.reduce(into: [FontAttributeKey: String](), { partialResult, nextItem in
            if let value = CTFontCopyName(ctFont, nextItem.key) as String? {
                Logger.log("\(nextItem.title): \(value)")
                partialResult[nextItem] = value
            }
        })
    }
}
