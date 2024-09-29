//
//  CalendarHeatmap.swift
//  MyHabit
//
//  Created by ailu on 2024/4/2.
//

import DateHelper
import SwiftUI

public struct CalendarHeatmapView2: View {
    private let viewModel: CalendarHeatmapViewModel

    public init(data: GridViewItem, colors: [Color], cellSize: CGFloat = 18, spacing: CGFloat = 5, numOfColumns: Int = 7) {
        viewModel = CalendarHeatmapViewModel(data: data, colors: colors, cellSize: cellSize, spacing: spacing, numOfColumns: numOfColumns)
    }

    public var body: some View {
        CalendarGrid(viewModel: viewModel)
    }
}

public struct CalendarGrid: View {
    let viewModel: CalendarHeatmapViewModel

    public init(viewModel: CalendarHeatmapViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Grid(horizontalSpacing: viewModel.spacing, verticalSpacing: viewModel.spacing) {
            ForEach(0 ..< viewModel.rowCount, id: \.self) { rowIndex in
                GridRow {
                    ForEach(0 ..< viewModel.numOfColumns, id: \.self) { columnIndex in
                        CalendarCell(viewModel: viewModel, rowIndex: rowIndex, columnIndex: columnIndex)
                    }
                }
            }
        }
    }
}
