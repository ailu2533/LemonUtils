//
//  CheckinDataSlider.swift
//  MyHabit
//
//  Created by ailu on 2024/3/31.
//
//
//import CompactSlider
//import SwiftUI
//
//public struct CustomCompactSliderStyle: CompactSliderStyle {
//    public func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .foregroundColor(
//                configuration.isHovering || configuration.isDragging ? .orange : .black
//            )
//            .background(
//                Color.orange.opacity(0.1)
//            )
//            .accentColor(.orange)
//            .compactSliderSecondaryAppearance(
//                progressShapeStyle: LinearGradient(
//                    colors: [.orange.opacity(0), .orange.opacity(0.5)],
//                    startPoint: .leading,
//                    endPoint: .trailing
//                ),
//                focusedProgressShapeStyle: LinearGradient(
//                    colors: [.yellow.opacity(0.2), .orange.opacity(0.7)],
//                    startPoint: .leading,
//                    endPoint: .trailing
//                ),
//                handleColor: .orange,
//                scaleColor: .orange,
//                secondaryScaleColor: .orange
//            )
//            .clipShape(RoundedRectangle(cornerRadius: 12))
//            .onTapGesture {
//                // TODO
//            }
//    }
//}
//
//struct DataSlider: View {
//    @State private var value = 0.0
//
//    var body: some View {
//        CompactSlider(value: $value, in: 0 ... 500, step: 50) {
//            Spacer()
//            Text(String(Int(value)))
//        }
//
//        .compactSliderStyle(CustomCompactSliderStyle())
//
//        .shadow(radius: 10)
//        .padding()
//    }
//}
//
//#Preview {
//    DataSlider().padding()
//}
