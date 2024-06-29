//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/17.
//

import SwiftUI

private let dayToChinese: Dictionary<Int, String> = [
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
    public let stat: Dictionary<Int, Double>
    // 数据的时间。
    // 如果是周数据，传入的是一周内的任意时间
    // 如果是月数据，传入的是一个月内的任意时间
    // 如果是年数据，传入的是一年内的任意时间
    public var date: Date?

    public init(id: UUID, title: String, color: Color, date: Date? = nil, sortValue: Double = 0, stat: Dictionary<Int, Double>) {
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
    public let stat: Dictionary<YearMonthDay, Double>

    public var date: Date
    public var year: Int

    public init(id: UUID, title: String, color: Color, date: Date, sortValue: Double = 0, stat: Dictionary<YearMonthDay, Double>) {
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
    // Data array containing all items to be displayed in the grid.
    private var data: [GridViewItem]

    public init(data: [GridViewItem]) {
        self.data = data
    }

    /// Creates a view for a single row in the grid.
    /// - Parameters:
    ///   - rowTitle: The title to display in the row.
    ///   - rowColor: The color to use for filled cells.
    ///   - weekStats: Dictionary containing statistics for each day of the week.
    fileprivate func createRowView(rowTitle: String, rowColor: Color, weekStats: Dictionary<Int, Double>) -> some View {
        GridRow {
            HStack {
                Text(rowTitle).font(.subheadline).lineLimit(1)
                Spacer()
            }.frame(maxWidth: 86)

            ForEach(daysOfWeek, id: \.self) { dayIndex in
                if weekStats[dayIndex] != nil {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(rowColor)
                        .frame(width: 24, height: 24)
                } else {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray6))
                        .frame(width: 24, height: 24)
                }
            }
        }
    }

    /// Creates the header row for the grid, displaying days of the week.
    fileprivate func createHeaderView() -> some View {
        GridRow {
            HStack {
                Spacer()
            }.frame(maxWidth: 60)
            ForEach(daysOfWeek, id: \.self) { dayIndex in
                Text(dayToChinese[dayIndex]!)
            }
        }
    }

    public var body: some View {
        ScrollView {
            VStack {
                Grid {
                    createHeaderView()
                    ForEach(data) { item in
                        createRowView(rowTitle: item.title, rowColor: item.color, weekStats: item.stat)
                    }
                }
            }
        }
    }
}
