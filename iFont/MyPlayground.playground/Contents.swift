import Foundation
import Combine

// Could create a passthrough publisher.
// FileManager.enumerator...searches and digs file
// Make publisher there?
//

struct AppError: Equatable, Error {
  private(set) var localizedDescription: String
  init(_ error: Error) { self.localizedDescription = error.localizedDescription }
  init(_ rawValue: String) { self.localizedDescription = rawValue }
}

let urlPublisher: PassthroughSubject<URL, Never> = {
  let passthrough: PassthroughSubject<URL, Never> = PassthroughSubject()

  DispatchQueue.global().async {
    let manager = FileManager.default
    let directory = URL(fileURLWithPath: "/System/Library/Fonts", isDirectory: true)
    let keys: [URLResourceKey] = [.fileResourceTypeKey, .nameKey]
    let options = FileManager.DirectoryEnumerationOptions.skipsHiddenFiles
    let handler: (URL, Error) -> Bool = { url, error in
      print("DirectoryEnumerator error at \(url): ", error)
      return true
    }
    let enumerator = manager.enumerator(
      at: directory,
      includingPropertiesForKeys: keys,
      options: options,
      errorHandler: handler
    )!
    for case let url as URL  in enumerator {
      passthrough.send(url)
      // print(url)
    }
    passthrough.send(completion: .finished)
  }
  return passthrough
}()

NSLog("Starting")
let cancellable = urlPublisher
  .sink { url in
    NSLog(url.path)
  }

Thread.sleep(forTimeInterval: 60*60)
