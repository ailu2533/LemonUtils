//
//  File.swift
//
//
//  Created by ailu on 2024/5/1.
//

import DateHelper
import Foundation
import SwiftUI

// 重复类型
public enum RecurrenceType: Int, Codable {
    case singleCycle = 1 // 周期性重复，一个周期只重复一次
    case customWeekly = 2 // 自定义每周重复，一周可以重复多次
}

public enum RepeatPeriod: Int, CaseIterable, Identifiable, Codable {
    public var id: Int {
        rawValue
    }

    case daily = 0
    case weekly = 1
    case monthly = 2
    case yearly = 3

    public var text: String {
        switch self {
        case .daily:
            return String(localized: "day", bundle: .module)
        case .weekly:
            return String(localized: "week", bundle: .module)
        case .monthly:
            return String(localized: "month", bundle: .module)
        case .yearly:
            return String(localized: "year", bundle: .module)
        }
    }
}

import Foundation

// 计算距离最近的目标日期还有多少天
public func calculateNearestRepeatDate(startDate: Date, currentDate: Date, repeatPeriod: RepeatPeriod, n: Int, recurrenceType: RecurrenceType, customWeek: UInt8) -> Int {
    switch recurrenceType {
    case .customWeekly:
        return calculateCustomWeeklyRepeatDate(currentDate: currentDate, customWeek: customWeek)
    default:
        return calculateStandardRepeatDate(startDate: startDate, currentDate: currentDate, repeatPeriod: repeatPeriod, n: n)
    }
}

// 计算自定义周重复的日期
private func calculateCustomWeeklyRepeatDate(currentDate: Date, customWeek: UInt8) -> Int {
    var customCalendar = Calendar(identifier: .gregorian)
    customCalendar.firstWeekday = 2 // 设置周一为一周的第一天

    let weekday = customCalendar.component(.weekday, from: currentDate)
    let adjustedWeekday = (weekday + 5) % 7 + 1 // 调整weekday的值，使周一为1，周日为7

    var todayPattern = UInt8(1 << (adjustedWeekday - 1))
    var daysUntilNextRepeat = 0
    var crossWeek = 0

    while daysUntilNextRepeat <= 7 {
        if todayPattern & customWeek != 0 {
            break
        }
        daysUntilNextRepeat += 1
        todayPattern = UInt8(todayPattern << 1)
        if todayPattern == 0 {
            crossWeek = 1
            todayPattern = UInt8(1) // 重置为周日
        }
    }

    return daysUntilNextRepeat - crossWeek
}

// 计算标准周期重复的日期
private func calculateStandardRepeatDate(startDate: Date, currentDate: Date, repeatPeriod: RepeatPeriod, n: Int) -> Int {
    let calendar = Calendar.current
    let st = startDate.adjust(for: .startOfDay)!
    let ct = currentDate.adjust(for: .startOfDay)!

    switch repeatPeriod {
    case .daily:
        return calculateDaysDifference(st: st, ct: ct, periodDays: n)
    case .weekly:
        return calculateDaysDifference(st: st, ct: ct, periodDays: n * 7)
    case .monthly:
        return calculateMonthsDifference(st: st, ct: ct, n: n, calendar: calendar)
    case .yearly:
        return calculateYearsDifference(st: st, ct: ct, n: n, calendar: calendar)
    }
}

// 计算天数差
private func calculateDaysDifference(st: Date, ct: Date, periodDays: Int) -> Int {
    let days = Calendar.current.dateComponents([.day], from: st, to: ct).day!
    return days % periodDays == 0 ? 0 : periodDays - days % periodDays
}

// 计算月份差
private func calculateMonthsDifference(st: Date, ct: Date, n: Int, calendar: Calendar) -> Int {
    // 获取开始日期和当前日期之间的月份和天数差异
    let components = calendar.dateComponents([.month, .day], from: st, to: ct)
    let days = components.day! // 从开始日期到当前日期的天数差
    let months = components.month! // 从开始日期到当前日期的月份差

    // ���果当前日期正好是周期的结束日，并且月份差是周期数的整数倍，则返回0
    if days == 0 && months % n == 0 {
        return 0
    }

    // 计算下一个周期的目标月份
    // 如果月份差不是周期数的整数倍，计算下一个周期的开始月份
    let targetMonth = n * ((months / n) + 1)

    // 计算目标月份的具体日期
    let nextDate = calendar.date(byAdding: .month, value: targetMonth, to: st)!

    // 返回当前日期到下一个周期开始日期的天数差
    return calendar.dateComponents([.day], from: ct, to: nextDate).day!
}

// 计算年份差
private func calculateYearsDifference(st: Date, ct: Date, n: Int, calendar: Calendar) -> Int {
    let components = calendar.dateComponents([.year, .day], from: st, to: ct)
    let days = components.day!
    let years = components.year!
    if days == 0 && years % n == 0 {
        return 0
    }
    let targetYear = n * ((years / n) + 1)
    let nextDate = calendar.date(byAdding: .year, value: targetYear, to: st)!
    return calendar.dateComponents([.day], from: ct, to: nextDate).day!
}


public struct RepeatPeriodPickerView: View {
    @Binding var repeatPeriod: RepeatPeriod
    @Binding var repeatN: Int

    private static let numberData = Array(1 ..< 30).map { "\($0)" }
    private static let periodData = RepeatPeriod.allCases.map { $0.text }

    // 使用计算属性来同步 selections 和绑定的 repeatPeriod 与 repeatN
    private var selections: Binding<[Int]> {
        Binding(
            get: {
                [repeatN - 1, repeatPeriod.rawValue]
            },
            set: {
                repeatN = $0[0] + 1
                repeatPeriod = RepeatPeriod(rawValue: $0[1]) ?? .daily
            }
        )
    }

    public init(repeatPeriod: Binding<RepeatPeriod>, repeatN: Binding<Int>) {
        _repeatPeriod = repeatPeriod
        _repeatN = repeatN
    }

    public var body: some View {
        MultiComponentPickerView(data: [RepeatPeriodPickerView.numberData, RepeatPeriodPickerView.periodData], selections: selections)
    }
}

struct P: View {
    @State private var repeatPeriod = RepeatPeriod.daily
    @State private var repeatN = 1

    var body: some View {
        RepeatPeriodPickerView(repeatPeriod: $repeatPeriod, repeatN: $repeatN)
    }
}

#Preview(body: {
    P()
})

