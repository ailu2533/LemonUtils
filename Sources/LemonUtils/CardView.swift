//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/19.
//

import SwiftUI

// 三段式卡片视图

struct ThreePanelCardShape: Shape {
    private let radius: CGFloat
    var first: CGFloat
    var second: CGFloat

    init(radius: CGFloat, first: CGFloat, second: CGFloat) {
        self.radius = radius
        self.first = first
        self.second = second
    }

    func p(center: CGPoint, startAngle: Double, endAngle: Double) -> Path {
        var path = Path()
        path.move(to: center)
        path.addArc(center: center, radius: radius, startAngle: .degrees(startAngle), endAngle: .degrees(endAngle), clockwise: false)
        path.addLine(to: center)
        path.closeSubpath()
        return path
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.addRect(rect)

        // 第一个缺口
//        let firstPathLeft = p(center: .init(x: rect.minX, y: rect.minY + first), startAngle: -90.0, endAngle: 90.0)
//        let firstPathLeftRight = p(center: .init(x: rect.maxX, y: rect.minY + first), startAngle: 90.0, endAngle: 270.0)

        let secondPathLeft = p(center: .init(x: rect.minX, y: rect.minY + first + second), startAngle: -90.0, endAngle: 90.0)
        let secondPathRight = p(center: .init(x: rect.maxX, y: rect.minY + first + second), startAngle: 90.0, endAngle: 270.0)

        return path
//            .subtracting(firstPathLeft)
//            .subtracting(firstPathLeftRight)
            .subtracting(secondPathLeft)
            .subtracting(secondPathRight)
    }
}

struct ImageHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

public struct ThreePanelCardView<Header: View, Content: View, Footer: View>: View {
    var header: () -> Header
    var content: () -> Content
    var footer: () -> Footer

    private let headerColor: Color
    private let bottomColor: Color

    private let headerHeight: CGFloat = 50
    @State private var contentHeight: CGFloat = 150
    private let footerHeight: CGFloat = 50

    public init(headerColor: Color, bottomColor: Color, header: @escaping () -> Header, content: @escaping () -> Content, footer: @escaping () -> Footer) {
        self.headerColor = headerColor
        self.bottomColor = bottomColor
        self.header = header
        self.content = content
        self.footer = footer
    }

    public var body: some View {
        let shape = ThreePanelCardShape(radius: 8, first: headerHeight, second: contentHeight)

        ZStack {
            shape
                .fill(.background)
                .frame(width: 300)
                .frame(height: headerHeight + contentHeight + footerHeight)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 8)
                .blur(radius: 1)

            VStack(spacing: 0) {
                Rectangle()
                    .frame(height: headerHeight)
                    .foregroundStyle(headerColor)
                    .overlay {
                        header()
                    }
                Rectangle()
                    .frame(height: contentHeight)
                    .foregroundStyle(bottomColor)
                    .overlay {
                        content().overlay {
                            GeometryReader(content: { proxy in
                                Color.clear.preference(key: ImageHeightPreferenceKey.self, value: proxy.size.height)
                            })
                        }
                    }
                Rectangle()
                    .frame(height: footerHeight)
                    .foregroundStyle(bottomColor)
                    .overlay {
                        footer()
                    }
            }
            .frame(width: 300)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .mask {
                shape
            }
            .onPreferenceChange(ImageHeightPreferenceKey.self, perform: { value in
                contentHeight = value
            })
        }

        .overlay(alignment: .top, content: {
            Line().stroke(style: StrokeStyle(lineWidth: 1, dash: [3])).frame(width: 285, height: 1)
                .foregroundStyle(Color(.black))
                .offset(y: headerHeight + contentHeight)
        })
    }
}

#Preview {
    ThreePanelCardView(headerColor: .blue.opacity(0.3), bottomColor: .red.opacity(0.3)
    ) {
        Text("生日")
    } content: {
        Text("还有3天")
            .font(.title)
            .fontWeight(.heavy)
            .frame(height: 205)
    } footer: {
        Text(Date().formatted(date: .abbreviated, time: .omitted))
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}
