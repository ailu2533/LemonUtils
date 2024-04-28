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

        super.init(pos: pos)
    }

    public static func == (lhs: TextItem, rhs: TextItem) -> Bool {
        return lhs.id == rhs.id
    }

    public func view() -> some View {
        return Text(text)
    }
}

extension TextItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

#Preview("2") {
    RoundedRectangle(cornerRadius: 8)
        .fill(.blue.opacity(0.3))
        .frame(height: 400)
        .overlay {
            MovableObjectView(textItem: TextItem(text: "hello world"), selected: true) { item in
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
            MovableObjectView(textItem: MovableImage(pos: .init(x: 100, y: 100)), selected: true) { item in
                Image(systemName: item.imageName)
            }
        }
}
