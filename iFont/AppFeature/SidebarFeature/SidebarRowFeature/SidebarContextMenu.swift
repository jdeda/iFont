////
////  SidebarContextMenu.swift
////  iFont
////
////  Created by Jesse Deda on 8/2/22.
////
//
//import SwiftUI
//
//
///**
// General Options:
// - new collection
// - new library
// - new smart collection
// - rename "x"
// - delete "x"
// */
//
///**
// Dependent Options: AllFonts
// - new collection
// - new library
// - new smart collection
// X rename "x"
// X delete "x"
// */
//
//
//struct SidebarContextMenu: View {
//    var collection: FontCollection
//    var body: some View {
//        Button {
//            // viewStore.send(.newLibrary)
//        } label: {
//            Text("New library")
//        }
//        Button {
//            // viewStore.send(.newCollection)
//        } label: {
//            Text("New collection")
//        }
//        Button {
//            // viewStore.send(.newSmartCollection)
//        } label: {
//            Text("New smart collection")
//        }
//        Button {
//            // viewStore.send(.rename)
//        } label: {
//            Text("Rename \(1)")
//        }
//        Button {
//            // viewStore.send(.delete)
//        } label: {
//            Text("Delete \(1)")
//        }
//    }
//}
//
//
//struct SidebarContextMenu_Previews: PreviewProvider {
//    static var previews: some View {
//        SidebarContextMenu()
//    }
//}
