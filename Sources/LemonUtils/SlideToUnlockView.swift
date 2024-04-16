//
//  SlideToUnlockView.swift
//  MyHabit
//
//  Created by ailu on 2024/3/26.
//

import SwiftUI

public func clamp<T>(_ value: T, minValue: T, maxValue: T) -> T where T: Comparable {
    return min(max(value, minValue), maxValue)
}

struct SlideToUnlockView: View {
    @Binding private var confirmed: Bool

    @State private var isDragging = false

    @State private var xOffset: CGFloat = .zero

    init(confirmed: Binding<Bool>) {
        _confirmed = confirmed
    }

    var drag: some Gesture {
        DragGesture()

            .onChanged { value in

                let dragAmount = value.translation.width

                withAnimation(.smooth(duration: 0.5)) {
                    xOffset = clamp(dragAmount, minValue: 0, maxValue: 200)
                }
            }
            .onEnded { _ in
                if xOffset < 100 {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        xOffset = 0
                        confirmed = false
                    }
                } else {
                    withAnimation {
                        xOffset = 200
                        confirmed = true
                    }
                }
            }
    }

    var body: some View {
        ZStack {
            Capsule()
                .fill(.blue.opacity(0.5))
                .frame(width: 300, height: 100)

            Circle()
                .fill(self.isDragging ? Color.red : Color.blue)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: -100)
                .offset(x: xOffset)

                .gesture(drag)
        }
    }
}
