//
//  ItemTypeSamplePreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct SamplePreview: View {
    let fonts: [Font]
    
    @State var fontSize: Double = 32
    
    init(item: FontCollectionItem) {
        switch item {
        case let .font(font):
            self.fonts = [font]
        case let .fontFamily(family):
            self.fonts = family.fonts
        }
    }
    
    var body: some View {
        HStack {
            List {
                ForEach(fonts, id: \.name) { font in
                    HStack {
                        Spacer()
                        FontSamplePreview(font: font, fontSize: fontSize)
                        Spacer()
                    }
                    .padding(.bottom, 30)
                }
            }
            VSlider(value: $fontSize, in: 12 ... 288)
                .frame(minWidth: 25, maxWidth: 25, maxHeight: .infinity)
                .padding()
        }
    }
    
    private struct FontSamplePreview: View {
        let font: Font
        var fontSize: Double = 32
        
        private var swiftUIFont: SwiftUI.Font {
            SwiftUI.Font.custom(font.name, size: fontSize)
        }
        
        var body: some View {
            VStack(alignment: .center) {
                Text(font.name)
                    .font(.title)
                    .foregroundColor(.gray)
                    .padding(5)
                Text(String.alphabet.splitInHalf().left)
                Text(String.alphabet.splitInHalf().right)
                Text(String.alphabet.uppercased().splitInHalf().left)
                Text(String.alphabet.uppercased().splitInHalf().right)
                Text(String.digits)
            }
            .font(self.swiftUIFont)
        }
    }
}


struct SamplePreview_Previews: PreviewProvider {
    static var previews: some View {
        SamplePreview(item: FontCollectionItem.fontFamily(FontFamily(name: "Cheese", fonts: mock_fonts)))
    }
}

//struct SamplePreview: View {
//    var item: FontCollectionItem
//    @State var fontSize: Double = 32
//
//    var body: some View {
//        HStack {
//
//            Spacer()
//
//            switch item {
//            case let .font(font):
//                FontSamplePreview(font: font, fontSize: fontSize)
//            case let .fontFamily(fontFamily):
//                FontFamilySamplePreview(family: fontFamily, fontSize: fontSize)
//            }
//
//            Spacer()
//
//            VSlider(value: $fontSize, in: 12 ... 288)
//                .frame(minWidth: 25, maxWidth: 25, maxHeight: .infinity)
//                .padding()
//        }
//    }
//}

//// MARK: - Helper Views
//
//fileprivate struct FontSamplePreview: View {
//    let font: Font
//    var fontSize: Double = 32
//
//    private var swiftUIFont: SwiftUI.Font {
//        SwiftUI.Font.custom(font.name, size: fontSize)
//    }
//
//    var body: some View {
//        VStack(alignment: .center) {
//            Text(font.name)
//                .font(.title)
//                .foregroundColor(.gray)
//                .padding(5)
//            Text(String.alphabet.splitInHalf().left)
//            Text(String.alphabet.splitInHalf().right)
//            Text(String.alphabet.uppercased().splitInHalf().left)
//            Text(String.alphabet.uppercased().splitInHalf().right)
//            Text(String.digits)
//        }
//        .font(self.swiftUIFont)
//    }
//}
//
//struct FontSamplePreview_Previews: PreviewProvider {
//    static var previews: some View {
//        FontSamplePreview(font: Font(
//            url: URL(fileURLWithPath: NSTemporaryDirectory()),
//            name: "Cheese",
//            familyName: "Chicken"))
//    }
//}
//
//fileprivate struct FontFamilySamplePreview: View {
//    var family: FontFamily
//    var fontSize: Double = 32
//
//    var body: some View {
//        List {
//            ForEach(family.fonts, id: \.name) { font in
//                HStack {
//                    Spacer()
//                    FontSamplePreview(font: font, fontSize: fontSize)
//                    Spacer()
//                }
//            }
//        }
//    }
//}
//
//struct FontFamilySamplePreview_Previews: PreviewProvider {
//    static var previews: some View {
//
//        let fonts = (1...10).map { int in
//            Font(
//                url: URL(fileURLWithPath: NSTemporaryDirectory()),
//                name: "Chicken \(int)",
//                familyName: "Cheese"
//            )
//        }
//        FontFamilySamplePreview(
//            family: FontFamily(
//                name: "Cheese",
//                fonts: fonts
//            )
//        )
//    }
//}
