//
//  DateShifter.swift
//  MyHabit
//
//  Created by ailu on 2024/4/2.
//

import SwiftUI

public enum DateShiftType: String, CaseIterable, Identifiable {
    public var id: Self {
        self
    }

    case day
    case week
    case month
    case year
}

public struct DateShifter: View {
    @Binding private var inputDate: Date

    private let shiftType: DateShiftType

    public init(inputDate: Binding<Date>, shiftType: DateShiftType = .day) {
        _inputDate = inputDate
        self.shiftType = shiftType
    }

    public var body: some View {
        HStack {
            DateShiftButton(direction: .backward, shiftType: shiftType, inputDate: $inputDate)

            Spacer().overlay {
                Text(formattedDate(inputDate: inputDate, shiftType: shiftType))
            }
            DateShiftButton(direction: .forward, shiftType: shiftType, inputDate: $inputDate)
        }
        .padding()
        .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    /// 根据 shiftType 格式化日期
    private func formattedDate(inputDate: Date, shiftType: DateShiftType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current // 设置为中文环境
        switch shiftType {
        case .month:
            dateFormatter.setLocalizedDateFormatFromTemplate("yyyyMM")  // 年-月 格式
        case .week:
            dateFormatter.setLocalizedDateFormatFromTemplate("yyyy'W'ww")  // 年-第几周 格式
        case .year:
            dateFormatter.setLocalizedDateFormatFromTemplate("yyyy") // 使用本地化的年份格式
        default:
            dateFormatter.setLocalizedDateFormatFromTemplate("Md")  // 月日格式，如 "6 月 25 日"
        }
        return dateFormatter.string(from: inputDate)
    }
}

struct DateShiftButton: View {
    let direction: Direction
    let shiftType: DateShiftType
    @Binding var inputDate: Date

    var body: some View {
        Button(action: {
            switch shiftType {
            case .day:
                inputDate = (direction == .backward ? inputDate.prevDay! : inputDate.nextDay!)
            case .week:
                inputDate = (direction == .backward ? inputDate.prevWeek! : inputDate.nextWeek!)
            case .month:
                inputDate = (direction == .backward ? inputDate.prevMonth! : inputDate.nextMonth!)
            case .year:
                inputDate = (direction == .backward ? inputDate.prevYear! : inputDate.nextYear!)
            }
        }, label: {
            Image(systemName: direction == .backward ? "chevron.backward" : "chevron.forward")
        })
    }
}

enum Direction: String, CaseIterable {
    case backward
    case forward
}

struct DateShiftView: View {
    @State private var inputDate = Date()

    var body: some View {
        DateShifter(inputDate: $inputDate, shiftType: .week)
    }
}

#Preview {
    DateShiftView()
}
