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

struct Font: Equatable {
  var fontName: String
}
