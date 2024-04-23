//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/19.
//

import SwiftUI

// 线
public struct Line: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }

    public init() {
    }
}

// 虚线
//  Line().stroke(style: StrokeStyle(lineWidth: 1, dash: [3])).frame(width: 285, height: 1)
//    .foregroundStyle(Color(.black))
//    .offset(y: headerHeight + contentHeight)
