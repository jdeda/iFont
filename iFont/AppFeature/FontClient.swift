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
import CoreText

struct FontClient {
    struct FetchFontsID: Hashable {}
    
    var fetchFonts: (_ directory: URL) -> Effect<[Font], Never>
//    var fetchAttribute: (_ fontURL: URL, _ attributeKey: FontAttributeKey) -> Effect<String, Never>
//    var fetchCTFont: (_ fontURL: URL) -> Effect<CTFont, Never>
//      var fetchCTFontDescriptor: (_ fontURL: URL) -> Effect<CTFontDescriptor, Never>
}

extension FontClient {
    public static let live = Self.init(
        fetchFonts: { directory in
            let effect = directory
                .lazyFontFilePublisher
                .filter(FontClientHelper.isFont)
                .map(FontClientHelper.makeFonts)
                .eraseToAnyPublisher()
                .eraseToEffect()
            return effect
        }
    )
}

struct FontClientHelper {
    static func isFont(_ url: URL) -> Bool {
        let debug = false
        let fileType = url.contentType?.identifier ?? "unknown"
        if debug {
            Logger.log("contentType: of \(url.path): \(fileType)")
        }
        return fileType.contains("font")
    }
    
    // Multiple font families can belong to a file.......
    // TODO: Ignore font files that start with ".".
    // TODO: Ignore "extra" families.
    static func makeFonts(_ url: URL) -> [Font] {
        // add -debug.makeFonts YES on the argument line to see more crap
//        let debug = UserDefaults.standard.bool(forKey: "debug.makeFonts")
        let debug = true
        guard let array = CTFontManagerCreateFontDescriptorsFromURL(url as CFURL)
        else { return [] }
        guard let fontDescriptors = array as? [CTFontDescriptor]
        else { return [] }
        
        if debug {
            Logger.log("Found \(fontDescriptors.count) descriptors for \(url.absoluteString)")
        }
        
        let nsFonts = fontDescriptors
            .compactMap { fontDescriptor -> NSFont? in
                let nsFontDescriptor = fontDescriptor as NSFontDescriptor
                let font = NSFont(descriptor: nsFontDescriptor, size: 12)
                
                if ((nsFontDescriptor.object(forKey: .name) as? String) ?? "uknown").hasPrefix(".") { return nil }
                if ((nsFontDescriptor.object(forKey: .family) as? String) ?? "uknown").hasPrefix(".") { return nil }
                
                if debug {
                    if let _ = font {
                        let name = (nsFontDescriptor.object(forKey: .name) as? String) ?? "uknown"
                        Logger.log("found: \(name)")
                    }
                    else {
                        Logger.log("NOT found: \(url)")
                    }
                }
                return font
            }
        
        // TODO: kdeda
        // Glyphs
        /**
         1. I have an ns font.
         2. I want all the glyphs associated with this font
         3. i want to draw one or some or all of the  glyphs given a character or characters
         */
        //        let glyphIds = 0...257
        //        let f = nsFonts[0]
        //        let g = f.gl
        //        NSGlyphInfo.init
        //        let glyphs = nsFonts.map { nsFont in
        //            let fontGlyphs = Array<Character>.alphabet.map { letter in
        //                nsFont.glyph(withName: String(letter))
        //
        //
        //            }
        //        }
        //        let glyphs = nsFonts[0]
        //        let f = nsFonts[0]
        //
        //        let g = f.glyph(withName: "A")
        
        let fonts = nsFonts
            .map { nsFont -> Font in
                Font(
                    descriptor: nsFont.fontDescriptor,
                    url: url,
                    name: nsFont.fontName,
                    familyName: nsFont.familyName ?? "None",
                    attributes: .init()
                )
            }
        
//        if debug {
//            Logger.log("found: \(fonts.count) fonts for: \(url.path)")
//            fonts.forEach {
//                Logger.log("here: \($0.name)")
//            }
//        }

        
        //        let manager = NSLayoutManager.init()
        //        let drawGlyphs = manager.drawGlyphs(forGlyphRange: NSRange.init(), at: NSPoint.init(x: 1, y: 1  ))
        //        let glpyh = NSGlyph.init("Cheese")
        
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
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            let debug = false
            if debug {
                Logger.log("\n\nThread: \(Thread.current) \n Starting ...")
                Logger.log("Creating enumerator at path: '\(self.path)'")
            }
            let enumerator = FileManager.default.enumerator(
                at: self,
                includingPropertiesForKeys: [.fileResourceTypeKey, .contentTypeKey, .nameKey],
                options: .skipsHiddenFiles,
                errorHandler: {
                    if debug {
                        print("DirectoryEnumerator error at \($0): ", $1)
                    }
                    return true
                }
            )!
            
            if debug {
                Logger.log("Finished Creating enumerator ...")
                Logger.log("Enumerating ...")
            }
            
            enumerator.forEach { element in
                guard let url = element as? URL else { return }
                passthrough.send(url)
//                Thread.sleep(forTimeInterval: 0.0125)
            }
            if debug {
                Logger.log("Completed Enumeration ...\n\n")
            }
//            Thread.sleep(forTimeInterval: 0.0125)
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
            //            Logger.log("Thread: \(Thread.current)")
            return eagerFontFilePublisher
        }
        .subscribe(on: DispatchQueue.global())
        .eraseToAnyPublisher()
    }
}
