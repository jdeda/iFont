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
struct FontFamily: Equatable {
    var name: String
    var fonts: [Font]
}

struct Font: Equatable {
    var name: String
    var familyName: String
}

extension Array where Element == Font {
    func groupByFamily() -> [FontFamily] {
        let all = self.reduce(into: [String: FontFamily]()) { partialResult, font in
            var family = partialResult[font.familyName, default: FontFamily(name: font.familyName, fonts: [])]
            family.fonts.append(font)
        }
        
        return all.reduce(into: [FontFamily]()) { partialResult, fontFamily in
            partialResult.append(fontFamily.value)
        }
    }
}
