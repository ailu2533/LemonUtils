//
//  CalendarHeatmap.swift
//  MyHabit
//
//  Created by ailu on 2024/4/2.
//

import DateHelper
import SwiftUI

public struct MonthHeatmapView: View {
    private let data: GridViewItem
    private let cellSize: CGFloat = 16
    private let headerHeight: CGFloat = 60
    private let colorMap: RangeMap<Double, Color>

    private let date: Date
    private let days: [Date]

    private let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    public init(data: GridViewItem, colorMap: RangeMap<Double, Color>) {
        self.data = data
        self.colorMap = colorMap
        date = data.date
        days = data.date.calendarDisplayDays2
    }

    public var body: some View {
        VStack {
            weekdayHeader
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(days, id: \.self) { day in
                    if day.monthInt != date.monthInt {
                        Color.clear
                            .frame(width: cellSize, height: cellSize)
                    } else {
                        let progress = data.stat[day.dayInt, default: 0]
                        let color = colorMap.map(progress)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(color)
                            .stroke(Color(.systemGray4), style: .init(lineWidth: 1))
                            .frame(width: cellSize, height: cellSize)
                    }
                }
            }
        }
    }

    private var weekdayHeader: some View {
        HStack {
            ForEach(0 ..< 7, id: \.self) { index in
                Text(daysOfWeek[index])
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    MonthHeatmapView(
        data: GridViewItem(title: "每天晚上",
                           sortValue: 1,
                           stat: [1: 0.2, 2: 0.3, 3: 0.4, 4: 0.5, 5: 0.6],
                           date: Date()),
        colorMap: RangeMap<Double, Color>(
            ranges: [
                .init(start: 0, end: 0.25, value: .green),
                .init(start: 0.25, end: 0.5, value: .yellow),
                .init(start: 0.5, end: 0.75, value: .orange),
                .init(start: 0.75, end: 1, value: .red),
            ],
            specialPoints: [
                (0, .blue),
                (1, .purple),
            ],
            defaultValue: .cyan
        )
    )
}
