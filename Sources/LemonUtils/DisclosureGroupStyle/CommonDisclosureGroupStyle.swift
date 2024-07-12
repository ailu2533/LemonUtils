//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/7/10.
//

import SwiftUI
public struct CommonDisclosureGroupStyle: DisclosureGroupStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        Group {
            HStack {
                configuration.label
                    .fontWeight(.medium)

                Line()
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))

                Image(systemName: "chevron.right")
                    .imageScale(.medium)
                    .rotationEffect(.degrees(configuration.isExpanded ? 90 : 0))
                    .fontWeight(.medium)
                    .frame(width: 50, height: 30)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.vertical, 12)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.34)) {
                    configuration.isExpanded.toggle()
                }
            }

            if configuration.isExpanded {
                configuration.content
            }
        }.transition(.scale(scale: 0, anchor: .top).combined(with: .opacity))
    }
}
