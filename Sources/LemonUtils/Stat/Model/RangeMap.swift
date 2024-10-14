//
//  RangeMap.swift
//  LemonUtils
//
//  Created by Lu Ai on 2024/10/6.
//

import SwiftUI

public class RangeMap<T: Comparable, U> {
    public class Range {
        let start: T
        let end: T
        let value: U

        public init(start: T, end: T, value: U) {
            self.start = start
            self.end = end
            self.value = value
        }
    }

    private(set) var ranges: [Range]
    private(set) var specialPoints: [(T, U)]
    let defaultValue: U

    public init(ranges: [Range], specialPoints: [(T, U)], defaultValue: U) {
        self.ranges = ranges
        self.specialPoints = specialPoints
        self.defaultValue = defaultValue
    }

    func map(_ value: T) -> U {
        // 首先检查特殊点
        if let specialValue = specialPoints.first(where: { $0.0 == value })?.1 {
            return specialValue
        }

        // 然后检查范围
        for range in ranges {
            if value >= range.start && value < range.end {
                return range.value
            }
        }

        return defaultValue
    }

    // 添加方法来修改 ranges 和 specialPoints
    func addRange(_ range: Range) {
        ranges.append(range)
    }

    func addSpecialPoint(_ point: T, value: U) {
        specialPoints.append((point, value))
    }
}

let colorMap = RangeMap(
    ranges: [
        .init(start: 0, end: 0.25, value: Color.green),
        .init(start: 0.25, end: 0.5, value: Color.yellow),
        .init(start: 0.5, end: 0.75, value: Color.orange),
        .init(start: 0.75, end: 1, value: Color.red),
    ],
    specialPoints: [
        (0, .blue),
        (1, .purple),
    ],
    defaultValue: .gray
)
