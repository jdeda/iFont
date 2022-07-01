////
////  FontFamilyRow.swift
////  iFont
////
////  Created by Klajd Deda on 6/27/22.
////
//
//import SwiftUI
//import ComposableArchitecture
//
//struct FontFamilyRowView: View {
//    let store: Store<AppState, AppAction>
//    var fontFamily: FontFamily
//    
//    var body: some View {
//        WithViewStore(self.store) { viewStore in
//            HStack {
//                Image(systemName: viewStore.familyExpansionState.contains(fontFamily.id)
//                      ? "chevron.down"
//                      : "chevron.right")
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 20, height: 20)
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    Logger.log("toggleExpansion: \(fontFamily.name)")
//                    viewStore.send(AppAction.toggleExpand(fontFamily))
//                }
//                Text(fontFamily.name)
//                Spacer()
//            }
//        }
//    }
//}
//
//struct FontFamilyRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        Text("Fix me")
//        // FontFamilyRowView(store: FontFamilyState.mockStore)
//    }
//}
