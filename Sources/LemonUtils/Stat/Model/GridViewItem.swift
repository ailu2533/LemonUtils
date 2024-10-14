//
//  GridViewItem.swift
//  LemonUtils
//
//  Created by Lu Ai on 2024/9/20.
//

import Foundation
import SwiftUI
//
// func getLocalizedWeekdayNames(style: DateFormatter.Style = .short) -> [Int: String] {
//    let calendar = Calendar.current
//    let weekdaySymbols = style == .short ? calendar.veryShortWeekdaySymbols : calendar.weekdaySymbols
//    let startIndex = calendar.firstWeekday - 1
//
//    return Dictionary(uniqueKeysWithValues: (1 ... 7).map { index in
//        let adjustedIndex = (startIndex + index - 1) % 7
//        return (index, weekdaySymbols[adjustedIndex])
//    })
// }
//
//// 使用方法
// let localizedDayToChinese = getLocalizedWeekdayNames()
//
// let daysOfWeek = 1 ... 7

public struct GridViewItem: Identifiable, Sendable {
    public let id: UUID
    // Title displayed in the grid row.
    public let title: String
    // Dictionary mapping day of the week to a statistic value.
    public let sortValue: Double

    // 如果是周数据，key 是 weekday
    public let stat: [Int: Double]
    // 数据的时间。
    // 如果是周数据，传入的是一周内的任意时间
    // 如果是月数据，传入的是一个月内的任意时间
    // 如果是年数据，传入的是一年内的任意时间
    public var date: Date

    public init(id: UUID = UUID(), title: String, sortValue: Double, stat: [Int: Double], date: Date) {
        self.id = id
        self.title = title
        self.sortValue = sortValue
        self.stat = stat
        self.date = date
    }
}
