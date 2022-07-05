//
//  FontCollection.swift
//  iFont
//
//  Created by Klajd Deda on 7/5/22.
//

import Foundation

/// Model a collection or grouping of Fonts
/// Where do these fonts come from ?
/// They can be created empty and the user can add/remove fonts from it
/// They canbe created on application start up, for example the Computer Collection
struct FontCollection: Equatable {
    var fonts = [Font]()
    /// derived
    var fontFamilies = [FontFamily]()
}

extension FontCollection {
    // The sum of computerColletion and userCollection
    static var allFonts: Self {
        FontCollection(fonts: [Font]())
    }
    
    // All the fonts installed in the computer
    // /System/Library/Fonts
    // /Library/Fonts
    static var computerColletion: Self {
        FontCollection(fonts: [Font]())
    }
    
    // All the fonts installed in this user
    // /Users/kdeda/Library/Fonts
    static var userCollection: Self {
        FontCollection(fonts: [Font]())
    }
}
