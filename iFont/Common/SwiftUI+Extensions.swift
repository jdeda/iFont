//
//  SwiftUI+Extensions.swift
//  iFont
//
//  Created by Jesse Deda on 7/29/22.
//

import SwiftUI

extension SwiftUI.Font {
    init(font: Font, size: Double) {
        let ctFontDescriptor = font.descriptor as CTFontDescriptor
        let ctFont = CTFontCreateWithFontDescriptor(ctFontDescriptor, size, nil)
        self.init(ctFont)
    }
}
