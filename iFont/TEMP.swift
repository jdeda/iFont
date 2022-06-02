//import AppKit
//import Combine
//import Foundation
//
//func foobar() throws {
//  // Version A. Yields 72 -> 69 -> 28.
//  let pathA = URL(fileURLWithPath: "/System/Library/Fonts", isDirectory: true).path
//  let fontsA = try FileManager.default.contentsOfDirectory(atPath: pathA)
//    .filter { $0.hasSuffix(".ttf") || $0.hasSuffix(".ttc") || $0.hasSuffix(".otf") }
//    .map { String($0[$0.startIndex..<$0.index($0.endIndex, offsetBy: -4)])}
//    .compactMap { NSFont(name: $0, size: 25.0) }
//  fontsA.forEach { print($0.fontName) }
//  print("\n\n\n\n\n")
//
//  // Version B.
//  let fileManager = FileManager.default
//  let fontsURL = URL(fileURLWithPath: "/System/Library/Fonts", isDirectory: true)
//  let fonts = try fileManager.contentsOfDirectory(atPath: fontsURL.path)
//    .filter { content in
//      content.hasSuffix(".ttf") ||
//      content.hasSuffix(".ttc") ||
//      content.hasSuffix(".otf")
//    }
//    .map { fileName -> URL in
//      var urlStr = fontsURL.path
//      urlStr.append(contentsOf: fileName)
//      return URL(fileURLWithPath: urlStr)
//    }
//    .compactMap { url -> CTFont? in
//      guard let array = CTFontManagerCreateFontDescriptorsFromURL(url as CFURL)
//      else { return nil }
//      guard let fd = array as? [CTFontDescriptor]
//      else { return nil }
//      return CTFontCreateWithFontDescriptor(fd[0], 20.0, nil)
//    }
//  fonts.count
//}
