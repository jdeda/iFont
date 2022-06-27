import SwiftUI

extension View {
    func highlightSelectionBox(_ flag: Bool) -> some View {
        self
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(flag ? Color.accentColor : Color.clear)
            }
            .overlay {
                self
            }
    }
}
