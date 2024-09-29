//
//  CalendarCell.swift
//  LemonUtils
//
//  Created by Lu Ai on 2024/9/20.
//
import SwiftUI

public struct CalendarCell: View {
    let viewModel: CalendarHeatmapViewModel
    let rowIndex: Int
    let columnIndex: Int

    public init(viewModel: CalendarHeatmapViewModel, rowIndex: Int, columnIndex: Int) {
        self.viewModel = viewModel
        self.rowIndex = rowIndex
        self.columnIndex = columnIndex
    }

    public var body: some View {
        let index = rowIndex * viewModel.numOfColumns + columnIndex
        RoundedRectangle(cornerRadius: 4)
            .fill(viewModel.fillColor(for: index))
            .frame(width: viewModel.cellSize, height: viewModel.cellSize)
    }
}
