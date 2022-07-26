//
//  ItemTypeSamplePreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct SamplePreview: View {
    var item: FontCollectionItem
    @State var fontSize: Double = 32
    
    var body: some View {
        HStack {
            switch item {
            case let .font(font):
                FontSamplePreview(font: font, fontSize: fontSize)
            case let .fontFamily(fontFamily):
                FontFamilySamplePreview(family: fontFamily, fontSize: fontSize)
            }
            
            Spacer()
            
            VSlider(value: $fontSize, in: 12 ... 288)
                .frame(minWidth: 20, maxWidth: 30, maxHeight: .infinity)
                // .padding()
        }
    }
}


struct SamplePreview_Previews: PreviewProvider {
    static var previews: some View {
        let fonts = (1...10).map { int in
            Font(
                url: URL(fileURLWithPath: NSTemporaryDirectory()),
                name: "Chicken \(int)",
                familyName: "Cheese"
            )
        }
        
        SamplePreview(item: FontCollectionItem.fontFamily(FontFamily(name: "Cheese", fonts: fonts)))
    }
}

//struct SamplePreview: View {
//    let store: Store<FontCollectionState, FontCollectionAction>
//    var item: FontCollectionItem
//    @State var fontSize: Double = 32
//
//    var body: some View {
//        WithViewStore(self.store) { viewStore in
//            HStack {
//                switch item {
//                case let .font(font):
//                    FontSamplePreview(font: font, fontSize: fontSize)
//                case let .fontFamily(fontFamily):
//                    FontFamilySamplePreview(family: fontFamily, fontSize: fontSize)
//                }
//
//
//                Spacer()
//
//                VSlider(value: $fontSize, in: 12 ... 288)
//                    .frame(minWidth: 30, maxWidth: 30, maxHeight: .infinity)
//                    .padding()
//
////                Slider(value: $fontSize, in: 12 ... 288)
////                    .rotationEffect(.degrees(-90))
////                    .frame(minWidth: 300, maxWidth: 300)
////                    .frame(maxHeight: .infinity)
////                    .padding(.bottom, 10)
//
//            //https://stackoverflow.com/questions/58073203/how-can-i-make-a-bunch-of-vertical-sliders-in-swiftui
//                //                Slider(value: $fontSize, in: 12 ... 64)
//                ////                    .rotated()
//                ////                    .rotationEffect(.degrees(-90))
//                ////                    .readSize { newSize in
//                ////                        sliderSize = newSize
//                ////                        print("new size: \(newSize)")
//                ////                    }
//                ////                    .frame(
//                ////                        width: sliderSize.width,
//                ////                        height: sliderSize.height
//                ////                    )
//                //            }
//            }
//        }
//    }
//}
//
//
//struct SamplePreview_Previews: PreviewProvider {
//    static var previews: some View {
//        let fonts = (1...10).map { int in
//            Font(
//                url: URL(fileURLWithPath: NSTemporaryDirectory()),
//                name: "Chicken \(int)",
//                familyName: "Cheese"
//            )
//        }
//
//        SamplePreview(
//            store: FontCollectionState.mockStore,
//            item: FontCollectionItem.fontFamily(FontFamily(name: "Cheese", fonts: fonts))
//        )
//    }
//}

// MARK: - Helper Views

fileprivate struct FontSamplePreview: View {
    let font: Font
    var fontSize: Double = 32
    
    private var swiftUIFont: SwiftUI.Font {
        let rv = SwiftUI.Font.custom(font.name, size: fontSize)
        return rv
    }
    
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
        .font(self.swiftUIFont)
    }
}

struct FontSamplePreview_Previews: PreviewProvider {
    static var previews: some View {
        FontSamplePreview(font: Font(
            url: URL.init(fileURLWithPath: NSTemporaryDirectory()),
            name: "Cheese",
            familyName: "Chicken"))
    }
}

fileprivate struct FontFamilySamplePreview: View {
    var family: FontFamily
    var fontSize: Double = 32
    
    var body: some View {
        VStack(alignment: .center) {
            Text(family.name)
            HStack(alignment: .center) {
                List {
                    HStack {
                        Spacer()
                        VStack {
                            ForEach(family.fonts, id: \.name) { font in
                                FontSamplePreview(font: font, fontSize: fontSize)
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
        FontFamilySamplePreview.init(
            family: FontFamily.init(
                name: "Cheese",
                fonts: [
                    Font(
                        url: URL.init(fileURLWithPath: NSTemporaryDirectory()),
                        name: "Cheese",
                        familyName: "Chicken")
                ]
            )
        )
    }
}
