//
//  DotLineShape.swift
//  Widget
//
//  Created by ailu on 2024/3/11.
//

import SwiftUI

public struct DotLineShape: Shape {
    var lineWidth: CGFloat

    public init(lineWidth: Double = 1.5) {
        self.lineWidth = lineWidth
    }

    public func path(in rect: CGRect) -> Path {
        var rectPath = Path()
        rectPath.move(to: .init(x: rect.midX - lineWidth / 2, y: rect.minY))
        rectPath.addRect(.init(x: rect.midX - lineWidth / 2, y: rect.minY, width: lineWidth, height: rect.height))

        var bigCircle = Path()
        let center: CGPoint = .init(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 5
        bigCircle.addArc(center: center, radius: radius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)

        let radius2 = radius - lineWidth

        var samllCircle = Path()
        samllCircle.addArc(center: center, radius: radius2, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)

        return bigCircle.union(rectPath).subtracting(samllCircle)
    }
}

#Preview {
    VStack(spacing: 0) {
        ForEach(1 ..< 5, id: \.self) {
            _ in
            HStack {
                DotLineShape()
                    .fill(Color(.systemGray))
                    .frame(width: 50, height: 100)
                Text("00:45")

                HStack {
                    Text("hhhh")
                }
            }
        }
    }
}
