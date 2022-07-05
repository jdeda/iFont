//
//  ItemTypePreviewSelection+Extensions.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI

extension ItemPreviewType {
    func image(for selection: ItemPreviewType) -> Image {
        switch selection {
        case .sample:
            return Image(systemName: "text.aligncenter")

        case .repertoire:
            return Image(systemName: "square.grid.2x2")

        case .custom:
            return Image(systemName: "character.cursor.ibeam")

        case .info:
            return Image(systemName: "info.circle")
        }
    }
}
