//
//  IconPicker.swift
//  MyHabit
//
//  Created by ailu on 2024/3/25.
//

import Collections
import SwiftUI

struct SingleIconSetIconPickerView: View {
    @Binding private var selectedIcon: String
    private let icons: [String]
    private let columns = [GridItem(.adaptive(minimum: 70))]

    init(selectedImg: Binding<String>, icons: [String]) {
        _selectedIcon = selectedImg
        self.icons = icons
    }

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(icons, id: \.self) { image in
                        IconView(iconName: image)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(selectedIcon == image ? .blue.opacity(0.4) : .clear, style: StrokeStyle(lineWidth: 2, dash: [3]))
                                    .aspectRatio(contentMode: .fill)
                                    .padding(2)
                            )
                            .onTapGesture {
                                selectedIcon = image
                            }
                    }
                }
                .sensoryFeedback(.selection, trigger: selectedIcon)
                .padding(.horizontal)
            }
        }
    }
}

public struct IconPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedIcon: String
    @State private var select: String = ""
    @State private var selectedIconSetName: String = ""

    let iconSets: OrderedDictionary<String, [String]>

    public init(selectedIcon: Binding<String>, iconSets: OrderedDictionary<String, [String]>) {
        self.iconSets = iconSets
        _selectedIcon = selectedIcon
    }

    public var body: some View {
        VStack {
            IconView(iconName: select)
            HorizontalSelectionPicker(items: iconSets.keys.elements, selectedItem: $selectedIconSetName) {
                Text($0)
            }
            .padding()

            SingleIconSetIconPickerView(selectedImg: $select, icons: iconSets[selectedIconSetName] ?? [])
                .padding(.horizontal)
        }
        .onAppear {
            selectedIconSetName = selectedIconSetName.isEmpty ? iconSets.keys.first ?? "" : selectedIconSetName
            select = select.isEmpty ? iconSets[selectedIconSetName]?.first ?? "" : select
        }
        .onChange(of: selectedIconSetName) { _ in
            select = iconSets[selectedIconSetName]?.first ?? ""
        }
        .navigationTitle("选择图标")
        .toolbar {
            ToolbarItem {
                Button("确定") {
                    selectedIcon = select
                    dismiss()
                }
            }
        }
    }
}

public struct IconPickerViewNew: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedIcon: String
    @State private var selectedIconSetName: String = ""

    let iconSets: OrderedDictionary<String, [String]>

    public init(selectedIcon: Binding<String>, iconSets: OrderedDictionary<String, [String]>) {
        self.iconSets = iconSets
        _selectedIcon = selectedIcon
    }

    public var body: some View {
        VStack {
            HorizontalSelectionPicker(items: iconSets.keys.elements, selectedItem: $selectedIconSetName) {
                Text($0)
            }
            .padding(.horizontal)

            SingleIconSetIconPickerView(selectedImg: _selectedIcon, icons: iconSets[selectedIconSetName] ?? [])
                .padding(.horizontal)
        }
        .onAppear {
            selectedIconSetName = selectedIconSetName.isEmpty ? iconSets.keys.first ?? "" : selectedIconSetName
            selectedIcon = selectedIcon.isEmpty ? iconSets[selectedIconSetName]?.first ?? "" : selectedIcon
        }
        .toolbar {
            ToolbarItem {
                Button(action: {
                    dismiss()
                }, label: {
                    Label("关闭", systemImage: "xmark.circle")
                })
            }
        }
    }
}

private struct IconView: View {
    private let iconName: String
    private let width: CGFloat
    private let height: CGFloat

    init(iconName: String, width: CGFloat = 60, height: CGFloat = 60) {
        self.iconName = iconName
        self.width = width
        self.height = height
    }

    var body: some View {
        Image(iconName)
            .resizable()
            .frame(width: width, height: height)
            .padding(6)
    }
}
