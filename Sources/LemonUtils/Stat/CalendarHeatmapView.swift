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

    public var body: some View {
        let arr = data.chunked(into: numOfColumns)

        Grid(horizontalSpacing: horizontalSpacing, verticalSpacing: verticalSpacing) {
            ForEach(0 ..< arr.count, id: \.self) { i in
                GridRow {
                    ForEach(0 ..< arr[i].count, id: \.self) { j in
                        let n = i * numOfColumns + j
                        let op: Double = data[n]
                        if n < shift {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemBackground))
                                .frame(width: width, height: width)
                        } else {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(color.opacity(op))
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

public struct CalendarHeatmapView2: View {
    private var color: Color = Color(.systemGreen)
    private let horizontalSpacing: CGFloat = 2
    private let verticalSpacing: CGFloat = 2
    private let width: CGFloat = 20.0
    private let numOfColumns = 7

    private var data: [Double] = []
    private var shift = 0

    public init(data: GridViewItem) {
        guard let date = data.date else {
            return
        }

        shift = date.weekdayOfMonthStart - 1 // 调整为从0开始计数

        // 创建一个数组来填充每天的数据，初始化为0
        let daysInMonth = date.daysInMonth // 如果 date 为 nil，默认为30天
        var dailyData = Array(repeating: 0.0, count: daysInMonth)

        // 填充实际的数据
        for (day, value) in data.stat {
            if day > 0 && day <= daysInMonth {
                dailyData[day - 1] = value // day - 1 因为数组是从0开始的索引
            }
        }

        // 将头部的空白和月份数据合并
        let header: [Double] = Array(repeating: 0, count: shift)
        self.data = header + dailyData
    }

    public var body: some View {
        let arr = data.chunked(into: numOfColumns)

        Grid(horizontalSpacing: horizontalSpacing, verticalSpacing: verticalSpacing) {
            ForEach(0 ..< arr.count, id: \.self) { i in
                GridRow {
                    ForEach(0 ..< arr[i].count, id: \.self) { j in
                        let n = i * numOfColumns + j
                        let op: Double = data[n]
                        if n < shift {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemBackground))
                                .frame(width: width, height: width)
                        } else {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(op == 0 ? Color(.systemGray6) : color)
                                .frame(width: width, height: width)
                        }
                    }
                }
            }
        }
    }
}
