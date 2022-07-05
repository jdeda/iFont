//
//  ItemTypeSamplePreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture
//
//struct FontSamplePreview: View {
//    let font: Font
//    
//    var body: some View {
//        Text("\(font.name)")
//            .padding(.leading, 40)
//    }
//}
//
//struct FontFamilySamplePreview: View {
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

struct FontSamplePreview: View {
    let font: Font
    
    var body: some View {
        VStack {
            Text(font.name)
                .font(.title)
                .foregroundColor(.gray)
                .padding(5)
            Text(String.alphabet.splitInHalf().left)
            Text(String.alphabet.splitInHalf().right)
            Text(String.alphabet.uppercased().splitInHalf().left)
            Text(String.alphabet.uppercased().splitInHalf().right)
            Text(String.digits)
            Spacer(minLength: 64)
        }
        .font(.custom(font.name, size: 32))
    }
}

struct FontFamilySamplePreview: View {
    var family: FontFamily
    
    var body: some View {
        VStack(alignment: .center) {
            Text(family.name)
            HStack(alignment: .center) {
                List {
                    HStack {
                        Spacer()
                        VStack {
                            ForEach(family.fonts, id: \.name) { font in
                                FontDetailView(font: font)
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct FontFamilySamplePreview_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            FontSamplePreview(
                font: Font(name: "Cheese", familyName: "Chicken")
            )
            FontFamilySamplePreview(
                family: FontFamily(
                    name: "Chicken",
                    fonts: [Font(name: "Cheese", familyName: "Chicken")]
                )
            )
        }
        .frame(width: 800, height: 600)
    }
}


struct ItemTypeSamplePreview: View {
    let store: Store<AppState, AppAction>
    var item: ItemType
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            switch item {
            case let .font(font):
                FontSamplePreview(font: font)
            case let .fontFamily(fontFamily):
                FontFamilySamplePreview(family: fontFamily)
            }
        }
    }
}


// TODO: Jdeda Fix me
//struct FontSamplePreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        FontSamplePreviewView()
//    }
//}
