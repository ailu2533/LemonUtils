//
//  File.swift
//
//
//  Created by ailu on 2024/4/27.
//

import Foundation

@Observable
open class MovableObject {
    var offset: CGPoint = .zero
    public var pos: CGPoint = .zero
    public var rotationDegree: CGFloat = .zero

    public init(pos: CGPoint, rotationDegree: CGFloat = .zero) {
        self.pos = pos
        self.rotationDegree = rotationDegree
    }

    func onDragChanged(translation: CGSize) {
        offset = .init(x: translation.width, y: translation.height)
    }

    func onDragEnd() {
        pos = .init(x: pos.x + offset.x, y: pos.y + offset.y)
        offset = .zero
    }
}
