//
//  ItemTypeInfoPreview.swift
//  iFont
//
//  Created by Jesse Deda on 7/5/22.
//

import SwiftUI
import ComposableArchitecture

struct FontInfoPreview: View {
    let font: Font
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                Text(font.name)
                    .font(.custom(font.name, size: 32))
                Text(font.name)
                    .font(.caption)
            }
            .padding()
            
            VStack(alignment: .trailing) {
                    Group {
                        Text("PostScript name ")
                        Text("Full name ")
                        Text("Family name ")
                        Text("Style ")
                        Text("Style ")
                        Text("Kind ")
                        Text("Language ")
                        Text("Script ")
                        Text("Version ")
                    }
                    Group {
                        Text("Location ")
                        Text("Unique name ")
                        Text("Copyright ")
                        Text("Trademark ")
                        Text("Enabled ")
                        Text("Duplicate ")
                        Text("Copy protected ")
                        Text("Embedding ")
                        Text("Glyph count ")
                    }
            }
        }
    }
}

struct FontInfoPreview_Previews: PreviewProvider {
    static var previews: some View {
        FontInfoPreview(font: Font(name: "Chicken", familyName: "Cheese"))
    }
}

struct FontFamilyInfoPreview: View {
    let family: FontFamily
    
    var body: some View {
        List {
            ForEach(family.fonts, id: \.name) { font in
                FontInfoPreview(font: font)
            }
        }
    }
}


struct ItemTypeInfoPreview: View {
    let store: Store<AppState, AppAction>
    var item: ItemType
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            switch item {
            case let .font(font):
                FontInfoPreview(font: font)
            case let .fontFamily(fontFamily):
                FontFamilyInfoPreview(family: fontFamily)
            }
        }
    }
}

// TODO: Jdeda Fix me
//struct FontInfoPreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        FontInfoPreviewView()
//    }
//}
