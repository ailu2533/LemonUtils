//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/22.
//

import SwiftUI

@Observable
public final class TextItem: MovableObject {
//    public var backgroundText: String?
    public var text: String
    public var color: Color
    public var fontName: String?
    public var fontSize: CGFloat = 20.0
    public var editable: Bool

    enum CodingKeys: String, CodingKey {
        case backgroundText
        case text
        case color
        case fontName
        case fontSize
        case editable
    }

    public init(text: String, pos: CGPoint = .zero, color: Color = .primary, fontName: String? = nil, fontSize: CGFloat = 20, rotationDegree: CGFloat = .zero, editable: Bool = true) {
//        backgroundText = backgroundText
        self.text = text
        self.color = color
        if let fontName {
            self.fontName = fontName
        }
        self.fontSize = fontSize
        self.editable = editable
        super.init(pos: pos, rotationDegree: rotationDegree)
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        backgroundText = try container.decodeIfPresent(String.self, forKey: .backgroundText)
        text = try container.decode(String.self, forKey: .text)
        color = try container.decode(Color.self, forKey: .color)
        fontName = try container.decodeIfPresent(String.self, forKey: .fontName)
        fontSize = try container.decode(CGFloat.self, forKey: .fontSize)
        editable = try container.decode(Bool.self, forKey: .editable)
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encodeIfPresent(backgroundText, forKey: .backgroundText)
        try container.encode(text, forKey: .text)
        try container.encode(color, forKey: .color)
        try container.encodeIfPresent(fontName, forKey: .fontName)
        try container.encode(fontSize, forKey: .fontSize)
        try container.encode(editable, forKey: .editable)
        try super.encode(to: encoder)
    }

    public static func == (lhs: TextItem, rhs: TextItem) -> Bool {
        return lhs.text == rhs.text && lhs.color == rhs.color && lhs.fontName == rhs.fontName && lhs.fontSize == rhs.fontSize && lhs.editable == rhs.editable
    }

    @ViewBuilder
    public func view() -> some View {
        Text(text)
            .foregroundStyle(color)
            .font(fontName == nil ? .system(size: fontSize) : .custom(fontName!, size: fontSize))
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
