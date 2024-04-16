//
//  Date+.swift
//  MyHabit
//
//  Created by ailu on 2024/4/1.
//

import DateHelper
import Foundation
import HorizonCalendar

struct YearMonthDay: Hashable {
    let year: Int
    let month: Int
    let day: Int
    let weekday: Int

    init(year: Int, month: Int, day: Int, weekday: Int) {
        self.year = year
        self.month = month
        self.day = day
        self.weekday = weekday
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(year)
        hasher.combine(month)
        hasher.combine(day)
    }
}

extension YearMonthDay {
    static func fromDate(_ date: Date) -> YearMonthDay {
        let components = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: date)
        return .init(year: components.year!, month: components.month!, day: components.day!, weekday: components.weekday!)
    }
}

extension Date {
    var startOfWeek: Date? {
        let t = adjust(for: .startOfWeek)?.adjust(for: .startOfDay)
        return Calendar.current.date(byAdding: .day, value: 1, to: t!)
    }

    var endOfWeek: Date? {
        let t = adjust(for: .endOfWeek)?.adjust(for: .endOfDay)
        return Calendar.current.date(byAdding: .day, value: 1, to: t!)
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
}
