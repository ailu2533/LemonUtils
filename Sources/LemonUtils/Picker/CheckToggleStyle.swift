//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/5/13.
//

import SwiftUI

public struct CheckToggleStyle: ToggleStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack {
                configuration.label
                    .font(.callout)
                Spacer()
                toggleIcon(isOn: configuration.isOn)
            }
            .contentShape(Rectangle())
            .padding(.horizontal)
//            .animation(.easeInO ut, value: configuration.isOn)
        }
        .buttonStyle(.plain)
        .accessibilityHint(configuration.isOn ? "Tap to uncheck" : "Tap to check") // 增加辅助功能提示
    }

    @ViewBuilder
    private func toggleIcon(isOn: Bool) -> some View {
        Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
            .foregroundStyle(isOn ? Color.accentColor : .secondary)
            .accessibility(label: Text(isOn ? "Checked" : "Unchecked"))
            .imageScale(.large)
    }
}
