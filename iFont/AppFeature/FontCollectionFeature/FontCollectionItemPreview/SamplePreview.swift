//
//  ItemTypeSamplePreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct SamplePreview: View {
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
                List {
                    ForEach(fonts) { font in
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
                    .padding(.horizontal, 10)
            }
            .padding(.bottom, 15)
        }
        .padding()
    }
    
    private struct FontSamplePreview: View {
        let font: Font
        var fontSize: Double = 32
        
        
        var body: some View {
            VStack(alignment: .center) {
                Text(font.fontFullName ?? font.name)
                    .font(.title)
                    .foregroundColor(.gray)
                    .padding(5)
                Text(String.alphabet.splitInHalf().left)
                Text(String.alphabet.splitInHalf().right)
                Text(String.alphabet.uppercased().splitInHalf().left)
                Text(String.alphabet.uppercased().splitInHalf().right)
                Text(String.digits)
            }
            .font(.init(font: font, size: fontSize))
        }
    }
}

struct SamplePreview_Previews: PreviewProvider {
    static var previews: some View {
        SamplePreview(fonts: mock_fonts)
    }
}

// MARK: This is what we had before, without the slider and picker.
//struct SamplePreview: View {
//    let fonts: [Font]
//    var fontSize: Double = 32
//
//    var body: some View {
//        List {
//            ForEach(fonts) { font in
//                HStack {
//                    Spacer()
//                    FontSamplePreview(font: font, fontSize: fontSize)
//                    Spacer()
//                }
//                .padding(.bottom, 30)
//            }
//        }
//    }
//
//    private struct FontSamplePreview: View {
//        let font: Font
//        var fontSize: Double = 32
//
//        private var swiftUIFont: SwiftUI.Font {
//            SwiftUI.Font.custom(font.name, size: fontSize)
//        }
//
//        var body: some View {
//            VStack(alignment: .center) {
//                Text(font.name)
//                    .font(.title)
//                    .foregroundColor(.gray)
//                    .padding(5)
//                Text(String.alphabet.splitInHalf().left)
//                Text(String.alphabet.splitInHalf().right)
//                Text(String.alphabet.uppercased().splitInHalf().left)
//                Text(String.alphabet.uppercased().splitInHalf().right)
//                Text(String.digits)
//            }
//            .font(swiftUIFont)
//        }
//    }
//}
//
//struct SamplePreview_Previews: PreviewProvider {
//    static var previews: some View {
//        SamplePreview(fonts: mock_fonts)
//    }
//}


// MARK: This is what we had before changing the switch statement to just a list. This is more convoluted.
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
