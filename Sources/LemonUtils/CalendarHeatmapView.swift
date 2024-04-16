//
//  CalendarHeatmap.swift
//  MyHabit
//
//  Created by ailu on 2024/4/2.
//

import DateHelper
import SwiftUI

public struct CalendarHeatmapView: View {
    private var color: Color = Color(.systemGreen)
    private let horizontalSpacing: CGFloat = 2
    private let verticalSpacing: CGFloat = 2
    private let width: CGFloat = 20.0
    private let numOfColumns = 7

    private var shift: Int
    private var data: [Double] = []

    public init(shift: Int, data: [Double]) {
        self.shift = shift
        let header: [Double] = Array(repeating: 0, count: shift)

        self.data.append(contentsOf: header)
        self.data.append(contentsOf: data)
    }

//    var columns: [GridItem] = []

    public var body: some View {
        let arr = data.chunked(into: numOfColumns)

        Grid(horizontalSpacing: horizontalSpacing, verticalSpacing: verticalSpacing) {
            ForEach(0 ..< arr.count, id: \.self) { i in
                GridRow {
                    ForEach(0 ..< arr[i].count, id: \.self) { j in
                        let n = i * numOfColumns + j
                        if n < shift {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemBackground))
                                .frame(width: width, height: width)
                        } else {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(color.opacity(Double.random(in: 0.5 ... 1)))
                                .frame(width: width, height: width)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CalendarHeatmapView(shift: Date().weekdayOfMonthStart, data: Array(repeating: 1, count: 31))
}
