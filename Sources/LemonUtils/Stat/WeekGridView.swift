//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/17.
//

import LemonDateUtils
import SwiftUI

private let dayToChinese: [Int: String] = [
    1: "一",
    2: "二",
    3: "三",
    4: "四",
    5: "五",
    6: "六",
    7: "日",
]

private let daysOfWeek = 1 ... 7

public struct GridViewItem: Identifiable {
    // Unique identifier for each grid item.
    public let id: UUID
    // Title displayed in the grid row.
    public let title: String
    // Color used for the filled cells in the grid.
    let color: Color
    // Dictionary mapping day of the week to a statistic value.
    public let sortValue: Double
    public let stat: [Int: Double]
    // 数据的时间。
    // 如果是周数据，传入的是一周内的任意时间
    // 如果是月数据，传入的是一个月内的任意时间
    // 如果是年数据，传入的是一年内的任意时间
    public var date: Date?

    public init(id: UUID, title: String, color: Color, date: Date? = nil, sortValue: Double = 0, stat: [Int: Double]) {
        self.id = id
        self.title = title
        self.color = color
        self.stat = stat
        self.date = date
        self.sortValue = sortValue
    }
}

public struct YearGridViewItem: Identifiable {
    // Unique identifier for each grid item.
    public let id: UUID
    // Title displayed in the grid row.
    public let title: String
    // Color used for the filled cells in the grid.
    let color: Color
    // Dictionary mapping day of the week to a statistic value.
    public let sortValue: Double
    public let stat: [YearMonthDay: Double]

    public var date: Date
    public var year: Int

    public init(id: UUID, title: String, color: Color, date: Date, sortValue: Double = 0, stat: [YearMonthDay: Double]) {
        self.id = id
        self.title = title
        self.color = color
        self.stat = stat
        self.date = date
        self.sortValue = sortValue
        year = date.component(.year) ?? 2024
    }
}

public struct WeekGridView: View {
    private let data: [GridViewItem]
    private let cellSize: CGFloat = 24
    private let headerHeight: CGFloat = 60

    public init(data: [GridViewItem]) {
        self.data = data
    }

    public var body: some View {
        ScrollView {
            Grid(alignment: .leading, horizontalSpacing: 8, verticalSpacing: 8) {
                headerRow
                ForEach(data) { item in
                    GridRowView(item: item, cellSize: cellSize)
                }
            }
//            .padding()
        }
    }

    private var headerRow: some View {
        GridRow {
            Text(verbatim: "")
            ForEach(daysOfWeek, id: \.self) { dayIndex in
                Text(dayToChinese[dayIndex] ?? "")
                    .frame(width: cellSize)
            }
        }
    }
}

struct GridRowView: View {
    let item: GridViewItem
    let cellSize: CGFloat

    

    init(item: GridViewItem, cellSize: CGFloat) {
        self.item = item
        self.cellSize = cellSize
    }

    var body: some View {
        GridRow {
            Text(item.title)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            ForEach(daysOfWeek, id: \.self) { dayIndex in
                RoundedRectangle(cornerRadius: 4)
                    .fill(item.stat[dayIndex] != nil ? item.color : Color(.systemGray6))
                    .frame(width: cellSize, height: cellSize)
            }
        }
    }
}

#Preview {
    WeekGridView(data: [
        GridViewItem(id: UUID(), title: "测试 1", color: .blue, stat: [:]),
        GridViewItem(id: UUID(), title: "测试 2", color: .blue, stat: [:]),
        GridViewItem(id: UUID(), title: "测试 3", color: .blue, stat: [:]),
        GridViewItem(id: UUID(), title: "测试 4", color: .blue, stat: [:]),
        GridViewItem(id: UUID(), title: "测试 5", color: .blue, stat: [:]),
        GridViewItem(id: UUID(), title: "测试 6", color: .blue, stat: [:]),
        GridViewItem(id: UUID(), title: "测试 7", color: .blue, stat: [:]),
        GridViewItem(id: UUID(), title: "测试 8", color: .blue, stat: [:]),
        GridViewItem(id: UUID(), title: "测试超级长", color: .blue, stat: [:]),

    ])
    .padding(.horizontal, 16)
}
