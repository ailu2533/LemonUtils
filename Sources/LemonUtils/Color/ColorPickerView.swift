//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/18.
//

import SwiftUI

public struct ColorPickerView: View {
    @Binding private var selectedColor: String
    private let colorSet: [String]
    private let rows = Array(repeating: GridItem(.fixed(50)), count: 4)

    private let defaultColor = Color.blue

    public init(selection: Binding<String>, colorSet: [String]) {
        _selectedColor = selection
        self.colorSet = colorSet
    }

    public var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows, content: {
                ForEach(colorSet, id: \.self) { colorHex in

                    let c = Color(hex: colorHex) ?? defaultColor
                    Circle().fill(c)
                        .scaleEffect(colorHex == selectedColor ? 0.8 : 1)
                        .overlay {
                            if selectedColor == colorHex {
                                Circle().stroke(c, lineWidth: 2)
                            }
                        }
                        .onTapGesture {
                            selectedColor = colorHex
                        }
                        .padding(2)
                }
            })
        }
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
    }
}

struct ColorPicker_Preview: View {
    @State private var selectedColor = ColorSets.morandiColors[0]

    var body: some View {
        VStack {
            DisclosureGroup(
                content: {
                    ColorPickerView(selection: $selectedColor, colorSet: ColorSets.morandiColors)
                        .listRowInsets(.init(top: 16, leading: 16, bottom: 16, trailing: 16))
                },
                label: {
                    Circle()
                        .fill(Color(hex: selectedColor)!)
                        .frame(width: 50, height: 50)
                }
            )
        }
    }
}

#Preview {
    Section("") {
        ColorPicker_Preview()
            .padding()
    }
}
