//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/5/8.
//

import Foundation

/// Represents a time offset with components for years, months, days, hours, and weeks.
public struct TimeOffset: Comparable, Codable {
    var year: Int = 0
    var month: Int = 0
    var day: Int = 0
    var hour: Int = 0
    var week: Int = 0 // Added week field

    // 是否是最大 TimeOffset
    var isMax: Bool = false


    /// Initializes a new `TimeOffset` with specified time components.
    public init(year: Int = 0, month: Int = 0, day: Int = 0, hour: Int = 0, week: Int = 0, isMax: Bool = false) {
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.week = week
        self.isMax = isMax
    }

    // MARK: - Comparable

    public static func < (lhs: TimeOffset, rhs: TimeOffset) -> Bool {
        if lhs.isMax && !rhs.isMax {
            return false
        } else if !lhs.isMax && rhs.isMax {
            return true
        }

        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        }
        if lhs.month != rhs.month {
            return lhs.month < rhs.month
        }
        if lhs.week != rhs.week {
            return lhs.week < rhs.week
        }
        if lhs.day != rhs.day {
            return lhs.day < rhs.day
        }
        return lhs.hour < rhs.hour
    }

    public static func == (lhs: TimeOffset, rhs: TimeOffset) -> Bool {
        return lhs.year == rhs.year &&
            lhs.month == rhs.month &&
            lhs.week == rhs.week &&
            lhs.day == rhs.day &&
            lhs.hour == rhs.hour &&
            lhs.week == rhs.week
    }

    // 转换成 TimeInterval
    public func toTimeInterval() -> TimeInterval {
        return TimeInterval(year * 365 * 24 * 3600 + month * 30 * 24 * 3600 + day * 24 * 3600 + hour * 3600 + week * 7 * 24 * 3600)
    }
}

extension TimeOffset: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(year)
        hasher.combine(month)
        hasher.combine(day)
        hasher.combine(hour)
        hasher.combine(week)
    }
}

extension TimeOffset: CustomStringConvertible {
    // timeoffset 里面，ymdh只能都大于等于 0，或都小于等于 0
    // 如果 ymdh 都大于等于 0， 那么就是 y 年 m月 d 天 h 小时 后
    // 如果 ymdh 都小于等于 0， 那么就是 y 年 m月 d 天 h 小时 前
    // 如果 ymdh 中某一个等于 0， 那一部分就不需要写出来

    public var description: String {
        var parts: [String] = []
        if year != 0 { parts.append("\(abs(year)) 年") }
        if month != 0 { parts.append("\(abs(month)) 月") }
        if week != 0 { parts.append("\(abs(week)) 周") }
        if day != 0 { parts.append("\(abs(day)) 天") }
        if hour != 0 { parts.append("\(abs(hour)) 小时") }

        if parts.isEmpty {
            return "0 小时"
        }

        let joinedParts = parts.joined(separator: " ")
        return "\(joinedParts)"
    }
}

// Example of extending Date to apply TimeOffset
extension Date {
    /// Returns a new `Date` by adding a `TimeOffset` to this `Date`.
    func adding(_ timeOffset: TimeOffset) -> Date {
        var date = self
        date = Calendar.current.date(byAdding: .year, value: timeOffset.year, to: date)!
        date = Calendar.current.date(byAdding: .month, value: timeOffset.month, to: date)!
        date = Calendar.current.date(byAdding: .day, value: timeOffset.day, to: date)!
        date = Calendar.current.date(byAdding: .hour, value: timeOffset.hour, to: date)!
        return date
    }
}

extension TimeOffset: Identifiable {
    public var id: UUID {
        UUID()
    }
}

extension TimeOffset {
    // 当 isMax

    public var text: String {
        if isMax {
            return "结束时间"
        }
        // 如果全为 0， 开始时间
        if day == 0 && hour == 0 && year == 0 && month == 0 && week == 0 {
            return "开始时间"
        }
        return description
    }
}
