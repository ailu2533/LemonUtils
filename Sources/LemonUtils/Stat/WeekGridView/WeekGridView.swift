//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/17.
//

import LemonDateUtils
import SwiftUI

public struct WeekGridView: View {
    private let data: [GridViewItem]
    private let cellSize: CGFloat = 18
    private let headerHeight: CGFloat = 60
    private let colorMap: RangeMap<Double, Color>

    private let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays

    public init(data: [GridViewItem], colorMap: RangeMap<Double, Color>) {
        self.data = data
        self.colorMap = colorMap
    }

    public var body: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            WeekHeaderRow()
            ForEach(data) { item in
                GridRowView(item: item, cellSize: cellSize, colorMap: colorMap)
            }
        }
    }
}

struct WeekHeaderRow: View {
    private let cellSize: CGFloat = 18
    private let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays

    var body: some View {
        HStack(spacing: 8) {
            Text(verbatim: "")
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(0 ..< 7, id: \.self) { index in
                Text(daysOfWeek[index])
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(width: cellSize, height: cellSize)
            }
        }
    }
}

struct GridRowView: View {
    let item: GridViewItem
    let cellSize: CGFloat
    let colorMap: RangeMap<Double, Color>
    private let daysOfWeek = Date.weekdayIndex

    init(item: GridViewItem, cellSize: CGFloat, colorMap: RangeMap<Double, Color>) {
        self.item = item
        self.cellSize = cellSize
        self.colorMap = colorMap
    }

    var body: some View {
        HStack(spacing: 8) {
            Text(item.title)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.callout)

            ForEach(daysOfWeek, id: \.self) { dayIndex in
                let progress = item.stat[dayIndex, default: 0]
                let color = colorMap.map(progress)

                RoundedRectangle(cornerRadius: 4)
                    .fill(color)
                    .stroke(Color(.systemGray4), style: .init(lineWidth: 1))
                    .frame(width: cellSize, height: cellSize)
            }
        }
    }
}

#Preview {
    WeekGridView(data: [
        GridViewItem(id: UUID(), title: "测试 1", sortValue: 1, stat: [1: 0, 2: 0.3, 3: 0.4, 4: 0.7, 5: 0.8, 6: 0.9, 7: 1], date: Date()),
        GridViewItem(id: UUID(), title: "测试 2", sortValue: 2, stat: [1: 0, 2: 0.3, 3: 0.4, 4: 0.6, 5: 0.8, 6: 0.9, 7: 1], date: Date()),
        GridViewItem(id: UUID(), title: "测试 3", sortValue: 3, stat: [:], date: Date()),
        GridViewItem(id: UUID(), title: "测试 4", sortValue: 4, stat: [:], date: Date()),
        GridViewItem(id: UUID(), title: "测试 5", sortValue: 5, stat: [:], date: Date()),
        GridViewItem(id: UUID(), title: "测试 6", sortValue: 6, stat: [:], date: Date()),
        GridViewItem(id: UUID(), title: "测试 7", sortValue: 7, stat: [:], date: Date()),
        GridViewItem(id: UUID(), title: "测试 8", sortValue: 8, stat: [:], date: Date()),
        GridViewItem(id: UUID(), title: "测试 9", sortValue: 9, stat: [:], date: Date()),

    ], colorMap: RangeMap(
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
    ))
    .padding(.horizontal, 16)
}
