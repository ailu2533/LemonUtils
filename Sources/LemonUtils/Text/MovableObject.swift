//
//  File.swift
//
//
//  Created by ailu on 2024/4/27.
//

import Foundation

@Observable
open class MovableObject {
    public var rotationDegree: CGFloat = .zero
    var offset: CGPoint = .zero
    public var pos: CGPoint = .zero

    public init(pos: CGPoint) {
        self.pos = pos
    }

    func onDragChanged(translation: CGSize) {
        offset = .init(x: translation.width, y: translation.height)
    }

    func onDragEnd() {
        pos = .init(x: pos.x + offset.x, y: pos.y + offset.y)
        offset = .zero
    }
}

public protocol Movable {
    func onDragChanged(translation: CGSize)
    func onDragEnd()
    func position() -> CGPoint
    func offset() -> CGSize
    func getRotationDegree() -> CGFloat
    func setRotationDegree(_ degree: CGFloat)
}

@Observable
open class MovableObject2: Movable, Codable {
    public var rotationDegree: CGFloat = .zero
    var offset_: CGSize = .zero
    public var pos: CGPoint = .zero

    public init(pos: CGPoint) {
        self.pos = pos
    }

    public func onDragChanged(translation: CGSize) {
        offset_ = translation
    }

    public func onDragEnd() {
        pos = .init(x: pos.x + offset_.width, y: pos.y + offset_.height)
        offset_ = .zero
    }

    public func position() -> CGPoint {
        return pos
    }

    public func offset() -> CGSize {
        return offset_
    }

    public func setRotationDegree(_ degree: CGFloat) {
        rotationDegree = degree
    }

    public func getRotationDegree() -> CGFloat {
        return rotationDegree
    }

    private enum CodingKeys: String, CodingKey {
        case rotationDegree
        case offset_
        case pos
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rotationDegree = try container.decode(CGFloat.self, forKey: .rotationDegree)
        offset_ = try container.decode(CGSize.self, forKey: .offset_)
        pos = try container.decode(CGPoint.self, forKey: .pos)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(rotationDegree, forKey: .rotationDegree)
        try container.encode(offset_, forKey: .offset_)
        try container.encode(pos, forKey: .pos)
    }
}
