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
            LazyHGrid(rows: rows) {
                ForEach(colorSet, id: \.self) { colorHex in
                    let color = Color(hex: colorHex) ?? defaultColor
                    Circle()
                        .fill(color)
                        .scaleEffect(selectedColor == colorHex ? 0.8 : 1)
                        .overlay(Circle().stroke(color, lineWidth: selectedColor == colorHex ? 2 : 0))
                        .onTapGesture {
                            selectedColor = colorHex
                        }
                        .padding(2)
                }
            }
            .sensoryFeedback(.selection, trigger: selectedColor)
        }
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
    }
}

public struct ColorPickerView2: View {
    @Binding private var selectedColor: String
    private let colorSet: [String]
    private let columns = [GridItem(.adaptive(minimum: 40, maximum: 60))]
    private let defaultColor = Color.blue

    public init(selection: Binding<String>, colorSet: [String]) {
        _selectedColor = selection
        self.colorSet = colorSet
    }

    public var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(colorSet, id: \.self) { colorHex in
                        let color = Color(hex: colorHex) ?? defaultColor
                        Circle()
                            .fill(color)
                            .scaleEffect(selectedColor == colorHex ? 0.8 : 1)
                            .overlay(Circle().stroke(color, lineWidth: selectedColor == colorHex ? 2 : 0))
                            .onTapGesture {
                                selectedColor = colorHex
                            }
                            .padding(2)
                    }
                }
                .sensoryFeedback(.selection, trigger: selectedColor)
            }
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
        }.padding(.horizontal)
            .padding(.top)
    }
}

struct ColorPicker_Preview: View {
    @State private var selectedColor = ColorSets.morandiColors[0]

    var body: some View {
        VStack {
            DisclosureGroup {
                ColorPickerView(selection: $selectedColor, colorSet: ColorSets.morandiColors)
                    .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
            } label: {
                Circle()
                    .fill(Color(hex: selectedColor) ?? .gray)
                    .frame(width: 50, height: 50)
            }
        }
    }
}

struct ColorPicker_Preview_Previews: PreviewProvider {
    static var previews: some View {
        ColorPicker_Preview()
            .padding()
    }
}
