import SwiftUI
import Foundation

struct FontDetails: View {
    var font: Font
    
    var fontAttributes: [[String: String]] {
        let attributes = font.fontAttributes
        let keys = Array(attributes.keys).sorted(by: <)
        
        return keys.reduce(into: [[String: String]](), { partialResult, nextItem in
            partialResult.append(["key": nextItem, "value": attributes[nextItem] ?? ""])
        })
        //        return font.fontAttributes.map { (key: String, value: String) -> [String: String] in
        //            ["key": key, "value": value]
        //        }
    }
    
    var body: some View {
        VStack {
            ForEach(fontAttributes, id: \.self) { item in
                HStack {
                    Text(item["key"] ?? "")
                        .frame(width: 240, alignment: .trailing)
                    Text(item["value"] ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

struct FamilyView: View {
    var family: FontFamily
    
    var body: some View {
        VStack(alignment: .center) {
            Text(family.name)
            HStack(alignment: .center) {
                List {
                    HStack {
                        Spacer()
                        VStack {
                            ForEach(family.fonts, id: \.name) { font in
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
                                .font(.custom(font.name, size: 32))
                                
                                FontDetails(font: font)
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct FamilyView_Previews: PreviewProvider {
    static var previews: some View {
        FamilyView(family: FontFamily(name: "Chicken", fonts: [Font(name: "Cheese", familyName: "Chicken")]))
    }
}