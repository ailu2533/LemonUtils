//
//  ButtonStyle.swift
//  MyHabit
//
//  Created by ailu on 2024/3/25.
//

import Foundation

import SwiftUI

struct MyButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    var selected = false

    var plainColor: Color = Color(.systemBackground)

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(selected ? MyColor.buttonBgBlue : plainColor)
            .foregroundStyle(Color(.systemGray))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .saturation(isEnabled ? 1 : 0)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

public struct BigButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    public init() {
    }

    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(MyColor.buttonButtonBigBlue)
            .foregroundStyle(configuration.role == .destructive ? Color(.systemRed) : MyColor.buttonFontBlue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .saturation(isEnabled ? 1 : 0)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

#Preview("BigButtonStyle") {
    Button(action: {}, label: {
        Text("Button")
//            .frame(width: 200, height: 30)
    })
    .buttonStyle(BigButtonStyle())
}

#Preview("MyButtonStyle") {
    VStack {
        Button(action: {}, label: {
            Text("Button")
//                .frame(width: 200, height: 30)
        })
        .buttonStyle(MyButtonStyle(selected: true))

        Button(action: {}, label: {
            Text("Button")
//                .frame(width: 200, height: 30)
        })
        .buttonStyle(MyButtonStyle(selected: false))
    }
}
