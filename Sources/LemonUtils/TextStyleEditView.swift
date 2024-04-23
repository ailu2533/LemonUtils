//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/23.
//

import SwiftUI

public struct TextStyleEditView: View {
    @Bindable var textItem: TextItem
    private var fontNames: [String]

    public init(textItem: TextItem, fontNames: [String] = [
        "Milky-Coffee", "RestaDisplayFont",
    ]) {
        self.textItem = textItem
        self.fontNames = fontNames
    }

    public var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.blue.opacity(0.2))
                .frame(height: 200)

                .overlay {
                    textItem.view()
                }
                .padding()

            Form {
                Slider(value: $textItem.fontSize, in: 10 ... 60, step: 1)
                Slider(value: $textItem.rotationDegree, in: -180 ... 180, step: 1)
                ColorPicker("颜色", selection: $textItem.color)
                TextField("文字", text: $textItem.text)

                Picker(selection: $textItem.fontName) {
                    ForEach(fontNames, id: \.self) { fontName in
                        Text(fontName).tag(fontName)
                    }

                } label: {
                    Text("字体")
                }.pickerStyle(.wheel)
            }
        }
    }
}
