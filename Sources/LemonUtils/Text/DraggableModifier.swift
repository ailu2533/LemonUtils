//
//  File.swift
//
//
//  Created by ailu on 2024/7/3.
//

import Foundation

import SwiftUI

enum nodePosition {
    case TopLeft, TopRight,

         BottomLeft, BottomRight
}

struct DraggableNode: View {
    @Binding var width: Double
    @Binding var height: Double
    let nodeType: nodePosition
    let aspectRatio: CGFloat

    var body: some View {
        Circle()
            .fill(Color.white)
            .stroke(Color.gray, style: .init(lineWidth: 1))
            .shadow(radius: 2)
            .frame(width: 10, height: 10)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        var newWidth = width
                        var newHeight = height

                        switch nodeType {
                        case .TopLeft:
                            newWidth = width - value.translation.width
                            newHeight = newWidth / aspectRatio
                        case .TopRight:
                            newWidth = width + value.translation.width
                            newHeight = newWidth / aspectRatio
                        case .BottomLeft:
                            newHeight = height + value.translation.height
                            newWidth = newHeight * aspectRatio
                        case .BottomRight:
                            newHeight = height + value.translation.height
                            newWidth = newHeight * aspectRatio
                        }

                        // 确保最短的边至少为10，并避免除以零的情况
                        let minDimension = max(1, min(newWidth, newHeight)) // 使用1作为最小值，避免除以零
                        if minDimension < 10 {
                            let scale = 10 / minDimension
                            newWidth = max(10, newWidth * scale)
                            newHeight = max(10, newHeight * scale)
                        }

                        // 额外的安全检查
                        width = max(10, newWidth)
                        height = max(10, newHeight)
                    }
            )
    }
}

struct DraggableModifier: ViewModifier {
    @Binding var width: Double
    @Binding var height: Double

    @State private var aspectRatio: CGFloat = 1.0

    let hasBorder: Bool

    func body(content: Content) -> some View {
        content
            .readSize(callback: { size in
                aspectRatio = size.width / size.height
            })

            .overlay {
                if hasBorder {
                    Rectangle()
                        .stroke(Color.cyan, style: StrokeStyle(lineWidth: 2))
                }
            }
//            .overlay {
//                DraggableNode(width: $width, height: $height, nodeType: .TopLeft, aspectRatio: aspectRatio)
//                    .position(CGPoint(x: 0, y: 0))
//
//                DraggableNode(width: $width, height: $height, nodeType: .TopRight, aspectRatio: aspectRatio)
//                    .position(CGPoint(x: width, y: 0))
//
//                DraggableNode(width: $width, height: $height, nodeType: .BottomLeft, aspectRatio: aspectRatio)
//                    .position(CGPoint(x: 0, y: height))
//
//                DraggableNode(width: $width, height: $height, nodeType: .BottomRight, aspectRatio: aspectRatio)
//                    .position(CGPoint(x: width, y: height))
//            }
            .overlay(alignment: .bottomTrailing) {
                DraggableNode(width: $width, height: $height, nodeType: .BottomRight, aspectRatio: aspectRatio)
            }
    }
}
