//
//  ItemTypePreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct FontCollectionItemPreview: View {
    let selection: FontCollectionItemPreviewType
    let item: FontCollectionItem
    let fonts: [Font]
    
    init(selection: FontCollectionItemPreviewType, item: FontCollectionItem) {
        self.selection = selection
        self.item = item
        self.fonts = {
            switch item {
            case let .font(font):           return [font]
            case let .fontFamily(family):   return family.fonts
            }
        }()
    }
    
    var body: some View {
        switch selection {
        case .sample:
            SamplePreview(fonts: fonts)
        case .repertoire:
            RepertoirePreview(fonts: fonts)
        case .custom:
            CustomPreview(fonts: fonts)
        case .info:
            InfoPreview(fonts: fonts)
        }
    }
}

struct ItemTypePreview_Previews: PreviewProvider {
    static var previews: some View {
        FontCollectionItemPreview(
            selection: .sample,
            item: .fontFamily(mock_family)
        )
    }
}


// MARK: This is an attempt to extract a reusable view...
// MARK: Sample, Repetoire, and Custom previews are really just a list of individual font detail views
// MARK: stuffed next to a slider and picker that can resize them (well, their fonts).
//struct FontResizeView: View {
//    @State var fontSize: Double = 32
//    let fonts: [Font]
//    let selection: FontCollectionItemPreviewType
//    
//    var body: some View {
//        VStack(spacing: 10) {
//            HStack {
//                Spacer()
//                Picker("Size:", selection: Binding<Int>(
//                    get: { Int(fontSize) },
//                    set: { fontSize = Double($0) }
//                )) {
//                    ForEach(12...288, id: \.self) {
//                        Text("\($0)").tag($0)
//                    }
//                }
//                .frame(width: 95, height: 30)
//            }
//            HStack {
//                //                List {
//                //                    ForEach(fonts) { font in
//                //                        HStack {
//                //                            Spacer()
//                //                            SamplePreview(fonts: fonts)
//                ////                            switch selection {
//                ////                                case .sample:       SamplePreview(fonts: fonts)
//                ////                                case .repertoire:   RepertoirePreview(fonts: fonts)
//                ////                                case .custom:       CustomPreview(fonts: fonts)
//                ////                                default:            EmptyView()
//                ////                            }
//                //                            Spacer()
//                //                        }
//                //                        .padding(.bottom, 30)
//                //                    }
//                
//                VSlider(value: $fontSize, in: 12 ... 288)
//                    .frame(minWidth: 25, maxWidth: 25, maxHeight: .infinity)
//                    .padding(.horizontal, 10)
//            }
//            .padding(.bottom, 15)
//        }
//        .padding()
//    }
//}

//struct FontCollectionItemPreview: View {
//    let store: Store<FontCollectionState, FontCollectionAction>
//    var selection: FontCollectionItemPreviewType
//    var item: FontCollectionItem
//
//    var body: some View {
//        WithViewStore(self.store) { viewStore in
//
//            // We previously said that these views will hold onto a store as we may have buttons in these views
//            // i.e. resize slider.
//
//            switch selection {
//            case .sample:
//                SamplePreview(store: store, item: item)
//            case .repertoire:
//                RepertoirePreview(store: store, item: item)
//            case .custom:
//                CustomPreview(store: store, item: item)
//            case .info:
//                InfoPreview(store: store, item: item)
//            }
//        }
//    }
//}
//
//
//struct ItemTypePreview_Previews: PreviewProvider {
//    static var previews: some View {
//        let fonts = (1...10).map { int in
//            Font(
//                url: URL(fileURLWithPath: NSTemporaryDirectory()),
//                name: "Chicken \(int)",
//                familyName: "Cheese"
//            )
//        }
//
//        FontCollectionItemPreview(
//            store: FontCollectionState.mockStore,
//            selection: .sample,
//            item: FontCollectionItem.fontFamily(FontFamily(name: "Cheese", fonts: fonts))
//        )
//    }
//}
