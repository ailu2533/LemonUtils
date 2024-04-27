//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/22.
//

import SwiftUI

@Observable
public class TextItem: MovableObject, Identifiable, Equatable {
    @ObservationIgnored public let id = UUID()
    public var text: String
    public var color: Color
    // TODO: 默认字体名
    public var fontName: String = CustomFont.fonts.first?.postscriptName ?? ""
    public var fontSize: CGFloat = 20.0

    public init(text: String, pos: CGPoint = .zero, color: Color = .primary) {
        self.text = text
        self.color = color
        super.init()
        super.pos = pos
    }

    public static func == (lhs: TextItem, rhs: TextItem) -> Bool {
        return lhs.id == rhs.id
    }
}

extension TextItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public struct ItemView<Item: MovableObject, Content: View>: View {
    @Bindable var item: Item

    private var content: (Item) -> Content
    private var selected: Bool
    private var deleteCallback: (Item) -> Void
    private var editCallback: (Item) -> Void

    public init(textItem: Item, selected: Bool, deleteCallback: @escaping (Item) -> Void, editCallback: @escaping (Item) -> Void, content: @escaping (Item) -> Content) {
        item = textItem
        self.selected = selected
        self.deleteCallback = deleteCallback
        self.editCallback = editCallback
        self.content = content
    }

    public init(textItem: Item, selected: Bool, content: @escaping (Item) -> Content) {
        item = textItem
        self.selected = selected
        deleteCallback = { _ in }
        editCallback = { _ in }
        self.content = content
    }

    public var body: some View {
        content(item)
            .padding(8)
            .background {
                Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                    .opacity(selected ? 0.3 : 0)
                    .overlay(alignment: .topTrailing) {
                        Button(action: {
                            editCallback(item)
                        }, label: {
                            Image(systemName: "pencil.tip")
                        })
                        .frame(width: 16, height: 16)
                        .offset(x: 16, y: -16)
                        .opacity(selected ? 1 : 0)
                        .buttonStyle(BigButtonStyle())
                    }
                    .overlay(alignment: .topLeading) {
                        Button(role: .destructive, action: {
                            deleteCallback(item)
                        }, label: {
                            Image(systemName: "xmark")
                        })
                        .frame(width: 16, height: 16)
                        .offset(x: -16, y: -16)

                        .opacity(selected ? 1 : 0)
                        .buttonStyle(BigButtonStyle())
                    }
            }
            .position(x: item.pos.x, y: item.pos.y)
            .offset(x: item.offset.x, y: item.offset.y)
            .gesture(DragGesture()
                .onChanged({ value in
                    item.onDragChanged(translation: value.translation)
                }).onEnded({ _ in
                    item.onDragEnd()
                })
            )
    }
}

#Preview("2") {
    RoundedRectangle(cornerRadius: 8)
        .fill(.blue.opacity(0.3))
        .frame(height: 400)
        .overlay {
            ItemView(textItem: TextItem(text: "hello world"), selected: true) { item in
                Text(item.text)
            }
        }
}

class MovableImage: MovableObject {
    var imageName: String = "plus"
}

#Preview("3") {
    RoundedRectangle(cornerRadius: 8)
        .fill(.blue.opacity(0.3))
        .frame(height: 400)
        .overlay {
            ItemView(textItem: MovableImage(), selected: true) { item in
                Image(systemName: item.imageName)
            }
        }
}
