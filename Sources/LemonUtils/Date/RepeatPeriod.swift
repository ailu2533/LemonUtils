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
public func calculateNearestRepeatDate(startDate: Date, currentDate: Date, repeatPeriod: RepeatPeriod, n: Int) -> Int {
    switch repeatPeriod {
    case .day:
        let diffs = Calendar.current.dateComponents([.day], from: startDate, to: currentDate)
        let day = diffs.day!

        if day % n == 0 {
            return 0
        }

        return n - day % n

    case .week:
        let diffs = Calendar.current.dateComponents([.day], from: startDate, to: currentDate)

        let day = diffs.day!

        let nday = n * 7

        if day % nday == 0 {
            return 0
        }

        return nday - day % nday

    case .month:
        let diffs = Calendar.current.dateComponents([.month, .day], from: startDate, to: currentDate)

        let day = diffs.day!
        let month = diffs.month!

        if day == 0 && month % n == 0 {
            return 0
        }

        let nMonth = n * (month / n) + n

        let nextDate = startDate.offset(.month, value: nMonth)!

        let diffs2 = Calendar.current.dateComponents([.day], from: currentDate, to: nextDate)

        return diffs2.day!

    case .year:
        let diffs = Calendar.current.dateComponents([.year, .day], from: startDate, to: currentDate)

        let day = diffs.day!
        let year = diffs.year!

        if day == 0 && year % n == 0 {
            return 0
        }

        let nYear = n * (year / n) + n

        let nextDate = startDate.offset(.year, value: nYear)!

        let diffs2 = Calendar.current.dateComponents([.day], from: currentDate, to: nextDate)

        return diffs2.day!
    }
}

//  判断currentDate与 startDate之间是否距离n个周期
public func checkRepeatDate(startDate: Date, currentDate: Date, repeatPeriod: RepeatPeriod, n: Int) -> Bool {
    switch repeatPeriod {
    case .day:
        let diffs = Calendar.current.dateComponents([.day], from: startDate, to: currentDate)
        let day = diffs.day!
        return day % n == 0
    case .week:
        let diffs = Calendar.current.dateComponents([.day], from: startDate, to: currentDate)

        let day = diffs.day!

        if day % 7 != 0 {
            return false
        }

        let week = day / 7

        return week % n == 0
    case .month:
        let diffs = Calendar.current.dateComponents([.month, .day], from: startDate, to: currentDate)

        let day = diffs.day!
        if day != 0 {
            return false
        }

        let month = diffs.month!
        return month % n == 0

    case .year:
        let diffs = Calendar.current.dateComponents([.year, .day], from: startDate, to: currentDate)

        let day = diffs.day!
        if day != 0 {
            return false
        }

        let year = diffs.year!
        return year % n == 0
    }
}

public struct RepeatPeriodPickerView: View {
    @Binding var repeatPeriod: RepeatPeriod
    @Binding var repeatN: Int

    @State private var selections: [Int] = [0, 0]

    public init(repeatPeriod: Binding<RepeatPeriod>, repeatN: Binding<Int>) {
        _repeatPeriod = repeatPeriod
        _repeatN = repeatN
    }

    private let data: [[String]] = [
        Array(1 ..< 30).map {
            "\($0)"
        },

        RepeatPeriod.allCases.map {
            $0.text
        },
    ]

    public var body: some View {
        MultiComponentPickerView(data: self.data, selections: self.$selections)
            .onChange(of: selections[0], { _, _ in
                repeatN = selections[0] + 1
            })
            .onChange(of: selections[1], { _, _ in
                repeatPeriod = RepeatPeriod(rawValue: selections[1]) ?? .day
            })
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
