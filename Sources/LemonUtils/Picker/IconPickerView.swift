//
//  IconPicker.swift
//  MyHabit
//
//  Created by ailu on 2024/3/25.
//

import Collections
import SwiftUI

public struct SingleIconSetIconPickerView: View {
    @Binding private var selectedIcon: String
    private let icons: [String]
    private let columns = [GridItem(.adaptive(minimum: 70))]
    var tapCallback: (String) -> Void

    public init(selectedImg: Binding<String>, icons: [String], tapCallback: @escaping (String) -> Void = { _ in }) {
        _selectedIcon = selectedImg
        self.icons = icons
        self.tapCallback = tapCallback
    }

    public var body: some View {
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
                                tapCallback(image)
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
            } itemToSelectedValue: { $0 }
                .padding(.horizontal)
                .padding(.top, 40)

            SingleIconSetIconPickerView(selectedImg: $selectedIcon, icons: iconSets[selectedIconSetName] ?? [])
                .padding(.horizontal)
        }
        .onAppear {
            selectedIconSetName = selectedIconSetName.isEmpty ? iconSets.keys.first ?? "" : selectedIconSetName
        }
        .navigationTitle("选择图标")
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
            } itemToSelectedValue: {
                $0
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

struct GeneralColor: View {
    let pureColor: String?
    let gradientColor: [String]?

    /// 初始化一个具有纯色或渐变色的视图
    /// - Parameters:
    ///   - pureColor: 单一颜色的十六进制字符串
    ///   - gradientColor: 渐变颜色的十六进制字符串数组
    init(pureColor: String? = nil, gradientColor: [String]? = nil) {
        self.pureColor = pureColor
        self.gradientColor = gradientColor
    }

    var body: some View {
        Circle()
            .fill(
                AnyShapeStyle(makeColorFill())
            )
    }

    /// 根据提供的颜色信息创建填充样式
    private func makeColorFill() -> any ShapeStyle {
        if let pureColor = pureColor {
            return Color(hex: pureColor) ?? Color.clear
        } else if let gradientColors = gradientColor {
            let colors = gradientColors.compactMap { Color(hex: $0) }
            return LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
        } else {
            return Color.clear
        }
    }
}
