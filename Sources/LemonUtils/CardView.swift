//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/19.
//

import SwiftUI

// 三段式卡片视图

public struct ThreePanelCardShape: Shape {
    private let radius: CGFloat
    var first: CGFloat
    var second: CGFloat

    public init(radius: CGFloat, first: CGFloat, second: CGFloat) {
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

    public func path(in rect: CGRect) -> Path {
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

public struct HeaderHeightPreferenceKey: PreferenceKey {
    public static let defaultValue: CGFloat = 0

    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    }
}

public struct FooterHeightPreferenceKey: PreferenceKey {
    public static let defaultValue: CGFloat = 0

    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    }
}

public struct ImageHeightPreferenceKey: PreferenceKey {
    public static let defaultValue: CGFloat = 0

    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    }
}

public struct ThreePanelCardView<Header: View, Content: View, Footer: View>: View {
    var header: () -> Header
    var content: () -> Content
    var footer: () -> Footer

    @Environment(\.displayScale) private var displayScale

    @State private var headerHeight: CGFloat = 0
    @State private var contentHeight: CGFloat = 0
    @State private var footerHeight: CGFloat = 0

    public init(header: @escaping () -> Header, content: @escaping () -> Content, footer: @escaping () -> Footer) {
        self.header = header
        self.content = content
        self.footer = footer
    }

    var card: some View {
        let shape = ThreePanelCardShape(radius: 8, first: headerHeight, second: contentHeight)

        return ZStack {
            shape
                .fill(.background)
                .frame(width: 300)
                .frame(height: headerHeight + contentHeight + footerHeight)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 8)
                .blur(radius: 0.1)

            VStack(spacing: 0) {
                header()
                    .background {
                        GeometryReader(content: { proxy in
                            Color.clear.preference(key: HeaderHeightPreferenceKey.self, value: proxy.size.height)
                        })
                    }
                    .onPreferenceChange(HeaderHeightPreferenceKey.self, perform: { value in
                        headerHeight = value
                    })

                content().background {
                    GeometryReader(content: { proxy in
                        Color.clear.preference(key: ImageHeightPreferenceKey.self, value: proxy.size.height)
                    })
                }
                .onPreferenceChange(ImageHeightPreferenceKey.self, perform: { value in
                    contentHeight = value
                })

                footer()
                    .background {
                        GeometryReader(content: { proxy in
                            Color.clear.preference(key: FooterHeightPreferenceKey.self, value: proxy.size.height)
                        })
                    }
                    .onPreferenceChange(FooterHeightPreferenceKey.self, perform: { value in
                        footerHeight = value
                    })
            }
            .frame(width: 300)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .mask {
                shape
            }
        }
        .overlay(alignment: .top, content: {
            Line().stroke(style: StrokeStyle(lineWidth: 1, dash: [3])).frame(width: 285, height: 1)
                .foregroundStyle(Color(.black))
                .offset(y: headerHeight + contentHeight)
        })
//        .padding()
    }

    @State private var renderedImage: Image?

    @MainActor public func gen() -> UIImage? {
        let renderer = ImageRenderer(content: card)
        renderer.scale = displayScale
        let img = renderer.uiImage
        if let img {
            renderedImage = Image(uiImage: img)
        }

        return img
    }

    public var body: some View {
        card
            .toolbar(content: {
                ToolbarItem {
                    Button(action: {
                        if let img = gen() {
                            renderedImage = Image(uiImage: img)
                        }
                    }, label: {
                        Text(String(localized: "share", bundle: .module))
                    })
                }
            })
    }
}

#Preview("Card") {
    NavigationStack {
        ThreePanelCardView {
            Rectangle().fill(.blue.opacity(0.4)).frame(height: 50)
                .overlay {
                    Text("hello")
                }
        } content: {
            Rectangle()
                .fill(.yellow.opacity(0.2))
                .frame(height: 150)
            //            .overlay {
            //                TextItemView(textItem: .init(text: "test"), selected: true)
            //            }

        } footer: {
            Rectangle().fill(.blue.opacity(0.4)).frame(height: 50)
                .overlay {
                    Text("world")
                }
        }
    }
}
