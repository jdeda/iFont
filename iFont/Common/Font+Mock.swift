//
//  Font+Mock.swift
//  iFont
//
//  Created by Jesse Deda on 7/26/22.
//

import Foundation

let mock_font_attributes: [FontAttributeKey: String] =  {
    var ats = Dictionary(
        uniqueKeysWithValues: zip(
            FontAttributeKey.allCases,
            String.alphabet.accumulatingStrings()
        )
    )
    ats[.copyright] = String.alphabet + String.alphabet + String.alphabet + String.alphabet
    return ats
}()

let mock_fonts = (1...10).map { int in
    Font(
        url: URL(fileURLWithPath: NSTemporaryDirectory()),
        name: "Chicken \(int)",
        familyName: "Cheese",
        attributes: mock_font_attributes
    )
}
