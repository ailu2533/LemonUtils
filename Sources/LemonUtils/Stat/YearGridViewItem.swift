//
//  YearGridViewItem.swift
//  LemonUtils
//
//  Created by Lu Ai on 2024/9/20.
//
import LemonDateUtils
import SwiftUI

public struct YearGridViewItem: Identifiable {
    // Unique identifier for each grid item.
    public let id: UUID
    // Title displayed in the grid row.
    public let title: String
    // Color used for the filled cells in the grid.
    let color: Color
    // Dictionary mapping day of the week to a statistic value.
    public let sortValue: Double
    public let stat: [YearMonthDay: Double]

    public var date: Date
    public var year: Int

    public init(id: UUID, title: String, color: Color, date: Date, sortValue: Double = 0, stat: [YearMonthDay: Double]) {
        self.id = id
        self.title = title
        self.color = color
        self.stat = stat
        self.date = date
        self.sortValue = sortValue
        year = date.component(.year) ?? 2024
    }
}
