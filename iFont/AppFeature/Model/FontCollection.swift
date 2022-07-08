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
    let id = UUID()
    var type: FontCollectionType = .unknown
    var fonts = [Font]()
    /// derived
    public private(set) var fontFamilies = [FontFamily]()
    
    init(
        type: FontCollectionType = .unknown,
        fonts: [Font] = [Font](),
        fontFamilies: [FontFamily] = [FontFamily]()
    ) {
        self.type = type
        self.fonts = fonts
        self.fontFamilies = fontFamilies
    }
    
}

extension FontCollection: Identifiable {}

extension FontCollection {
    // We will append any font found into here
    static var allFonts: Self = FontCollection(
        type: .allFontLibrary,
        fonts: [Font]()
    )
    
    // We will append any font found on the following locations
    // /System/Library/Fonts
    // /Library/Fonts
    static var computerColletion: Self = FontCollection.init(type: .computerLibrary, fonts: [Font]())
    
    // We will append any font found on the following locations
    // /Users/kdeda/Library/Fonts
    static var userCollection: Self = {
        FontCollection.init(type: .standardUserLibrary, fonts: [Font]())
    }()

    static var fontLibraries: [FontCollection] = {
        var rv = [FontCollection]()
        
        rv.append(.allFonts)
        rv.append(.computerColletion)
        rv.append(.userCollection)
        return rv
    }()
}

