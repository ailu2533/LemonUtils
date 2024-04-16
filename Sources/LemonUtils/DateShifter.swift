//
//  DateShifter.swift
//  MyHabit
//
//  Created by ailu on 2024/4/2.
//

import SwiftUI

enum DateShiftType: String, CaseIterable, Identifiable {
    var id: Self {
        self
    }

    case day
    case week
    case month
}

struct DateShifter: View {
    @Binding private var inputDate: Date

    private let shiftType: DateShiftType

    init(inputDate: Binding<Date>, shiftType: DateShiftType = .day) {
        _inputDate = inputDate
        self.shiftType = shiftType
    }

    var body: some View {
        HStack {
            DateShiftButton(direction: .backward, shiftType: shiftType, inputDate: $inputDate)

            Spacer().overlay {
                Text(inputDate.formatted(date: .abbreviated, time: .omitted))
            }

            DateShiftButton(direction: .forward, shiftType: shiftType, inputDate: $inputDate)
        }
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
