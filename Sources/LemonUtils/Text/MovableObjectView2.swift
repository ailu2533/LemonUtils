//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/5/5.
//

import SwiftUI

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

public struct MovableObjectViewConfig {
    var parentSize: CGSize?
    var enable: Bool
    var deleteCallback: (MovableObject) -> Void
    var editCallback: (MovableObject) -> Void
    var tapCallback: (MovableObject) -> Void = { _ in }

    public init(parentSize: CGSize? = nil, enable: Bool = true, deleteCallback: @escaping (MovableObject) -> Void = { _ in }, editCallback: @escaping (MovableObject) -> Void = { _ in }) {
        self.parentSize = parentSize
        self.enable = enable
        self.deleteCallback = deleteCallback
        self.editCallback = editCallback
    }
}

public struct MovableObjectView2<Item: MovableObject, Content: View>: View {
    var item: Item
    @Binding var selection: MovableObject?
    private var config: MovableObjectViewConfig
    var content: (Item) -> Content

    @State private var viewSize: CGSize = .zero
    @GestureState private var angle: Angle = .zero

    var selected: Bool {
        selection?.id == item.id
    }

    var showControl: Bool {
        return selected && config.enable
    }

    public init(item: Item, selection: Binding<MovableObject?>, config: MovableObjectViewConfig, content: @escaping (Item) -> Content) {
        self.item = item
        self.config = config
        self.content = content
        _selection = selection
    }

    private let id = UUID()

    public func calculateRotation(value: DragGesture.Value) -> Angle {
        let centerX = viewSize.width / 2
        let centerY = viewSize.height / 2
        let startVector = CGVector(dx: value.startLocation.x - centerX, dy: value.startLocation.y - centerY)
        let endVector = CGVector(dx: value.location.x - centerX, dy: value.location.y - centerY)
        let angleDifference = atan2(endVector.dy, endVector.dx) - atan2(startVector.dy, startVector.dx)
        let rotation = Angle(radians: Double(angleDifference))

        return rotation
    }

    var topCorner: some View {
        return Rectangle()
            .stroke(style: StrokeStyle(lineWidth: 2, dash: [4]))
            .shadow(color: Color(.black), radius: 0.1)
            .foregroundStyle(Color(.systemBackground))
            .shadow(radius: 10)
            .opacity(showControl ? 1 : 0)
            .readSize(callback: {
                viewSize = $0
            })

            .overlay(alignment: .center) {
                Button(action: {
                    config.editCallback(item)
                }, label: {
                    Image(systemName: "pencil.tip")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12, height: 12)
                })
                .offset(x: viewSize.width / 2 + 10, y: -viewSize.height / 2 - 10)
                .opacity(showControl ? 1 : 0)
                .buttonStyle(CircleButtonStyle2())
            }
            .overlay(alignment: .center) {
                Button(role: .destructive, action: {
                    config.deleteCallback(item)
                }, label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12, height: 12)
                })
                .offset(x: -viewSize.width / 2 - 10, y: -viewSize.height / 2 - 10)
                .opacity(showControl ? 1 : 0)
                .buttonStyle(CircleButtonStyle2())
            }

            .background(alignment: .center) {
                let dragGesture = DragGesture(coordinateSpace: .named(id))
                    .updating($angle, body: { value, state, _ in
                        state = calculateRotation(value: value)
                    })
                    .onEnded({ value in
                        item.rotationDegree = item.rotationDegree + calculateRotation(value: value).degrees
                    })

                Image(systemName: "arrow.triangle.2.circlepath")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 12)
                    .padding(5)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 1)
                    .opacity(showControl ? 1 : 0)
                    .offset(x: viewSize.width / 2 + 10, y: viewSize.height / 2 + 10)
                    .if(config.enable) { view in
                        view.gesture(dragGesture)
                    }
            }
    }

    public var body: some View {
        let dragDesture = DragGesture()
            .onChanged({ value in
                let x = value.location.x
                let y = value.location.y
                if let parentSize = config.parentSize {
                    if x < 0 || y < 0 || x > parentSize.width || y > parentSize.height {
                        return
                    }
                }

                item.onDragChanged(translation: value.translation)
            }).onEnded({ _ in
                item.onDragEnd()
            })

        content(item)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background {
                topCorner
            }
            .rotationEffect(angle + Angle(degrees: item.rotationDegree))
            .coordinateSpace(name: id)
            .position(x: item.pos.x, y: item.pos.y)
            .offset(x: item.offset.x, y: item.offset.y)
            .if(config.enable) { view in
                view.gesture(dragDesture)
            }
            .onTapGesture {
                config.tapCallback(item)
                selection = item
            }
    }
}
