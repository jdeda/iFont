//
//  SidebarContextMenu.swift
//  iFont
//
//  Created by Jesse Deda on 8/2/22.
//

import SwiftUI


/**
 General Options:
 - new collection
 - new library
 - new smart collection
 - rename "x"
 - delete "x"
 */

/**
 Dependent Options: AllFonts
 - new collection
 - new library
 - new smart collection
 X rename "x"
 X delete "x"
 */

//enum FontCollectionType: Equatable, Codable {
//    case unknown               // wtf?
//    case allFontsLibrary       // add
//    case computerLibrary       // add
//    case standardUserLibrary   // add
//    case library(URL)          // add, edit, or delete
//    case smart                 // add, edit, or delete
//    case basic                 // add, edit, or delete
//}

//extension FontCollectionType {
//    var canEdit: Bool {
//        switch self {
//        case .unknown:
//            <#code#>
//        case .allFontsLibrary:
//            <#code#>
//        case .computerLibrary:
//            <#code#>
//        case .standardUserLibrary:
//            <#code#>
//        case .library(_):
//            <#code#>
//        case .smart:
//            <#code#>
//        case .basic:
//            <#code#>
//        }
//    }
//}

struct SidebarContextMenu: View {
    var body: some View {
        Button {
            // viewStore.send(.newLibrary)
        } label: {
            Text("New library")
        }
        Button {
            // viewStore.send(.newCollection)
        } label: {
            Text("New collection")
        }
        Button {
            // viewStore.send(.newSmartCollection)
        } label: {
            Text("New smart collection")
        }
        Button {
            // viewStore.send(.rename)
        } label: {
            Text("Rename \(1)")
        }
        Button {
            // viewStore.send(.delete)
        } label: {
            Text("Delete \(1)")
        }
    }
}


struct SidebarContextMenu_Previews: PreviewProvider {
    static var previews: some View {
        SidebarContextMenu()
    }
}
