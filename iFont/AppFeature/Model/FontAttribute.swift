//
//  FontAttribute.swift
//  iFont
//
//  Created by Klajd Deda on 7/5/22.
//

import Foundation

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

