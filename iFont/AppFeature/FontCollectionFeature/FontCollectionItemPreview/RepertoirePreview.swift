//
//  ItemTypeRepertoirePreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct RepertoirePreview: View {
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
            HStack {  // TODO: This will be probably be a lazy grid.
                List {
                    ForEach(fonts) { font in
                        HStack {
                            Spacer()
                            FontRepetoirePreview(font: font, fontSize: fontSize)
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
}

private struct FontRepetoirePreview: View {
    let font: Font
    var fontSize: Double = 32
    
    var body: some View {
        Text("Font Repetoire View")
    }
}

struct RepertoirePreview_Previews: PreviewProvider {
    static var previews: some View {
        RepertoirePreview(fonts: mock_fonts)
    }
}
