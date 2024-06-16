//
//  Date+.swift
//  MyHabit
//
//  Created by ailu on 2024/4/1.
//

import DateHelper
import Foundation
import HorizonCalendar

public struct YearMonthDay: Hashable, Equatable {
    let year: Int
    let month: Int
    let day: Int
//    public let weekday: Int

    public init(date: Date) {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        year = dateComponents.year!
        month = dateComponents.month!
        day = dateComponents.day!
//        weekday = dateComponents.weekday!
    }

    public init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
//        self.weekday = weekday
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(year)
        hasher.combine(month)
        hasher.combine(day)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
    }
}

extension YearMonthDay {
    public static func fromDate(_ date: Date) -> YearMonthDay {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return .init(year: components.year!, month: components.month!, day: components.day!)
    }

    public static func fromDayComponents(_ date: DayComponents) -> YearMonthDay {
        let year = date.month.year
        let month = date.month.month
        let day = date.day

        return .init(year: year, month: month, day: day)
    }

    public func date() -> Date {
        let components = DateComponents(year: year, month: month, day: day)

        return Calendar.current.date(from: components)!
    }
}

public extension Date {
    /// Returns the start of the week for the given date.
    /// - Parameter usingMondayAsFirstDay: A Boolean value indicating whether Monday should be considered the first day of the week.
    /// - Returns: The date representing the start of the week.
    func startOfWeek(usingMondayAsFirstDay: Bool = true) -> Date? {
        let calendar = configuredCalendar(usingMondayAsFirstDay: usingMondayAsFirstDay)
        return adjust(for: .startOfWeek, calendar: calendar)?.adjust(for: .startOfDay)
    }

    /// Returns the end of the week for the given date.
    /// - Parameter usingMondayAsFirstDay: A Boolean value indicating whether Monday should be considered the first day of the week.
    /// - Returns: The date representing the end of the week.
    func endOfWeek(usingMondayAsFirstDay: Bool = true) -> Date? {
        let calendar = configuredCalendar(usingMondayAsFirstDay: usingMondayAsFirstDay)
        return adjust(for: .endOfWeek, calendar: calendar)?.adjust(for: .endOfDay)
    }

    /// Configures the calendar based on whether Monday is considered the first day of the week.
    /// - Parameter usingMondayAsFirstDay: A Boolean value indicating whether Monday should be considered the first day of the week.
    /// - Returns: A configured `Calendar` instance.
    private func configuredCalendar(usingMondayAsFirstDay: Bool) -> Calendar {
        var calendar = Calendar.current
        if usingMondayAsFirstDay {
            calendar = Calendar(identifier: .gregorian)
            calendar.firstWeekday = 2 // Monday
        }
        return calendar
    }

    var startOfMonth: Date? {
        return adjust(for: .startOfMonth)?.adjust(for: .startOfDay)
    }

    var endOfMonth: Date? {
        return adjust(for: .endOfMonth)?.adjust(for: .endOfDay)
    }

    // 获取前一天日期
    var prevDay: Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }

    // 获取后一天日期
    var nextDay: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }

    // 获取上个月日期
    var prevMonth: Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: -1, to: self)
    }

    // 获取下个月日期
    var nextMonth: Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: 1, to: self)
    }

    // 获取上周日期
    var prevWeek: Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .weekOfYear, value: -1, to: self)!
    }

    // 获取下周日期
    var nextWeek: Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .weekOfYear, value: 1, to: self)
    }

    var weekdayOfMonthStart: Int {
        let weekday = adjust(for: .startOfMonth)?.component(.weekday)
        // 减二的原因是
        // 1. weekday 是 1到 7，
        // 2. sunday 是 1，要修改为 monday 是 1

        return weekday! - 2
    }

    // 计算这个日期所在月份的天数
    var daysInMonth: Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: self)
        return range?.count ?? 30 // 如果无法获取到天数，默认返回30天
    }
}

public extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>

        return numberOfDays.day!
    }
}
