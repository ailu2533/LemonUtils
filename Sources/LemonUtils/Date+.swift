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
    public let weekday: Int

    public init(date: Date) {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: date)
        year = dateComponents.year!
        month = dateComponents.month!
        day = dateComponents.day!
        weekday = dateComponents.weekday!
    }

    public init(year: Int, month: Int, day: Int, weekday: Int) {
        self.year = year
        self.month = month
        self.day = day
        self.weekday = weekday
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
        let components = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: date)
        return .init(year: components.year!, month: components.month!, day: components.day!, weekday: components.weekday!)
    }

    public static func fromDayComponents(_ date: DayComponents) -> YearMonthDay {
        let year = date.month.year
        let month = date.month.month
        let day = date.day

        return .init(year: year, month: month, day: day, weekday: 0)
    }

    public func date() -> Date {
        let components = DateComponents(year: year, month: month, day: day)

        return Calendar.current.date(from: components)!
    }
}

public extension Date {
    public var startOfWeek: Date? {
        let t = adjust(for: .startOfWeek)?.adjust(for: .startOfDay)
        return Calendar.current.date(byAdding: .day, value: 1, to: t!)
    }

    public var endOfWeek: Date? {
        let t = adjust(for: .endOfWeek)?.adjust(for: .endOfDay)
        return Calendar.current.date(byAdding: .day, value: 1, to: t!)
    }

    public var startOfMonth: Date? {
        return adjust(for: .startOfMonth)?.adjust(for: .startOfDay)
    }

    public var endOfMonth: Date? {
        return adjust(for: .endOfMonth)?.adjust(for: .endOfDay)
    }

    // 获取前一天日期
    public var prevDay: Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }

    // 获取后一天日期
    public var nextDay: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }

    // 获取上个月日期
    public var prevMonth: Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: -1, to: self)
    }

    // 获取下个月日期
    public var nextMonth: Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: 1, to: self)
    }

    // 获取上周日期
    public var prevWeek: Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .weekOfYear, value: -1, to: self)!
    }

    // 获取下周日期
    public var nextWeek: Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .weekOfYear, value: 1, to: self)
    }

    public var weekdayOfMonthStart: Int {
        let weekday = adjust(for: .startOfMonth)?.component(.weekday)
        // 减二的原因是
        // 1. weekday 是 1到 7，
        // 2. sunday 是 1，要修改为 monday 是 1

        return weekday! - 2
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
