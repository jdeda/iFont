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


extension View {
    
    func onDrop(
        if satisfied: Bool,
        for supportedType: String,
        perform action: @escaping (_ providers: [NSItemProvider]) -> Bool
    ) -> some View {
        if satisfied {
            let x = self.onDrop(of: supportedType, perform: action)
            return x
        }
        else {
            let x = self.onDrop(of: "", perform: { _ in false })
            return x
        }
    }
    func onDrop(
        of supportedType: String,
        isTargeted: Binding<Bool>? = nil,
        perform action: @escaping (_ providers: [NSItemProvider]) -> Bool
    ) -> some View {
        self.onDrop(of: [supportedType], isTargeted: isTargeted, perform: action)
    }
}
