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
    @State var text: String = "The quick brown fox jumps over the lazy dog and runs away."

    
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
                            FontCustomPreview (font: font, fontSize: fontSize, text: $text)
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
        @Binding var text: String

//        @Binding var text: String = "The quick brown fox jumps over the lazy dog and runs away."
        
        var body: some View {
            VStack {
                Text(font.fontFullName ?? font.name)
                    .font(.title)
                    .foregroundColor(.gray)
                    .padding(5)
                HStack {
                    TextEditor.init(text: $text)
//                        .fixedSize(horizontal: false, vertical: true)
                        .font(.init(font: font, size: fontSize))
                    Spacer()
                }
            }
        }
    }
}
