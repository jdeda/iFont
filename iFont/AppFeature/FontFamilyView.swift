import SwiftUI
import Foundation

struct FontFamilyView: View {
    var family: FontFamily
    var body: some View {
        VStack(alignment: .center) {
            Text(family.name)
            HStack(alignment: .center) {
                List{
                    HStack {
                        Spacer()
                        VStack {
                            ForEach(family.fonts, id: \.name) { font in
                                VStack {
                                    Text(font.name)
                                        .font(.title)
                                        .foregroundColor(.gray)
                                        .padding(5)
                                    Text(String(Array<Character>.alphabet).splitInHalf().left)
                                        .font(.custom(font.name, size: 64))
                                    Text(String(Array<Character>.alphabet).splitInHalf().right)
                                        .font(.custom(font.name, size: 64))
                                    Text(String(Array<Character>.alphabet).uppercased().splitInHalf().left)
                                        .font(.custom(font.name, size: 64))
                                    Text(String(Array<Character>.alphabet).uppercased().splitInHalf().right)
                                        .font(.custom(font.name, size: 64))
                                    Text(String(Array<Character>.digits))
                                        .font(.custom(font.name, size: 64))
                                    Spacer(minLength: 64)
                                }
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct FontFamilyView_Previews: PreviewProvider {
    static var previews: some View {
        FontFamilyView(family: FontFamily(name: "Chicken", fonts: [Font(name: "Cheese", familyName: "Chicken")]))
    }
}

let string = "Hello"

extension String {
    func splitInHalf() -> (left: String, right: String) {
        let start = self.startIndex
        let middle = self.index(self.startIndex, offsetBy: (self.count) / 2)
        let end = self.endIndex
        return (left: String(self[start..<middle]), right: String(self[middle..<end]))
    }
}
