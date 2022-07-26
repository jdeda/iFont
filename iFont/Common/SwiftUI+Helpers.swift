//
//  SwiftUI+Helpers.swift
//  iFont
//
//  Created by Jesse Deda on 7/25/22.
//

import SwiftUI



// MARK: Okay
//extension View {
//  func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
//      self.background(
//      GeometryReader { geo in
//          Color.red
//          .preference(key: SizePreferenceKey.self, value: geo.size)
//      }
//    )
//
//    .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
//  }
//}
//
//struct SizePreferenceKey: PreferenceKey {
//    typealias Value = CGSize
//    static var defaultValue: Value = .zero
//
//    static func reduce(value: inout Value, nextValue: () -> Value) {
//        value = nextValue()
//    }
//}

//private struct SizeKey: PreferenceKey {
//    static let defaultValue: CGSize = .zero
//    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
//        value = nextValue()
//    }
//}
//
//private extension View {
//    func captureSize(in binding: Binding<CGSize>) -> some View {
//        overlay(GeometryReader { proxy in
//            Color.clear.preference(key: SizeKey.self, value: proxy.size)
//        })
//            .onPreferenceChange(SizeKey.self) { size in binding.wrappedValue = size }
//    }
//}
//
//struct Rotated<Rotated: View>: View {
//    var view: Rotated
//    var angle: Angle
//
//    init(_ view: Rotated, angle: Angle = .degrees(-90)) {
//        self.view = view
//        self.angle = angle
//    }
//
//    @State private var size: CGSize = .zero
//
//    var body: some View {
//        // Rotate the frame, and compute the smallest integral frame that contains it
//        let newFrame = CGRect(origin: .zero, size: size)
//            .offsetBy(dx: -size.width/2, dy: -size.height/2)
//            .applying(.init(rotationAngle: CGFloat(angle.radians)))
//            .integral
//
//        return view
//            .fixedSize()                    // Don't change the view's ideal frame
//            .captureSize(in: $size)         // Capture the size of the view's ideal frame
//            .rotationEffect(angle)          // Rotate the view
//            .frame(width: newFrame.width,   // And apply the new frame
//                   height: newFrame.height)
//    }
//}
//
//extension View {
//    func rotated(_ angle: Angle = .degrees(-90)) -> some View {
//        Rotated(self, angle: angle)
//    }
//}


import SwiftUI

struct VSlider<V: BinaryFloatingPoint>: View {
    var value: Binding<V>
    var range: ClosedRange<V> = 0...1
    var step: V.Stride? = nil
    var onEditingChanged: (Bool) -> Void = { _ in }

    private let drawRadius: CGFloat = 13
    private let dragRadius: CGFloat = 25
    private let lineWidth: CGFloat = 4.5

    @State private var validDrag = false
    
    @Environment(\.colorScheme) var colorScheme


    init(value: Binding<V>, in range: ClosedRange<V> = 0...1, step: V.Stride? = nil, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.value = value

        if let step = step {
            self.step = step
            var newUpperbound = range.lowerBound
            while newUpperbound.advanced(by: step) <= range.upperBound{
                newUpperbound = newUpperbound.advanced(by: step)
            }
            self.range = ClosedRange(uncheckedBounds: (range.lowerBound, newUpperbound))
        } else {
            self.range = range
        }

        self.onEditingChanged = onEditingChanged
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    // Gray section of line
                    Rectangle()
                        .foregroundColor(Color(NSColor.windowBackgroundColor))
//                        .foregroundColor(.secondary)
                        .frame(height: self.getPoint(in: geometry).y)
                        .clipShape(RoundedRectangle(cornerRadius: 2))

                    // Blue section of line
                    Rectangle()
                        .foregroundColor(.accentColor)
                        .frame(height: geometry.size.height - self.getPoint(in: geometry).y)
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                }
                .frame(width: self.lineWidth)

                // Handle
                Circle()
                    .frame(width: 2 * self.drawRadius, height: 2 * self.drawRadius)
                    .position(self.getPoint(in: geometry))
                    .foregroundColor(colorScheme == .dark ? .gray : .white)
                    .shadow(radius: 1, y: 1)

                // Catches drag gesture
                Rectangle()
                    .frame(minWidth: CGFloat(self.dragRadius))
                    .foregroundColor(Color.red.opacity(0.001))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded({ _ in
                                self.validDrag = false
                                self.onEditingChanged(false)
                            })
                            .onChanged(self.handleDragged(in: geometry))
                )
            }
        }
    }
}

extension VSlider {
    private func getPoint(in geometry: GeometryProxy) -> CGPoint {
        let x = geometry.size.width / 2
        let location = value.wrappedValue - range.lowerBound
        let scale = V(2 * drawRadius - geometry.size.height) / (range.upperBound - range.lowerBound)
        let y = CGFloat(location * scale) + geometry.size.height - drawRadius
        return CGPoint(x: x, y: y)
    }

    private func handleDragged(in geometry: GeometryProxy) -> (DragGesture.Value) -> Void {
        return { drag in
            if drag.startLocation.distance(to: self.getPoint(in: geometry)) < self.dragRadius && !self.validDrag {
                self.validDrag = true
                self.onEditingChanged(true)
            }

            if self.validDrag {
                let location = drag.location.y - geometry.size.height + self.drawRadius
                let scale = CGFloat(self.range.upperBound - self.range.lowerBound) / (2 * self.drawRadius - geometry.size.height)
                let newValue = V(location * scale) + self.range.lowerBound
                let clampedValue = max(min(newValue, self.range.upperBound), self.range.lowerBound)

                if self.step != nil {
                    let step = V.zero.advanced(by: self.step!)
                    self.value.wrappedValue = round((clampedValue - self.range.lowerBound) / step) * step + self.range.lowerBound
                } else {
                    self.value.wrappedValue = clampedValue
                }
            }
        }
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}
