//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/23.
//

import SwiftUI

public struct ThreePanelInternalCardView<Header: View, Content: View, Footer: View>: View {
    private var headerHeight: CGFloat = 0
    private var contentHeight: CGFloat = 0
    private var footerHeight: CGFloat = 0
    var header: () -> Header
    var content: () -> Content
    var footer: () -> Footer

    public init(headerHeight: CGFloat, contentHeight: CGFloat, footerHeight: CGFloat, header: @escaping () -> Header, content: @escaping () -> Content, footer: @escaping () -> Footer) {
        self.headerHeight = headerHeight
        self.contentHeight = contentHeight
        self.footerHeight = footerHeight
        self.header = header
        self.content = content
        self.footer = footer
    }

    public var body: some View {
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

                content()

                footer()
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
    }
}

#Preview {
    ThreePanelInternalCardView(headerHeight: 50, contentHeight: 200, footerHeight: 50) {
        Text("hello")
            .frame(height: 50)
            .background(.yellow)
    } content: {
        Text("hello")
            .frame(height: 200)
            .background(.green)
    } footer: {
        Text("hello")
            .frame(height: 50)
            .background(.blue)
    }
}
