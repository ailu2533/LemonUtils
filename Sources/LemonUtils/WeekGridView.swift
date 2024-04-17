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

public struct WeekGridViewItem: Identifiable {
    public let id: UUID
    let title: String
    let color: Color
    let weekStat: Dictionary<Int, Double>

    public init(id: UUID, title: String, color: Color, weekStat: Dictionary<Int, Double>) {
        self.id = id
        self.title = title
        self.color = color
        self.weekStat = weekStat
    }
}

public struct WeekGridView: View {
    private var data: [WeekGridViewItem]

    public init(data: [WeekGridViewItem]) {
        self.data = data
    }

    fileprivate func rowView(rowTitle: String, rowGridColor: Color, _ weekStat: Dictionary<Int, Double>) -> some View {
        return GridRow {
            HStack {
                Text(rowTitle).font(.subheadline).lineLimit(1)
                Spacer()
            }.frame(maxWidth: 86)

            ForEach(daysOfWeek, id: \.self) { i in
                if weekStat[i] != nil {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(rowGridColor)
                        .frame(width: 24, height: 24)
                } else {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 24, height: 24)
                }
            }
        }
    }

    fileprivate func headerView() -> some View {
        return GridRow {
            HStack {
                Spacer()
            }.frame(maxWidth: 60)
            ForEach(daysOfWeek, id: \.self) { i in
                Text(dayToChinese[i]!)
            }
        }
    }

    public var body: some View {
        ScrollView {
            VStack {
                Grid {
                    headerView()
                    ForEach(data) { item in
                        rowView(rowTitle: item.title, rowGridColor: item.color, item.weekStat)
                    }
                }
            }
        }
    }
}
