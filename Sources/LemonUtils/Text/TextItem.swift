//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/22.
//

import SwiftUI

@Observable
public class TextItem: MovableObject {
    public var text: String
    public var color: Color
    public var fontName: String = CustomFont.fonts.first?.postscriptName ?? ""
    public var fontSize: CGFloat = 20.0

    enum CodingKeys: String, CodingKey {
        case text
        case color
        case fontName
        case fontSize
    }

    public init(text: String, pos: CGPoint = .zero, color: Color = .primary, fontName: String? = nil) {
        self.text = text
        self.color = color
        if let fontName {
            self.fontName = fontName
        }
        super.init(pos: pos)
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        color = try container.decode(Color.self, forKey: .color)
        fontName = try container.decode(String.self, forKey: .fontName)
        fontSize = try container.decode(CGFloat.self, forKey: .fontSize)
//        super.init(pos: .zero) // Assuming `pos` is not part of Codable
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encode(color, forKey: .color)
        try container.encode(fontName, forKey: .fontName)
        try container.encode(fontSize, forKey: .fontSize)
        try super.encode(to: encoder)
    }

    public static func == (lhs: TextItem, rhs: TextItem) -> Bool {
        return lhs.text == rhs.text && lhs.color == rhs.color && lhs.fontName == rhs.fontName && lhs.fontSize == rhs.fontSize
    }

    public func view() -> some View {
        return Text(text)
            .foregroundStyle(color)
            .font(.custom(fontName, size: fontSize))
    }
}

// extension TextItem: Hashable {
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
// }

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
