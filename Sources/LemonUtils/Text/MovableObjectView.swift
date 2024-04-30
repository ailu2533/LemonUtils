//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/27.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    }
}

public struct CircleButtonStyle2: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    public init() {
    }

    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(5)
            .background(Color.white)
            .clipShape(Circle())
            .shadow(radius: 1)
            .saturation(isEnabled ? 1 : 0)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

public struct MovableObjectView<Item: MovableObject, Content: View>: View {
    @Bindable var item: Item

    private var content: (Item) -> Content
    private var selected: Bool
    private var deleteCallback: (Item) -> Void
    private var editCallback: (Item) -> Void

    @State private var viewSize: CGSize = .zero
    @GestureState private var angle: Angle = .zero
    @State private var rotation: Angle = .zero

    public init(textItem: Item, selected: Bool, deleteCallback: @escaping (Item) -> Void, editCallback: @escaping (Item) -> Void, content: @escaping (Item) -> Content) {
        item = textItem
        self.selected = selected
        self.deleteCallback = deleteCallback
        self.editCallback = editCallback
        self.content = content
    }

    public init(textItem: Item, selected: Bool, content: @escaping (Item) -> Content) {
        item = textItem
        self.selected = selected
        deleteCallback = { _ in }
        editCallback = { _ in }
        self.content = content
    }

    private let id = UUID()

    public func calculateRotation(value: DragGesture.Value) -> Angle {
        let centerX = viewSize.width / 2
        let centerY = viewSize.height / 2
        let startVector = CGVector(dx: value.startLocation.x - centerX, dy: value.startLocation.y - centerY)
        let endVector = CGVector(dx: value.location.x - centerX, dy: value.location.y - centerY)
        let angleDifference = atan2(endVector.dy, endVector.dx) - atan2(startVector.dy, startVector.dx)
        var rotation = Angle(radians: Double(angleDifference))

        return rotation
    }

    public var body: some View {
        content(item)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background {
                Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [4]))
                    .shadow(color: Color(.black), radius: 0.1)
                    .foregroundStyle(Color(.systemBackground))
                    .shadow(radius: 10)
                    .opacity(selected ? 1 : 0)
                    .overlay(alignment: .topTrailing) {
                        Button(action: {
                            editCallback(item)
                        }, label: {
                            Image(systemName: "pencil.tip")
                                .resizable()
                                .frame(width: 12, height: 12)
                        })
                        .offset(x: 16, y: -16)
                        .opacity(selected ? 1 : 0)
                        .buttonStyle(CircleButtonStyle2())
                    }
                    .overlay(alignment: .topLeading) {
                        Button(role: .destructive, action: {
                            deleteCallback(item)
                        }, label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 10, height: 10)
                        })
                        .offset(x: -16, y: -16)

                        .opacity(selected ? 1 : 0)
                        .buttonStyle(CircleButtonStyle2())
                    }
            }
            .rotationEffect(angle + rotation)

            .background(content: {
                GeometryReader(content: { geometry in
                    Color.clear.onAppear(perform: {
                        viewSize = geometry.size
                    }).preference(key: SizePreferenceKey.self, value: geometry.size)
                        .onPreferenceChange(SizePreferenceKey.self, perform: { _ in
                            viewSize = geometry.size
                        })
                })
            })

            .background(alignment: .center) {
                Image(systemName: "arrow.triangle.2.circlepath")
//                    .resizable()
//                    .frame(width: 20,height: 20)
                    .clipShape(Circle())
                    .shadow(radius: 1)
                    .opacity(selected ? 1 : 0)

                    .offset(x: viewSize.width / 2 + 10, y: viewSize.height / 2 + 10)
                    .rotationEffect(angle + rotation)
                    .gesture(
                        DragGesture(coordinateSpace: .named(id))
                            .updating($angle, body: { value, state, _ in
                                print(value.location)
                                state = calculateRotation(value: value)
                            })
                            .onEnded({ value in
                                rotation = rotation + calculateRotation(value: value)
                            })
                    )
            }

            .coordinateSpace(name: id)

            .position(x: item.pos.x, y: item.pos.y)
            .offset(x: item.offset.x, y: item.offset.y)
            .gesture(DragGesture()
                .onChanged({ value in
                    item.onDragChanged(translation: value.translation)
                }).onEnded({ _ in
                    item.onDragEnd()
                })
            )
    }
}

class MovableImage: MovableObject {
    var imageName: String = "plus"
}

#Preview("3") {
    RoundedRectangle(cornerRadius: 8)
        .fill(.blue.opacity(0.2))
        .frame(height: 400)
        .overlay {
            MovableObjectView(textItem: MovableImage(pos: .init(x: 100, y: 100)), selected: true) { item in
                Image(systemName: item.imageName)
            }
        }
}
