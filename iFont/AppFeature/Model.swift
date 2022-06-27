//
//  Model.swift
//  iFont
//
//  Created by Klajd Deda on 6/16/22.
//

import Foundation

struct AppError: Equatable, Error {
    var localizedDescription: String
    
    init(_ error: Error) {
        self.localizedDescription = error.localizedDescription
    }
    
    init(_ rawValue: String) {
        self.localizedDescription = rawValue
    }
}

enum FontAttribute: String, CaseIterable {
    case copyright = "kCTFontCopyrightNameKey"
    case family = "kCTFontFamilyNameKey"
    case subfamily = "kCTFontSubFamilyNameKey"
    case style = "kCTFontStyleNameKey"
    case unique = "kCTFontUniqueNameKey"
    case full = "kCTFontFullNameKey"
    case version = "kCTFontVersionNameKey"
    case postScript = "kCTFontPostScriptNameKey"
    case trademark = "kCTFontTrademarkNameKey"
    case manufacturer = "kCTFontManufacturerNameKey"
    case designer = "kCTFontDesignerNameKey"
    case description = "kCTFontDescriptionNameKey"
    case vendorURL = "kCTFontVendorURLNameKey"
    case designerURL = "kCTFontDesignerURLNameKey"
    case license = "kCTFontLicenseNameKey"
    case licenseURL = "kCTFontLicenseURLNameKey"
    case sampleText = "kCTFontSampleTextNameKey"
    case postScriptCID = "kCTFontPostScriptCIDNameKey"
}

struct Font: Equatable, Hashable {
    var name: String
    var familyName: String
    var attributes = [FontAttribute: String]()
}

struct FontFamily: Equatable, Hashable {
    let name: String
    var fonts: [Font]
}

enum SelectedItem: Equatable, Hashable {
    case font(Font)
    case fontFamily(FontFamily)
}

extension Font {
    var selectedItem: SelectedItem {
        .font(self)
    }
}

extension FontFamily {
    var selectedItem: SelectedItem {
        .fontFamily(self)
    }
}
