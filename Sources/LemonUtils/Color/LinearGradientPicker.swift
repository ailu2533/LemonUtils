//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/5/23.
//

import SwiftUI

public let linear = [["#FDEB71", "#F8D800"],
                     ["#ABDCFF", "#0396FF"],
                     ["#FEB692", "#EA5455"],
                     ["#a1c4fd", "#c2e9fb"],
                     ["#E3FDF5", "#FFE6FA"],
                     ["#abecd6", "#fbed96"],
                     ["#a1c4fd", "#ebedee"],
                     ["#E2B0FF", "#9F44D3"],

                     ["#fad0c4", "#ffd1ff"],

                     ["#f6d365", "#fda085"],

                     ["#e9defa", "#fbfcdb"],

                     ["#f7971e", "#ffd200"],

                     ["#feada6", "#f5efef"],

                     ["#ffefba", "#ffffff"],

                     ["#1c92d2", "#f2fcfe"],

                     ["#a1ffce", "#faffd1"],

                     ["#e0eafc", "#cfdef3"],

                     ["#FEC163", "#DE4313"],
                     ["#92FFC0", "#002661"],
                     ["#EEAD92", "#6018DC"],
                     ["#F6CEEC", "#D939CD"],
                     ["#52E5E7", "#130CB7"],
                     ["#F1CA74", "#A64DB6"],
                     ["#E8D07A", "#5312D6"],
                     ["#EECE13", "#B210FF"],
                     ["#79F1A4", "#0E5CAD"],
                     ["#FDD819", "#E80505"],
                     ["#FFF3B0", "#CA26FF"],
                     ["#FFF5C3", "#9452A5"],
                     ["#F05F57", "#360940"],
                     ["#2AFADF", "#4C83FF"],
                     ["#FFF886", "#F072B6"],
                     ["#97ABFF", "#123597"],
                     ["#F5CBFF", "#C346C2"],
                     ["#FFF720", "#3CD500"],
                     ["#FF6FD8", "#3813C2"],
                     ["#EE9AE5", "#5961F9"],
                     ["#FFD3A5", "#FD6585"],
                     ["#C2FFD8", "#465EFB"],
                     ["#FD6585", "#0D25B9"],
                     ["#FD6E6A", "#FFC600"],
                     ["#65FDF0", "#1D6FA3"],
                     ["#6B73FF", "#000DFF"],
                     ["#FF7AF5", "#513162"],
                     ["#F0FF00", "#58CFFB"],
                     ["#FFE985", "#FA742B"],
                     ["#FFA6B7", "#1E2AD2"],
                     ["#FFAA85", "#B3315F"],
                     ["#72EDF2", "#5151E5"],
                     ["#FF9D6C", "#BB4E75"],
                     ["#F6D242", "#FF52E5"],
                     ["#69FF97", "#00E4FF"],
                     ["#3B2667", "#BC78EC"],
                     ["#70F570", "#49C628"],
                     ["#3C8CE7", "#00EAFF"],
                     ["#FAB2FF", "#1904E5"],
                     ["#81FFEF", "#F067B4"],
                     ["#FFA8A8", "#FCFF00"],
                     ["#FFCF71", "#2376DD"],
                     ["#FF96F9", "#C32BAC"]]

public struct LinearGradientPicker: View {
    @Binding private var selectedColor: [String]
    private let colorSet: [[String]]
    private let columns = [GridItem(.adaptive(minimum: 40, maximum: 60))]

    public init(selection: Binding<[String]>, colorSet: [[String]] = linear) {
        _selectedColor = selection
        self.colorSet = colorSet
    }

    func colorHexArrToLinearGredient(arr: [String]) -> LinearGradient {
        return LinearGradient(gradient: Gradient(colors: arr.map { Color(hex: $0) ?? Color.clear }), startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    public var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(colorSet, id: \.self) { colorHex in
                        let color = colorHexArrToLinearGredient(arr: colorHex)
                        Circle()
                            .fill(color)
                            .scaleEffect(selectedColor == colorHex ? 0.8 : 1)
                            .overlay(Circle().stroke(color, lineWidth: selectedColor == colorHex ? 2 : 0))
                            .onTapGesture {
                                selectedColor = colorHex
                            }
                            .padding(2)
                    }
                }
                .sensoryFeedback(.selection, trigger: selectedColor)
            }
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
        }.padding(.horizontal)
//            .padding(.top)
    }
}
