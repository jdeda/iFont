//
//  ItemTypeCustomPreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct CustomPreview: View {
    let fonts: [Font]
    
    init(item: FontCollectionItem) {
        switch item {
        case let .font(font):
            self.fonts = [font]
        case let.fontFamily(family):
            self.fonts = family.fonts
        }
    }
    
    var body: some View {
        ScrollView {
            ForEach(fonts) { font in
                FontCustomPreview(font: font)
                    .padding(.leading)
                    .padding(.bottom, 30)
            }
        }
    }
    
    private struct FontCustomPreview: View {
        let font: Font
        
        var body: some View {
            VStack {
                Text("\(font.attributes[.full] ?? font.name)")
                    .font(.title)
                    .foregroundColor(.gray)
                    .padding(5)
                HStack {
                    Text(String.quickBrownFox)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.custom(font.name, size: 32))
                    Spacer()
                }
            }
        }
    }
}

struct ItemTypeCustomPreview_Previews: PreviewProvider {
    static var previews: some View {
        let fonts = (1...10).map { int in
            Font(
                url: URL(fileURLWithPath: NSTemporaryDirectory()),
                name: "Chicken \(int)",
                familyName: "Cheese"
            )
        }
        
        CustomPreview(item: FontCollectionItem.fontFamily(FontFamily(name: "Chicken", fonts: fonts)))
    }
}



//struct CustomPreview: View {
//    var item: FontCollectionItem
//
//    var body: some View {
//        ScrollView {
//            switch item {
//            case let .font(font):
//                FontCustomPreview(font: font)
//            case let .fontFamily(fontFamily):
//                FontFamilyCustomPreview(family: fontFamily)
//            }
//        }
//    }
//}
//
//struct ItemTypeCustomPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        let fonts = (1...10).map { int in
//            Font(
//                url: URL(fileURLWithPath: NSTemporaryDirectory()),
//                name: "Chicken \(int)",
//                familyName: "Cheese"
//            )
//        }
//
//        CustomPreview(item: FontCollectionItem.fontFamily(FontFamily(name: "Chicken", fonts: fonts)))
//    }
//}
//
//
//fileprivate struct FontCustomPreview: View {
//    let font: Font
//
//    var body: some View {
//        VStack {
//            Text("\(font.attributes[.full] ?? font.name)")
//                .font(.title)
//                .foregroundColor(.gray)
//                .padding(5)
//            HStack {
//                Text(String.quickBrownFox)
//                    .fixedSize(horizontal: false, vertical: true)
//                Spacer()
//            }
//            Spacer(minLength: 64)
//        }
////        .font(.custom(font.name, size: 32))
//    }
//}
//
//fileprivate struct FontFamilyCustomPreview: View {
//    var family: FontFamily
//
//    var body: some View {
//        HStack {
//            Spacer()
//            LazyVStack {
//                ForEach(family.fonts, id: \.name) { font in
//                    FontCustomPreview(font: font)
//                }
//            }
//            Spacer()
//        }
//    }
//}
