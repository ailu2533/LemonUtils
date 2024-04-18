//
//  IconPicker.swift
//  MyHabit
//
//  Created by ailu on 2024/3/25.
//

import SwiftUI

import Collections

struct ImagePicker: View {
    // 被选择的图片
    @Binding private var selectedImage: String

    // 图片名称数组，从这里面选择图片
    private var icons: [String]

    private let uuid = UUID().uuidString

    let columns = Array(repeating: GridItem(.flexible(minimum: 40, maximum: 70)), count: 4)

    init(selectedImg: Binding<String>, icons: [String]) {
        _selectedImage = selectedImg
        self.icons = icons
    }

    @Namespace private var ns

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, content: {
                    ForEach(icons, id: \.self) {
                        image in
                        ImageView(imageName: image)
                            .overlay(content: {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(selectedImage == image ? .red : .clear, lineWidth: 2)
                                    .aspectRatio(contentMode: .fill)
                                    .padding(2)
                            })
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    selectedImage = image
                                }
                            }
                    }
                })
            }.padding()
        }
    }
}

public struct IconPickerView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var selectedImage: String

    @State private var select: String

    let defaultPic = "Artboard 1"

    // 图片集
    let imageSets: OrderedDictionary<String, [String]>

    // 当前选择的图片集名称
    @State private var iconSetName: String

    public init(selectedImage: Binding<String>, imageSets: OrderedDictionary<String, [String]>) {
        if selectedImage.wrappedValue == "" {
            selectedImage.wrappedValue = defaultPic
        }
        self.imageSets = imageSets

        iconSetName = imageSets.keys.first!

        _selectedImage = selectedImage

        select = selectedImage.wrappedValue
    }

    public var body: some View {
        VStack {
            ImageView(imageName: select)

            HorizontalSelectionPicker(items: imageSets.keys.elements, selectedItem: $iconSetName) {
                Text($0)
            }.padding()
            ImagePicker(selectedImg: $select, icons: imageSets[iconSetName] ?? [])
        }.onChange(of: iconSetName) { _, newValue in
            select = imageSets[newValue]?.first ?? ""
        }
        .navigationTitle("选择图标")
        .toolbar(content: {
            ToolbarItem {
                Button(action: {
                    selectedImage = select
                    dismiss()
                }, label: {
                    Text("确定")
                })
            }
        })
    }
}

private struct ImageView: View {
    private let imageName: String
    private let width: CGFloat
    private let heigth: CGFloat

    init(imageName: String, width: CGFloat = 60, heigth: CGFloat = 60) {
        self.imageName = imageName
        self.width = width
        self.heigth = heigth
    }

    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: heigth, height: heigth)
            .scaledToFit()
            .padding(6)
    }
}

