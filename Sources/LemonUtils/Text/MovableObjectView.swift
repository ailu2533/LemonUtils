//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/27.
//

import SwiftUI

public struct MovableObjectView<Item: MovableObject, Content: View>: View {
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
                            Image(systemName: "pencil")
                        })
                        .frame(width: 16, height: 16)
                        .offset(x: 16, y: -16)
                        .opacity(selected ? 1 : 0)
                        .buttonStyle(CircleButtonStyle())
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
                        .buttonStyle(CircleButtonStyle())
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
