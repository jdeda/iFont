//
//  FontRowView.swift
//  iFont
//
//  Created by Jesse Deda on 7/1/22.
//

import SwiftUI

struct FontRowView: View {
    let font: Font
    var body: some View {
        Text("\t \(font.name)")
    }
}
