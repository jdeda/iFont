//
//  FontClient.swift
//  iFont
//
//  Created by Jesse Deda on 6/2/22.
//

import ComposableArchitecture
import Combine
import Cocoa
import UniformTypeIdentifiers

struct FontClient {
  struct FetchFontsID: Hashable {}
  var fetchFonts: (_ directory: URL) -> Effect<[Font], Never>
}

extension FontClient {
  public static let live = Self.init(
    fetchFonts: { directory in
      let effect = directory
        .lazyFontFilePublisher
        .filter(FontClientHelper.isFont)
        .compactMap(FontClientHelper.makeFonts)
        .map { fonts -> [Font] in
          NSLog("font: \(fonts.count)")
          return fonts.map { Font(fontName: $0.fontName) }
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
      return effect
    }
  )
}

struct FontClientHelper {
  static func isFont(_ url: URL) -> Bool {
    let fileType = url.contentType?.identifier ?? "unknown"
    NSLog("contentType: of \(url.path): \(fileType)")
    return fileType.contains("font")
  }
  
  static func makeFonts(_ url: URL) -> [NSFont] {
    guard let array = CTFontManagerCreateFontDescriptorsFromURL(url as CFURL)
    else { return [] }
    guard let fontDescriptors = array as? [CTFontDescriptor]
    else { return [] }
    let fonts = fontDescriptors.compactMap { NSFont.init(descriptor: $0, size: 12) }
    NSLog("found: \(fonts.count) fonts for: \(url.path)")
    return fonts
  }
}

extension URL {
  public var contentType: UTType? {
    (try? self.resourceValues(forKeys: [.contentTypeKey]))?.contentType
  }
  
  // This is an eager publisher, i.e. could start working before .sink.
  private var eagerFontFilePublisher: PassthroughSubject<URL, Never> {
    let passthrough: PassthroughSubject<URL, Never> = PassthroughSubject()
    
    // Start work later, but it could happen too soon.
    DispatchQueue.global().async {
      NSLog("\n\nThread: \(Thread.current) \n Starting ...")
      
      NSLog("Creating enumerator ...")
      let enumerator = FileManager.default.enumerator(
        at: self,
        includingPropertiesForKeys: [.fileResourceTypeKey, .contentTypeKey, .nameKey],
        options: .skipsHiddenFiles,
        errorHandler: {
          print("DirectoryEnumerator error at \($0): ", $1)
          return true
        }
      )!
      NSLog("Finished Creating enumerator ...")
      
      
      NSLog("Enumerating ...")
      enumerator.forEach { element in
        guard let url = element as? URL else { return }
        passthrough.send(url)
      }
      NSLog("Completed Enumeration ...\n\n")
      passthrough.send(completion: .finished)
    }
    
    return passthrough
  }
  
  var fontFilePublisher: AnyPublisher<URL, Never> {
    eagerFontFilePublisher.eraseToAnyPublisher()
  }
  
  // This will start the work when downstream calls .sink.
  var lazyFontFilePublisher: AnyPublisher<URL, Never> {
    Deferred { () -> PassthroughSubject<URL, Never> in
      NSLog("Thread: \(Thread.current)")
      return eagerFontFilePublisher
    }
    .subscribe(on: DispatchQueue.global())
    .eraseToAnyPublisher()
  }
}

