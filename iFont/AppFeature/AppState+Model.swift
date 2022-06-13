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

// TODO: Make immutable.
struct FontFamily: Equatable, Hashable {
    var name: String
    var fonts: [Font]
}

struct Font: Equatable, Hashable {
    var name: String
    var familyName: String
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
