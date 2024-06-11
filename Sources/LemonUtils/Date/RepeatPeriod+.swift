//
//  File.swift
//
//
//  Created by ailu on 2024/6/7.
//

import Foundation

// 给定开始日期、结束日期、自定义周重复模式，计算距离结束日期最近的一个重复日期，如果没有找到，则返回开始日期
public func calculateLastCustomWeeklyRepeatDateBeforeEndDate(startDate: Date, endDate: Date, customWeek: UInt8) -> Date {
    var customCalendar = Calendar(identifier: .gregorian)
    customCalendar.firstWeekday = 2 // 设置周一为一周的第一天

    // 从结束日期开始，向前检查7天内符合自定义周重复模式的日期
    for offset in 0 ... 6 {
        if let checkDate = customCalendar.date(byAdding: .day, value: -offset, to: endDate) {
            let checkWeekday = customCalendar.component(.weekday, from: checkDate)
            let adjustedWeekday = (checkWeekday + 5) % 7 + 1 // 调整weekday的值，使周一为1，周日为7
            let pattern = UInt8(1 << (adjustedWeekday - 1))
            if customWeek & pattern != 0 {
                if checkDate >= startDate {
                    return checkDate
                }
            }
        }
    }

    // 如果没有找到符合条件的日期，返回开始日期
    return startDate
}

// 给定事件开始时间和结束时间和重复模式，直接计算出小于等于结束时间的最后一个重复日期
public func calculateLastRepeatDateBeforeEndDate(startDate: Date, endDate: Date, repeatPeriod: RepeatPeriod, n: Int) -> Date {
    let calendar = Calendar.current
    var result = startDate

    switch repeatPeriod {
    case .daily:
        let daysBetween = calendar.dateComponents([.day], from: startDate, to: endDate).day!
        let numberOfPeriods = daysBetween / n
        result = max(result, calendar.date(byAdding: .day, value: numberOfPeriods * n, to: startDate)!)

    case .weekly:
        let daysBetween = calendar.dateComponents([.day], from: startDate, to: endDate).day!
        let numberOfPeriods = daysBetween / (n * 7)
        result = max(result, calendar.date(byAdding: .day, value: numberOfPeriods * n * 7, to: startDate)!)

    case .monthly:
        let monthsBetween = calendar.dateComponents([.month], from: startDate, to: endDate).month!
        let numberOfPeriods = monthsBetween / n
        result = max(result, calendar.date(byAdding: .month, value: numberOfPeriods * n, to: startDate)!)

    case .yearly:
        let yearsBetween = calendar.dateComponents([.year], from: startDate, to: endDate).year!
        let numberOfPeriods = yearsBetween / n
        result = max(result, calendar.date(byAdding: .year, value: numberOfPeriods * n, to: startDate)!)
    }

    return result
}
