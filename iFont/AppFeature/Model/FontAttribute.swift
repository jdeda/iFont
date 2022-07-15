//
//  FontAttribute.swift
//  iFont
//
//  Created by Klajd Deda on 7/5/22.
//

import Foundation
import CoreText

enum FontAttributeKey: Equatable, CaseIterable {
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
    
    // TODO: jdeda
    // Please provide all strings here
    var title: String {
//        switch self {
//            // we don't have these easily
//            case .copyright:     return "PostScript name", fontAttribute: .postScript)
//            case .family:        return "Full name", fontAttribute: .full)
//            case .subfamily:     return "Family name", fontAttribute: .family)
//            case .style:         return "Style", fontAttribute: .style)
//            case .unique:        return "Kind", fontAttribute: .kind)
//            case .full:          return "Language", fontAttribute: .language)
//            case .version:       return "Script", fontAttribute: .script)
//            case .postScript:    return "Version", fontAttribute: .version)
//            case .trademark:     return "Location", fontAttribute: .location)
//            case .manufacturer:  return "Unique name", fontAttribute: .unique)
//            case .designer:      return "Designer", fontAttribute: .designer)
//            case .description:   return "Copyright", fontAttribute: .copyright)
//            case .vendorURL:     return "Trademark", fontAttribute: .trademark)
//            case .designerURL:   return "Enabled", fontAttribute: .enabled)
//            case .license:       return "Copy protected", fontAttribute: .copyright)
//            case .licenseURL:    return "Embedding", fontAttribute: .embedding)
//            case .sampleText:    return "Glyph count", fontAttribute: .glyphCount)
//            case .postScriptCID: return ""
//        }
        return key as String
    }
}
