//
//  File.swift
//  LemonUtils
//
//  Created by Lu Ai on 2024/9/26.
//

import Foundation


public func clip<T: Comparable>(_ value: T, min minValue: T, max maxValue: T) -> T {
    return min(max(value, minValue), maxValue)
}
