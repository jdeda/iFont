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

struct FontFamily: Equatable, Hashable {
    let name: String
    var fonts: [Font]
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
            
            // TODO: Space between words
            // Replace Hyphens with spaces
            map[font.name] = newFace
            return newFace
        }
        return map
    }
}

struct Font: Equatable, Hashable {
    let name: String
    let familyName: String
    var copyright: String = ""
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
