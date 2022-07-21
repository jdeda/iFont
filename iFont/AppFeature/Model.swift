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
