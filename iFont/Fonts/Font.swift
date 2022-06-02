//import Foundation
//import ComposableArchitecture
//import AppKit.NSFont
//
//struct FontClient {
//  struct FetchFontsID: Hashable {}
//  var fetchFonts: () -> Effect<[NSFont], AppError>
//}
//
///**
// A lot is wrong with this...
// 1. you did not read read a file using a url
// 2. you did not publish changes as you read them
// */
//extension FontClient {
//  static let mock = FontClient.init(fetchFonts: {
//    let directory = URL(fileURLWithPath: "/System/Library/Fonts", isDirectory: true)
//    let x = FileManager.default.contentsOfDirectory(atPath: directory.path)
//    
//      .filter {
//        $0.hasSuffix(".ttf") ||
//        $0.hasSuffix(".ttc") ||
//        $0.hasSuffix(".otf")
//      }
//      .map {
//        let start = $0.startIndex
//        let end = $0.index($0.endIndex, offsetBy: -4)
//        return String($0[start..<end])
//      }
//      .compactMap {
//        NSFont(name: $0, size: 25.0)
//      }
//      .publisher
//      .eraseToEffect()
//      .cancellable(id: FetchFontsID(), cancelInFlight: true)
//    return x
//  })
//}
