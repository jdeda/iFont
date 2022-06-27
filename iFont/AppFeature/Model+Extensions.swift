import Foundation
import AppKit
import CoreText

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
            
            // TODO: Space between words
            // Replace Hyphens with spaces
            map[font.name] = newFace
            return newFace
        }
        return map
    }
}

extension Array where Element == Font {
    func groupedByFamily() -> [FontFamily] {
        self
            .reduce(into: [String: FontFamily]()) { partial, font in
                var family = partial[font.familyName, default: FontFamily(name: font.familyName, fonts: [])]
                
                family.fonts.append(font)
                partial[font.familyName] = family
            }
            .reduce(into: [FontFamily]()) { partial, fontFamily in
                partial.append(fontFamily.value)
            }
    }
}

extension Font {
    var fontAttributes: [String: String] {
        let ctFont = CTFontCreateWithName(self.name as CFString, 12.0, nil)
        // this does not fail because it will return a substitute font
        // ie: Helvetica
        // so make sure we get our guy here ...
        guard (ctFont as NSFont).fontName == self.name
        else {
            Logger.log("error: 'could not create the proper font: \(self.name)'")
            return [String: String]()
        }
        
        // TODO: kdeda
        // extract as much as possible info from the NSFont
        return FontAttribute.allCases.reduce(into: [String: String](), { partialResult, nextItem in
            let index = nextItem.rawValue.index(nextItem.rawValue.startIndex, offsetBy: 1)
            let key = String(nextItem.rawValue.suffix(from: index)).replacingOccurrences(of: "Key", with: "")
            
            if let value = CTFontCopyName(ctFont, key as CFString) as String? {
                Logger.log("\(key): \(value)")
                partialResult[key] = value
            }
        })
    }
}