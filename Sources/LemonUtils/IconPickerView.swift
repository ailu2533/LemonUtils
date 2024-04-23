//
//  IconPicker.swift
//  MyHabit
//
//  Created by ailu on 2024/3/25.
//

import SwiftUI

import Collections

struct SingleIconSetIconPickerView: View {
    // 被选择的icon
    @Binding private var selectedIcon: String
    // icon名称数组，从这里面选择icon
    private let icons: [String]

    private let columns = Array(repeating: GridItem(.flexible(minimum: 40, maximum: 70)), count: 4)

    init(selectedImg: Binding<String>, icons: [String]) {
        _selectedIcon = selectedImg
        self.icons = icons
    }

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, content: {
                    ForEach(icons, id: \.self) {
                        image in
                        IconView(iconName: image)
                            .overlay(content: {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(selectedIcon == image ? .blue.opacity(0.4) : .clear, style: StrokeStyle(lineWidth: 2, dash: [3]))
                                    .aspectRatio(contentMode: .fill)
                                    .padding(2)
                            })
                            .onTapGesture {
//                                withAnimation(.snappy) {
                                selectedIcon = image
//                                }
                            }
                    }
                })
            }
        }
    }
}

public struct IconPickerView: View {
    @Environment(\.dismiss) private var dismiss

    // 只有点保存的时候，才修改这个
    @Binding var selectedIcon: String

    // 当前选择的icon
    @State private var select: String = ""
    // 当前选择的icon集名称
    @State private var selectedIconSetName: String = ""

    // icon set
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
            }.padding()

            SingleIconSetIconPickerView(selectedImg: $select, icons: iconSets[selectedIconSetName] ?? [])
        }
        .onAppear {
            if selectedIconSetName.isEmpty && !iconSets.isEmpty {
                selectedIconSetName = iconSets.keys.first!
            }

            if select.isEmpty && !selectedIconSetName.isEmpty {
                select = iconSets[selectedIconSetName]?.first ?? ""
            }
        }
        .onChange(of: selectedIconSetName) { _, newIconSetName in
            select = iconSets[newIconSetName]?.first ?? ""
        }
        .navigationTitle("选择图标")
        .toolbar(content: {
            ToolbarItem {
                Button(action: {
                    selectedIcon = select
                    dismiss()
                }, label: {
                    Text("确定")
                })
            }
        })
    }
}

public struct IconPickerViewNew: View {
    @Environment(\.dismiss) private var dismiss

    // 只有点保存的时候，才修改这个
    @Binding var selectedIcon: String

    // 当前选择的icon集名称
    @State private var selectedIconSetName: String = ""

    // icon set
    let iconSets: OrderedDictionary<String, [String]>

    public init(selectedIcon: Binding<String>, iconSets: OrderedDictionary<String, [String]>) {
        self.iconSets = iconSets
        _selectedIcon = selectedIcon
    }

    public var body: some View {
        VStack {

            HorizontalSelectionPicker(items: iconSets.keys.elements, selectedItem: $selectedIconSetName) {
                Text($0)
            }.padding(.horizontal)
            
            SingleIconSetIconPickerView(selectedImg: _selectedIcon, icons: iconSets[selectedIconSetName] ?? [])
        }
        .onAppear {
            if selectedIconSetName.isEmpty && !iconSets.isEmpty {
                selectedIconSetName = iconSets.keys.first!
            }

            if selectedIcon.isEmpty && !selectedIconSetName.isEmpty {
                selectedIcon = iconSets[selectedIconSetName]?.first ?? ""
            }
        }
        .toolbar(content: {
            ToolbarItem {
                Button(action: {
                    dismiss()
                }, label: {
                    Label("关闭", systemImage: "xmark.circle")
                })
            }
        })
    }
}

private struct IconView: View {
    private let iconName: String
    private let width: CGFloat
    private let heigth: CGFloat

    init(iconName: String, width: CGFloat = 60, heigth: CGFloat = 60) {
        self.iconName = iconName
        self.width = width
        self.heigth = heigth
    }

    var body: some View {
        Image.thumbnailImageFixHeight(iconName, height: Int(heigth))

            .padding(6)
    }
}
