//
//  DragAndDropItem.swift
//  iFont
//
//  Created by Jesse Deda on 8/24/22.
//

import Foundation
import CoreText
import AppKit

// We have reached a big problem. But we may be able to fix things.
// We could some intermediary-version of FontCollectionItem, Font, and FontFamily.
// We are simply getting destroyed by the NSFontDescriptor! FontDescriptors are NOT
// codable. How could we extract it? We could simply use the URL and pluck the font wiith the matching
// name from the arrray of font descriptors we get from the file.

struct FontCodable: Codable {
    var url: URL
    var name: String
    
    init(_ font: Font) {
        self.url = font.url
        self.name = font.name
    }
}

struct FontFamilyCodable: Codable {
    let name: String
    var fonts: [FontCodable]
    
    init(_ family: FontFamily) {
        self.name = family.name
        self.fonts = family.fonts.map(FontCodable.init)
    }
}

enum FontCollectionItemCodable: Codable {
    case font(FontCodable)
    case fontFamily(FontFamilyCodable)
}

final class FontCollectionItemDnD: NSObject {
    public static let typeIdentifier = "dnd.fontCollectionItem"
    let item: FontCollectionItemCodable

    internal init(_ item: FontCollectionItemCodable) {
        self.item = item
    }
}

extension FontCollectionItemDnD: NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] = [typeIdentifier]

    /*
     Is this what is failling?
     */
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        .init(try! JSONDecoder().decode(FontCollectionItemCodable.self, from: data))
    }
}

extension FontCollectionItemDnD: NSItemProviderWriting {
    static var writableTypeIdentifiersForItemProvider: [String] = [typeIdentifier]

    
    /*
     Is this what is failling?
     */
    func loadData(
        withTypeIdentifier typeIdentifier: String,
        forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void
    ) -> Progress? {
        let data = try! JSONEncoder.init().encode(self.item)
        completionHandler(data, nil)
        let p = Progress(totalUnitCount: 1)
        p.completedUnitCount = 1
        return p
    }
}

extension FontCollectionItem {
    func yummers() -> FontCollectionItemDnD {
        switch self {
        case let .font(font):
            return .init(.font(.init(font)))
        case let .fontFamily(family):
            return .init(.fontFamily(.init(family)))
        }
    }
}

func unyummers(_ itemDnD: FontCollectionItemDnD) -> FontCollectionItem {
    switch itemDnD.item {
        
    case let .font(fontCodable):
        return .font(fontCodableToFont(fontCodable))
            
    case let .fontFamily(familyCodable):
        return .fontFamily(.init(name: familyCodable.name, fonts: familyCodable.fonts.map(fontCodableToFont)))
    }
}

func fontCodableToFont(_ fontCodable: FontCodable) -> Font {
    let array = CTFontManagerCreateFontDescriptorsFromURL(fontCodable.url as CFURL)!
    let fontDescriptors = array as! [CTFontDescriptor]
    let fonts = fontDescriptors.compactMap { NSFont(descriptor: $0 as NSFontDescriptor, size: 12) }
    let font = (fonts.first { $0.fontName == fontCodable.name })!
    return .init(
        descriptor: font.fontDescriptor,
        url: fontCodable.url,
        name: fontCodable.name,
        familyName: font.familyName ?? "unknown"
    )
}


// MARK: - GenericDrag and Drop Item.

final class DragAndDropItem<T: Codable>: NSObject {
    let typeIdentifier = "drag_and_drop_item" // is this the problem?
    let item: T
    
    var readableTypeIdentifiersForItemProvider: [String] { [typeIdentifier] }
    var writableTypeIdentifiersForItemProvider: [String] { [typeIdentifier] }

    internal init(_ item: T) {
        self.item = item
    }
    
    func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        .init(try! JSONDecoder().decode(T.self, from: data))
    }

    
    func loadData(
        withTypeIdentifier typeIdentifier: String,
        forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void
    ) -> Progress? {
        let data = try! JSONEncoder.init().encode(self.item)
        completionHandler(data, nil)
        let p = Progress(totalUnitCount: 1)
        p.completedUnitCount = 1
        return p
    }
}
