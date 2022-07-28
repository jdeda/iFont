//
//  CompactPicker.swift
//  iFont
//
//  Created by Jesse Deda on 7/27/22.
//

import SwiftUI


struct CompactPicker: View {
    var label: String
    
    @Binding var selection: Int
    @State var data: [Int]
    @State var expanded: Bool = true
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 0) {
            Text("\(label)    ")
                .frame(width: 40)
            HStack {
                TextField("", text: .init(
                    get: { String(selection) },
                    set: { string in
                        if let integer = Int(string) {
                            selection = integer
                        }
                    }
                ))
                .textFieldStyle(PlainTextFieldStyle())
                .frame(width: 20)
                .padding(.horizontal, 5)
                Button {
                    expanded.toggle()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .frame(width: 16, height: 16)
                            .foregroundColor(.accentColor)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 8, weight: .heavy))
                    }
                }
                .buttonStyle(.plain)
            }
            .padding(2)
            .background(Color(NSColor.windowBackground))  // MARK: Light, dark
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.secondary, lineWidth: 1)
                    .foregroundColor(Color(NSColor.gray))
            )
        }
        .overlay(
            VStack {
                if expanded {
                    List(selection: .init($selection)) {
                        ForEach(data, id: \.self) { int in
                            Text("\(int)").tag(int)
                                .padding(.bottom, -5)
                            }
                        .frame(width: 75, alignment: .leading)
                        .padding(.horizontal, 7)
                    }
                    .listStyle(PlainListStyle())
//                    .listStyle(SidebarListStyle())
                    .cornerRadius(8)
                    // .scrollContentBackground(Color(NSColor.windowBackground))
                    // XCode14b3...  // MARK: Light, dark
                    .frame(width: 75, height: 125)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.secondary, lineWidth: 1)
//                            .foregroundColor(Color(NSColor.gray)) // MARK: Light, dark
                            .cornerRadius(8)
                    )
                    .padding(.top, 20)
                    .padding(Edge.Set.horizontal, -10)
                    
                }
            }, alignment: .topTrailing
            
        )
    }
}


struct CompactPicker_Previews: PreviewProvider {
    
    struct Helper: View {
        @State var selection: Int = 0
        @State var data = [9,72,144,288].sorted()
        var body: some View {
            CompactPicker(label: "Size:", selection: $selection, data: data)
        }
    }
    static var previews: some View {
        VStack {
            Text("Custom Picker")
            Helper()
            Spacer()
        }
        .frame(width: 200, height: 200)
    }
}
