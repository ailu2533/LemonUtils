//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/22.
//

import SwiftUI

@Observable
public class TextItem: Identifiable, Equatable {
    @ObservationIgnored public let id = UUID()
    public var text: String
    public var color: Color
    // TODO: 默认字体名
    public var fontName: String = "Milky-Coffee"
    public var fontSize: CGFloat = 30.0
    public var rotationDegree: CGFloat = 0.0
    var pos: CGPoint

    var offset: CGPoint = .zero

    public init(text: String, pos: CGPoint = .zero, color: Color = .primary) {
        self.text = text
        self.pos = pos
        self.color = color
    }

    public static func == (lhs: TextItem, rhs: TextItem) -> Bool {
        return lhs.id == rhs.id
    }

    func onDragChanged(translation: CGSize) {
        offset = .init(x: translation.width, y: translation.height)
    }

    func onDragEnd() {
        pos = .init(x: pos.x + offset.x, y: pos.y + offset.y)
        offset = .zero
    }

    public func view() -> some View {
        return Text(text)
            .foregroundStyle(Color(color))
            .font(.custom(fontName, size: fontSize))
            .rotationEffect(.degrees(rotationDegree))
    }
}

public struct TextItemView: View {
    @Bindable var textItem: TextItem
    private var selected: Bool
    private var deleteCallback: (TextItem) -> Void
    private var editCallback: (TextItem) -> Void

    public init(textItem: TextItem, selected: Bool, deleteCallback: @escaping (TextItem) -> Void, editCallback: @escaping (TextItem) -> Void) {
        self.textItem = textItem
        self.selected = selected
        self.deleteCallback = deleteCallback
        self.editCallback = editCallback
    }

    public init(textItem: TextItem, selected: Bool) {
        self.textItem = textItem
        self.selected = selected
        deleteCallback = { _ in }
        editCallback = { _ in }
    }

    public var body: some View {
        textItem.view()
            .padding(8)
            .background {
                Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                    .opacity(selected ? 0.3 : 0)
                    .overlay(alignment: .topTrailing) {
                        Button(action: {
                            editCallback(textItem)
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
                            deleteCallback(textItem)
                        }, label: {
                            Image(systemName: "xmark")
                        })
                        .frame(width: 16, height: 16)
                        .offset(x: -16, y: -16)

                        .opacity(selected ? 1 : 0)
                        .buttonStyle(BigButtonStyle())
                    }
            }
            .position(x: textItem.pos.x, y: textItem.pos.y)
            .offset(x: textItem.offset.x, y: textItem.offset.y)
            .gesture(DragGesture()
                .onChanged({ value in
                    textItem.onDragChanged(translation: value.translation)
                }).onEnded({ _ in
                    textItem.onDragEnd()
                })
            )
    }
}

#Preview {
    RoundedRectangle(cornerRadius: 8)
        .fill(.blue.opacity(0.3))
        .frame(height: 400)
        .overlay {
            TextItemView(textItem: .init(text: "hello"), selected: true) {
                print("delete \($0.id)")
            } editCallback: {
                print("edit \($0.id)")
            }
        }
}
