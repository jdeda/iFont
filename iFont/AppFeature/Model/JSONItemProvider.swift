//
//  JSONItemProvider.swift
//  iFont
//
//  Created by Klajd Deda on 8/29/22.
//

import Foundation

final class JSONItemProvider: NSObject {
    var json: Data
    
    init(json: Data) {
        self.json = json
    }
}

extension JSONItemProvider: NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] = ["public.file-url"]

    /*
     Is this what is failling?
     */
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        .init(json: data)
    }
}

extension JSONItemProvider: NSItemProviderWriting {
    static var writableTypeIdentifiersForItemProvider: [String] = ["public.file-url"]

    
    /*
     Is this what is failling?
     */
    func loadData(
        withTypeIdentifier typeIdentifier: String,
        forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void
    ) -> Progress? {
        completionHandler(self.json, nil)
        let p = Progress(totalUnitCount: 1)
        p.completedUnitCount = 1
        return p
    }
}

// TODO: fix me
struct WrappedValue: Codable {
    var name: String

    init(_ name: String) {
        self.name = name
    }
}

extension FontCollectionItem {
    func jsonItemProvider() -> JSONItemProvider {
        switch self {
        case let .font(font):
            let value = WrappedValue(font.name)
            let data = try? JSONEncoder.init().encode(value)
            return JSONItemProvider(json: data ?? Data())
        case let .fontFamily(family):
            let value = WrappedValue(family.name)
            let data = try? JSONEncoder.init().encode(value)
            return JSONItemProvider(json: data ?? Data())
        }
    }
}
