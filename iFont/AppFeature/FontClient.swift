//
//  FontClient.swift
//  iFont
//
//  Created by Jesse Deda on 6/2/22.
//

import Foundation
import UniformTypeIdentifiers
import ComposableArchitecture
import Cocoa
import Combine

struct FontClient {
  struct FetchFontsID: Hashable {}
  var fetchFonts: (_ directory: URL) -> Effect<[Font], Never>
}

extension FontClient {
  public static let live = Self.init(
    fetchFonts: { directory in
      let foo = directory
        .fontFilePublisherV2
        // .filter(isFont)
        .map { url -> URL in
          let fileType = url.contentType?.identifier ?? "unknown"
          
          // NSLog("path: \(url.path)")
          NSLog("contentType: \(fileType)")
          return url
        }
        .compactMap(FontClientHelper.makeFonts)
        .map { fonts -> [Font] in
          NSLog("font: \(fonts.count)")
          return fonts.map { nsFont in
            Font(fontName: nsFont.fontName)
          }
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
      
      return foo
    }
  )
}

struct FontClientHelper {
  func isFont(_ url: URL) -> Bool {
    let fileType = url.contentType?.identifier ?? "unknown"
    
    // NSLog("path: \(url.path)")
    NSLog("contentType: \(fileType)")
    return fileType.contains("font")
  }
  
  static func makeFonts(_ url: URL) -> [NSFont] {
    // NSFont(name: $0, size: 25.0)
    guard let array = CTFontManagerCreateFontDescriptorsFromURL(url as CFURL)
    else { return [] }
    guard let fontDescriptors = array as? [CTFontDescriptor]
    else { return [] }
    // return CTFontCreateWithFontDescriptor(fd[0], 20.0, nil)
    
    let foo = fontDescriptors.compactMap { fontDescriptor in
      NSFont.init(descriptor: fontDescriptor, size: 12)
    }
    NSLog("found: \(foo.count) fonts for: \(url.path)")
    return foo
  }
}

extension URL {
  public var contentType: UTType? {
    let foo = (try? self.resourceValues(forKeys: [.contentTypeKey]))?
      .contentType
    return foo
  }
  
  // This is an overly eager publisher,
  // ie: it could start work even we before we .sink
  private var eagerFontFilePublisher: PassthroughSubject<URL, Never> {
    let passthrough: PassthroughSubject<URL, Never> = PassthroughSubject()
    
    DispatchQueue.global().async {
      // start the work later, but it could happen not later enough
      NSLog("Thread: \(Thread.current)")
      NSLog("Starting ...")
      
      let manager = FileManager.default
      let keys: [URLResourceKey] = [.fileResourceTypeKey, .contentTypeKey, .nameKey]
      let options = FileManager.DirectoryEnumerationOptions.skipsHiddenFiles
      let handler: (URL, Error) -> Bool = { url, error in
        print("DirectoryEnumerator error at \(url): ", error)
        return true
      }
      let enumerator = manager.enumerator(
        at: self,
        includingPropertiesForKeys: keys,
        options: options,
        errorHandler: handler
      )!
      
      NSLog("Iterating ...")
      enumerator.forEach { something in
        guard let url = something as? URL
        else { return }
        passthrough.send(url)
      }
      //      for case let url as URL  in enumerator {
      //        passthrough.send(url)
      //        // print(url)
      //      }
      NSLog("Completed ...")
      passthrough.send(completion: .finished)
    }
    
    return passthrough
  }
  
  var fontFilePublisher: AnyPublisher<URL, Never> {
    eagerFontFilePublisher.eraseToAnyPublisher()
  }
  
  // this will start the work when the downstream calls .sink
  var fontFilePublisherV2: AnyPublisher<URL, Never> {
    let foo = Deferred { () -> PassthroughSubject<URL, Never> in
      NSLog("Thread: \(Thread.current)")
      return eagerFontFilePublisher
    }
      .subscribe(on: DispatchQueue.global())
      .eraseToAnyPublisher()
    
    return foo
  }
}

