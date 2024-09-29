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
    private let cellSize: CGFloat = 24
    private let headerHeight: CGFloat = 60

    public init(data: [GridViewItem]) {
        self.data = data
    }

    public var body: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            WeekHeaderRow()
            ForEach(data) { item in
                GridRowView(item: item, cellSize: cellSize)
            }
        }
    }
}

struct WeekHeaderRow: View {
    private let cellSize: CGFloat = 24

    var body: some View {
        HStack(spacing: 8) {
            Spacer()
            ForEach(daysOfWeek, id: \.self) { dayIndex in
                Text(localizedDayToChinese[dayIndex] ?? "")
                    .frame(width: cellSize)
                    .foregroundStyle(.secondary)
                    .font(.callout)
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
        HStack(spacing: 8) {
            Text(item.title)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.callout)

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
