//
//  CalendarHeatmapViewModel.swift
//  LemonUtils
//
//  Created by Lu Ai on 2024/9/20.
//

import Foundation
import SwiftUI

public class CalendarHeatmapViewModel {
    let colors: [Color]
    let cellSize: CGFloat
    let spacing: CGFloat
    let numOfColumns: Int
    let data: [Double]

    var rowCount: Int {
        (data.count + numOfColumns - 1) / numOfColumns
    }

    public init(data: GridViewItem, colors: [Color], cellSize: CGFloat, spacing: CGFloat, numOfColumns: Int) {
        self.colors = colors
        self.cellSize = cellSize
        self.spacing = spacing
        self.numOfColumns = numOfColumns

        guard let date = data.date else {
            self.data = []
            return
        }

        let daysInMonth = date.daysInMonth
        var dailyData = Array(repeating: 0.0, count: daysInMonth)

        for (day, value) in data.stat where day > 0 && day <= daysInMonth {
            dailyData[day - 1] = value
        }

        self.data = dailyData
    }

    func fillColor(for index: Int) -> Color {
        guard index < data.count else {
            return .clear
        }

        let progress = data[index]

//        if progress == 0 {
//            return colors[0]
//        }
//
//        if progress >= 1 {
//            return colors.last ?? .clear
//        }

        // 使用 colors[1...] 来表示非零进度
        let colorIndex = Int((progress * Double(colors.count - 1)).rounded(.up))
        return colors[colorIndex]
    }
}
