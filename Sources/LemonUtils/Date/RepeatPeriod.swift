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
    let calendar = Calendar.current
    switch repeatPeriod {
    case .day:
        let days = calendar.dateComponents([.day], from: startDate, to: currentDate).day!
        return days % n == 0 ? 0 : n - days % n

    case .week:
        let days = calendar.dateComponents([.day], from: startDate, to: currentDate).day!
        let periodDays = n * 7
        return days % periodDays == 0 ? 0 : periodDays - days % periodDays

    case .month:
        let components = calendar.dateComponents([.month, .day], from: startDate, to: currentDate)
        let days = components.day!
        let months = components.month!
        if days == 0 && months % n == 0 {
            return 0
        }
        let targetMonth = n * ((months / n) + 1)
        let nextDate = calendar.date(byAdding: .month, value: targetMonth, to: startDate)!
        return calendar.dateComponents([.day], from: currentDate, to: nextDate).day!

    case .year:
        let components = calendar.dateComponents([.year, .day], from: startDate, to: currentDate)
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
public func checkRepeatDate(startDate: Date, currentDate: Date, repeatPeriod: RepeatPeriod, n: Int) -> Bool {
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
            }).frame(height: 80)
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
