//
//  UserDefaults+Extensions.swift
//  iFont
//
//  Created by Jesse Deda on 7/18/22.
//

import Foundation

extension UserDefaults {

    func getCodable<T: Codable>(forKey key: String) -> T? {
        if let data = self.object(forKey: key) as? Data {
            return try? JSONDecoder().decode(T.self, from: data)
        }
        else {
            return nil
        }
    }
    
    func setCodable<T: Codable>(forKey key: String, value: T) {
        if let encoded = try? JSONEncoder().encode(value) {
            self.set(encoded, forKey: key)
        }
    }
}
