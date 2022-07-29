//
//  SwiftUI+Extensions.swift
//  iFont
//
//  Created by Jesse Deda on 7/29/22.
//

import SwiftUI

extension SwiftUI.Font {
    init(font: Font, size: Double) {
        self.init(CTFontCreateWithName(font.name as CFString, size, nil))
    }
}
