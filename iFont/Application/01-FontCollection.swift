import Foundation
import ComposableArchitecture
import AppKit

struct FontCollectionState: Identifiable, Equatable {
  let id = UUID()
  let name: String
  let systemImage: String
  let group: Group
  var fonts: [String] = ["0"]
  
  enum Group: String {
    case general
    case smart
    case collections
  }
}


enum FontCollectionAction: Equatable {
  case fetchFonts
  case fetchFontsResponse(Result<[String], AppError>)
}

struct FontCollectionEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
  var fonts: FontClient
  
  func fetchFonts(count: Int) -> Effect<[String], AppError> {
    Array
      .init(1...Int.random(in: 2...100))
      .map(\.description)
      .publisher
      .map { $0.map { String($0) } }
      .setFailureType(to: AppError.self)
      .eraseToEffect()
  }
}

let fontCollectionReducer = Reducer<
  FontCollectionState,
  FontCollectionAction,
  FontCollectionEnvironment
> { state, action, environment in
  switch action {
    
  case .fetchFonts:
    return environment.fetchFonts(count: Int.random(in: 0..<10))
      .receive(on: environment.mainQueue)
      .catchToEffect(FontCollectionAction.fetchFontsResponse)
  
  case let .fetchFontsResponse(.success(values)):
    state.fonts = values
    return .none
    
  case .fetchFontsResponse:
    return .none
    
  }
}
