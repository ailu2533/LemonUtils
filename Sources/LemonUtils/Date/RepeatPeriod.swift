//
//  File.swift
//
//
//  Created by ailu on 2024/5/1.
//

import DateHelper
import Foundation
import SwiftUI

public enum RepeatPeriod: Int, CaseIterable, Identifiable, Codable {
    public var id: Int {
        rawValue
    }

    case day = 0
    case week = 1
    case month = 2
    case year = 3

    public var text: String {
        switch self {
        case .day:
            return String(localized: "day", bundle: .module)
        case .week:
            return String(localized: "week", bundle: .module)
        case .month:
            return String(localized: "month", bundle: .module)
        case .year:
            return String(localized: "year", bundle: .module)
        }
    }
}

// 计算 距离最近的目标日期还有多少天
public func calculateNearestRepeatDate(startDate: Date, currentDate: Date, repeatPeriod: RepeatPeriod, n: Int, customWeek: UInt8 = 0) -> Int {
    if customWeek > 0 {
        var customCalendar = Calendar(identifier: .gregorian)
        customCalendar.firstWeekday = 2

        let weekday = customCalendar.component(.weekday, from: currentDate)

        // customWeek是位数组，1表示周一，2表示周二，4表示周三，8表示周四，16表示周五，32表示周六，64表示周日
        // 例如，如果 customWeek 是 15，那么表示周一到周四重复
        var todayPattern = UInt8(1 << (weekday - 1))
        var i = 0
        while i < 7 {
            if todayPattern & customWeek != 0 {
                break // 找到匹配的重复日，退出循环
            }
            i += 1
            todayPattern = UInt8(todayPattern << 1)
            if todayPattern == 0 {
                todayPattern = UInt8(1) // 如果超出位数组范围，重置为周日
            }
        }

        return i
    }

    let calendar = Calendar.current
    let st = startDate.adjust(for: .startOfDay)!
    let ct = currentDate.adjust(for: .startOfDay)!
    switch repeatPeriod {
    case .day:
        let days = calendar.dateComponents([.day], from: st, to: ct).day!
        return days % n == 0 ? 0 : n - days % n

    case .week:
        let days = calendar.dateComponents([.day], from: st, to: ct).day!
        let periodDays = n * 7
        return days % periodDays == 0 ? 0 : periodDays - days % periodDays

    case .month:
        let components = calendar.dateComponents([.month, .day], from: st, to: ct)
        let days = components.day!
        let months = components.month!
        if days == 0 && months % n == 0 {
            return 0
        }
        let targetMonth = n * ((months / n) + 1)
        let nextDate = calendar.date(byAdding: .month, value: targetMonth, to: startDate)!
        return calendar.dateComponents([.day], from: currentDate, to: nextDate).day!

    case .year:
        let components = calendar.dateComponents([.year, .day], from: st, to: ct)
        let days = components.day!
        let years = components.year!
        if days == 0 && years % n == 0 {
            return 0
        }
        let targetYear = n * ((years / n) + 1)
        let nextDate = calendar.date(byAdding: .year, value: targetYear, to: startDate)!
        return calendar.dateComponents([.day], from: currentDate, to: nextDate).day!
    }
}

// 判断currentDate与 startDate之间是否距离n个周期
public func checkRepeatDate(startDate: Date, currentDate: Date, repeatPeriod: RepeatPeriod, n: Int, customWeek: UInt8 = 0) -> Bool {
    if customWeek > 0 {
        var customCalendar = Calendar(identifier: .gregorian)
        customCalendar.firstWeekday = 2

        let weekday = customCalendar.component(.weekday, from: currentDate)

        // customWeek是位数组，1表示周一，2表示周二，4表示周三，8表示周四，16表示周五，32表示周六，64表示周日
        // 例如，如果 customWeek 是 15，那么表示周一到周四重复
        var todayPattern = UInt8(1 << (weekday - 1))

        return (todayPattern & customWeek) > 0
    }

    let calendar = Calendar.current
    switch repeatPeriod {
    case .day:
        let days = calendar.dateComponents([.day], from: startDate, to: currentDate).day!
        return days % n == 0

    case .week:
        let days = calendar.dateComponents([.day], from: startDate, to: currentDate).day!
        return days % 7 == 0 && (days / 7) % n == 0

    case .month:
        let components = calendar.dateComponents([.month, .day], from: startDate, to: currentDate)
        return components.day! == 0 && components.month! % n == 0

    case .year:
        let components = calendar.dateComponents([.year, .day], from: startDate, to: currentDate)
        return components.day! == 0 && components.year! % n == 0
    }
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
                repeatPeriod = RepeatPeriod(rawValue: $0[1]) ?? .day
            }
        )
    }

    public init(repeatPeriod: Binding<RepeatPeriod>, repeatN: Binding<Int>) {
        _repeatPeriod = repeatPeriod
        _repeatN = repeatN
    }

    public var body: some View {
        MultiComponentPickerView(data: [RepeatPeriodPickerView.numberData, RepeatPeriodPickerView.periodData], selections: selections)
//            .frame(height: 80)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
    }
}

struct P: View {
    @State private var repeatPeriod = RepeatPeriod.day
    @State private var repeatN = 1

    var body: some View {
        RepeatPeriodPickerView(repeatPeriod: $repeatPeriod, repeatN: $repeatN)
    }
}

#Preview(body: {
    P()
})
