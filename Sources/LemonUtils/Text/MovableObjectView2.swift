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
    @ViewBuilder
    public func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

public struct ViewSizeKey: PreferenceKey {
    public typealias Value = Anchor<CGPoint>?
    public static var defaultValue: Value = nil

    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

public struct MovableObjectViewConfig {
    public var parentSize: CGSize?
    public var enable: Bool
    public var deleteCallback: (MovableObject) -> Void
    public var editCallback: (MovableObject) -> Void
    public var tapCallback: (MovableObject) -> Void = { _ in }
//    public var coordinateSpaceId: UUID

    public init(parentSize: CGSize? = nil, enable: Bool = true, deleteCallback: @escaping (MovableObject) -> Void = { _ in }, editCallback: @escaping (MovableObject) -> Void = { _ in }) {
        self.parentSize = parentSize
        self.enable = enable
        self.deleteCallback = deleteCallback
        self.editCallback = editCallback
    }
}

public struct MovableObjectView2<Item: MovableObject, Content: View>: View {
    var item: Item
    @Binding var selection: UUID?
    private var config: MovableObjectViewConfig
    var content: (Item) -> Content

    @State private var viewSize: CGSize = .zero
    @State private var lastFeedbackAngle: Double = 0
    @State private var rotateTrigger = 0
    @State private var currentAngle: Angle = .zero
    @State private var snapAngle: Angle = .zero
    let offset: CGFloat = 20

    @State private var isDragging = false
    private let id = UUID()

    var selected: Bool {
        selection == item.id
    }

    var showControl: Bool {
        return selected && config.enable
    }

    public init(item: Item, selection: Binding<UUID?>, config: MovableObjectViewConfig, content: @escaping (Item) -> Content) {
        self.item = item
        self.config = config
        self.content = content
        _selection = selection
    }

    public func calculateRotation(value: DragGesture.Value) -> Angle {
        let centerX = viewSize.width / 2
        let centerY = viewSize.height / 2
        let startVector = CGVector(dx: value.startLocation.x - centerX, dy: value.startLocation.y - centerY)
        let endVector = CGVector(dx: value.location.x - centerX, dy: value.location.y - centerY)
        let angleDifference = atan2(endVector.dy, endVector.dx) - atan2(startVector.dy, startVector.dx)
        let rotation = Angle(radians: Double(angleDifference))

        return rotation
    }

    var editButton: some View {
        Button(action: {
            config.editCallback(item)
        }, label: {
            Image(systemName: "pencil.tip")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12, height: 12)
        })
        .offset(x: offset, y: -offset)
        .opacity(showControl ? 1 : 0)
        .buttonStyle(CircleButtonStyle2())
    }

    var deleteButton: some View {
        Button(role: .destructive, action: {
            config.deleteCallback(item)
        }, label: {
            Image(systemName: "xmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12, height: 12)
        })
        .offset(x: -offset, y: -offset)
        .opacity(showControl ? 1 : 0)
        .buttonStyle(CircleButtonStyle2())
    }

    var rotationHandler: some View {
        let dragGesture = DragGesture(coordinateSpace: .named(id))
            .onChanged { value in
                let rotation = calculateRotation(value: value)
                let totalRotation = snapAngle + rotation
                
                let degrees = totalRotation.degrees.truncatingRemainder(dividingBy: 360)
                let normalizedAngle = degrees < 0 ? degrees + 360 : degrees
                
                // 检查是否接近 0 度
                if abs(normalizedAngle - 0) <= snapThreshold || abs(normalizedAngle - 360) <= snapThreshold {
                    // 如果接近 0 度且旋转量小，保持当前角度
                    if abs(rotation.degrees) <= smallRotationThreshold {
                        return
                    }
                    // 否则，吸附到 0 度
                    currentAngle = Angle(degrees: 0) - Angle(degrees: item.rotationDegree)
                } else {
                    // 不接近 0 度，使用实际旋转角度
                    currentAngle = totalRotation
                }
                
                // 触感反馈逻辑
                if abs(normalizedAngle - 0) <= 2 {
                    rotateTrigger += 1
//                    lastFeedbackAngle = normalizedAngle
                }
            }
            .onEnded { value in
                // 直接使用最终旋转角度，不进行吸附
                let finalRotation = snapAngle + calculateRotation(value: value)
                item.rotationDegree += finalRotation.degrees
                currentAngle = .zero
                snapAngle = .zero
            }

        return Image(systemName: "arrow.triangle.2.circlepath")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 12, height: 12)
            .padding(5)
            .background(isDragging ? Color.orange : Color.white)
            .clipShape(Circle())
            .shadow(radius: 1)
            .frame(width: 50, height: 50)
            .contentShape(Rectangle())
            .opacity(showControl ? 1 : 0)
            .offset(y: 2 * offset)
            .if(config.enable) { view in
                view.gesture(dragGesture)
            }
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
            .overlay(alignment: .topTrailing) {
                editButton
            }
            .overlay(alignment: .topLeading) {
                deleteButton
            }
            .background(alignment: .bottom) {
                rotationHandler
            }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged({ value in
                let x = value.location.x
                let y = value.location.y
                if let parentSize = config.parentSize {
                    if x < 0 || y < 0 || x > parentSize.width || y > parentSize.height {
                        return
                    }
                }
                print(value.location)

                item.onDragChanged(translation: value.translation)
            }).onEnded({ _ in
                item.onDragEnd()
            })
    }

    @State private var width = 100.0
    @State private var height = 100.0

    let snapThreshold: Double = 5 // 吸附阈值，单位为度
    let smallRotationThreshold: Double = 2 // 小角度旋转阈值，单位为度

    public var body: some View {
        content(item)
            .frame(width: width, height: height)
            .padding()
            .modifier(DraggableModifier(width: $width, height: $height, hasBorder: true))
            .anchorPreference(key: ViewSizeKey.self, value: .center, transform: { $0 })
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .contentShape(Rectangle())
            .background {
                topCorner
            }
            .rotationEffect(currentAngle + Angle(degrees: item.rotationDegree))
            .coordinateSpace(name: id)
            .position(x: item.pos.x, y: item.pos.y)
            .offset(x: item.offset.x, y: item.offset.y)
            .if(config.enable && selection == item.id) { view in
                view.gesture(dragGesture)
            }
            .onTapGesture {
                config.tapCallback(item)
                selection = item.id
            }
            .zIndex(selection == item.id ? 1 : 0)
            .sensoryFeedback(.impact(weight: .light), trigger: rotateTrigger)
    }
}
