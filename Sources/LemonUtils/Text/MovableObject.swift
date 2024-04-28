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
