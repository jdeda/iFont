//
//  SwiftUI+Extensions.swift
//  iFont
//
//  Created by Jesse Deda on 7/29/22.
//

import SwiftUI

extension SwiftUI.Font {
    init(font: Font, size: Double) {
//        let NSFont = NSFont.init(descriptor: font.descriptor, size: size)
//        CTFontDescriptor
//        let CTFont = NSFont as CTFont
        self.init(CTFont.init("" as CFString, size: CGFloat(size)))
        
//        // Gather descriptors.
//        let debug = true
//        guard let descriptors = CTFontManagerCreateFontDescriptorsFromURL(font.url as CFURL)  as? [CTFontDescriptor]
//        else {
//            self.init(CTFont.init("" as CFString, size: CGFloat(size)))
//            return
//        }
//
//        if debug {
//            Logger.log("Found \(descriptors.count) descriptors for \(font.url.absoluteString)")
//        }

//        let nsFonts = fontDescriptors
//            .compactMap { fontDescriptor -> NSFont? in
//                let nsFontDescriptor = fontDescriptor as NSFontDescriptor
//                let font = NSFont(descriptor: nsFontDescriptor, size: 12)
//
//                if ((nsFontDescriptor.object(forKey: .name) as? String) ?? "uknown").hasPrefix(".") { return nil }
//                if ((nsFontDescriptor.object(forKey: .family) as? String) ?? "uknown").hasPrefix(".") { return nil }
//
//                if debug {
//                    if let _ = font {
//                        let name = (nsFontDescriptor.object(forKey: .name) as? String) ?? "uknown"
//                        Logger.log("found: \(name)")
//                    }
//                    else {
//                        Logger.log("NOT found: \(url)")
//                    }
//                }
//                return font
    }
}
