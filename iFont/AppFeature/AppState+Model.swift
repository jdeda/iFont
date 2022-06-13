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
}
