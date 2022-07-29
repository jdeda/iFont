//
//  ItemTypeCustomPreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture


struct CustomPreview: View {
    @State var fontSize: Double = 32
    let fonts: [Font]
    let fontSizes = [9,10,11,12,14,18,24,36,48,64,72,96,144,288].sorted()
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer()
                CompactPicker(
                    label: "Size:",
                    selection: Binding<Int>(
                        get: { Int(fontSize) },
                        set: { fontSize = Double($0) }
                    ),
                    data: fontSizes
                )
                .frame(width: 120, height: 30)
            }
            .zIndex(1)
            HStack {
                ScrollView {
                    ForEach(fonts) { font in
                        HStack {
                            Spacer()
                            FontCustomPreview (font: font, fontSize: fontSize)
                            Spacer()
                        }
                        .padding(.bottom, 30)
                    }
                }
                VSlider(value: $fontSize, in: 12 ... 288)
                    .frame(minWidth: 25, maxWidth: 25, maxHeight: .infinity)
                    .padding(.horizontal, 10)
            }
            .padding(.bottom, 15)
        }
        .padding()
    }
    
    private struct FontCustomPreview: View {
        let font: Font
        var fontSize: Double = 32
        
        var body: some View {
            VStack {
                Text(font.fontFullName ?? font.name)
                    .font(.title)
                    .foregroundColor(.gray)
                    .padding(5)
                HStack {
                    Text(String.quickBrownFox)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.init(font: font, size: fontSize))
                    Spacer()
                }
            }
        }
    }
}

// MARK: This is what we had before the slider and picker.
//struct CustomPreview: View {
//    let fonts: [Font]
//    var fontSize: Double = 32
//
//    var body: some View {
//        ScrollView {
//            ForEach(fonts) { font in
//                FontCustomPreview(font: font, fontSize: fontSize)
//                    .padding(.leading)
//                    .padding(.bottom, 30)
//            }
//        }
//    }
//
//    private struct FontCustomPreview: View {
//        let font: Font
//        var fontSize: Double = 32
//
//        var body: some View {
//            VStack {
//                Text("\(font.attributes[.full] ?? font.name)")
//                    .font(.title)
//                    .foregroundColor(.gray)
//                    .padding(5)
//                HStack {
//                    Text(String.quickBrownFox)
//                        .fixedSize(horizontal: false, vertical: true)
//                        .font(.custom(font.name, size: fontSize))
//                    Spacer()
//                }
//            }
//        }
//    }
//}
//
//struct ItemTypeCustomPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomPreview(fonts: mock_fonts)
//    }
//}


// MARK: This is what we had before changing the switch statement to just a list. This is more convoluted.
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
