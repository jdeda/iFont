//
//  FontAttribute.swift
//  iFont
//
//  Created by Klajd Deda on 7/5/22.
//

import Foundation
import CoreText

enum FontAttributeKey: Equatable, CaseIterable, Codable {
    case copyright
    case family
    case subfamily
    case style
    case unique
    case full
    case version
    case postScript
    case trademark
    case manufacturer
    case designer
    case description
    case vendorURL
    case designerURL
    case license
    case licenseURL
    case sampleText
    case postScriptCID
}

extension FontAttributeKey: Identifiable {
    var id: Self {
        self
    }
}

extension FontAttributeKey: Hashable {}

extension FontAttributeKey {
    var key: CFString {
        switch self {
        case .copyright:     return kCTFontCopyrightNameKey
        case .family:        return kCTFontFamilyNameKey
        case .subfamily:     return kCTFontSubFamilyNameKey
        case .style:         return kCTFontStyleNameKey
        case .unique:        return kCTFontUniqueNameKey
        case .full:          return kCTFontFullNameKey
        case .version:       return kCTFontVersionNameKey
        case .postScript:    return kCTFontPostScriptNameKey
        case .trademark:     return kCTFontTrademarkNameKey
        case .manufacturer:  return kCTFontManufacturerNameKey
        case .designer:      return kCTFontDesignerNameKey
        case .description:   return kCTFontDescriptionNameKey
        case .vendorURL:     return kCTFontVendorURLNameKey
        case .designerURL:   return kCTFontDesignerURLNameKey
        case .license:       return kCTFontLicenseNameKey
        case .licenseURL:    return kCTFontLicenseURLNameKey
        case .sampleText:    return kCTFontSampleTextNameKey
        case .postScriptCID: return kCTFontPostScriptCIDNameKey
        }
    }
    
    // TODO: jdeda - done
    // Please provide all strings here
    var title: String {
        switch self {             // we don't have these easily
            case .copyright:     return "Copyright"
            case .family:        return "Family name"
            case .subfamily:     return "Sub Familly name"
            case .style:         return "Style"
            case .unique:        return "Unique"
            case .full:          return "Full Name"
            case .version:       return "Version"
            case .postScript:    return "PostScript name"
            case .trademark:     return "Trademark"
            case .manufacturer:  return "Manufacturer"
            case .designer:      return "Designer"
            case .description:   return "Description"
            case .vendorURL:     return "Vender URL"
            case .designerURL:   return "Designer URL"
            case .license:       return "License"
            case .licenseURL:    return "License URL"
            case .sampleText:    return "Sample text"
            case .postScriptCID: return ""
        }
    }
}
