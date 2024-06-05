

import HorizonCalendar
import SwiftUI

import UIKit

public struct SwiftUIDayView: View {
    let dayNumber: Int
    let isSelected: Bool
    let isMarked: Bool

    public var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .fill(isMarked ? Color.blue.opacity(0.2) : .clear)
                .strokeBorder(isSelected ? Color.accentColor : .clear, lineWidth: 2)
                .background {
                    Circle()
                        .foregroundColor(isSelected ? Color(UIColor.systemBackground) : .clear)
                }
                .aspectRatio(1, contentMode: .fill)
            Text("\(dayNumber)").foregroundColor(Color(UIColor.label))
        }
        .accessibilityAddTraits(.isButton)
    }
}

// MARK: - SwiftUIDayView_Previews

struct SwiftUIDayView_Previews: PreviewProvider {
    // MARK: Internal

    static var previews: some View {
        Group {
            SwiftUIDayView(dayNumber: 1, isSelected: false, isMarked: true)
            SwiftUIDayView(dayNumber: 19, isSelected: false, isMarked: true)
            SwiftUIDayView(dayNumber: 27, isSelected: true, isMarked: true)
        }
        .frame(width: 50, height: 50)
    }

    // MARK: Private

    private static let calendar = Calendar.current
}

@available(macOS 10.15, *)
public struct CalendarView: View {
    // MARK: Lifecycle

    @Binding private var selectedDate: YearMonthDay

    @Binding private var visibleFirstDay: YearMonthDay?

    var markedDates: Set<YearMonthDay> = Set()

    // 点击日期回调
    var tapCallback: (DayComponents) -> Void

    public init(calendar: Calendar, monthsLayout: MonthsLayout, callback: @escaping (DayComponents) -> Void = { _ in }) {
        self.calendar = calendar
        self.monthsLayout = monthsLayout

        let startDate = calendar.date(from: DateComponents(year: 2023, month: 01, day: 01))!
        let endDate = calendar.date(from: DateComponents(year: 2026, month: 12, day: 31))!
        visibleDateRange = startDate ... endDate

        monthDateFormatter = DateFormatter()
        monthDateFormatter.calendar = calendar
        monthDateFormatter.locale = calendar.locale
        monthDateFormatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "MMMM yyyy",
            options: 0,
            locale: calendar.locale ?? Locale.current)

        tapCallback = callback
        _selectedDate = .constant(YearMonthDay.fromDate(.now))
        _visibleFirstDay = .constant(YearMonthDay.fromDate(.now))
    }

    public init(calendar: Calendar, monthsLayout: MonthsLayout, markedDates: Set<YearMonthDay>, selectedDate: Binding<YearMonthDay>, visibleFirstDay: Binding<YearMonthDay?>, callback: @escaping (DayComponents) -> Void = { _ in }) {
        self.init(calendar: calendar, monthsLayout: monthsLayout, callback: callback)
        self.markedDates = markedDates
        _selectedDate = selectedDate
        _visibleFirstDay = visibleFirstDay
    }

    // MARK: Internal

    public var body: some View {
        CalendarViewRepresentable(
            calendar: calendar,
            visibleDateRange: visibleDateRange,
            monthsLayout: monthsLayout,
            dataDependency: selectedDayRange,
            proxy: calendarViewProxy)

            .interMonthSpacing(24)
            .verticalDayMargin(8)
            .horizontalDayMargin(8)

//            // TODO:
//            .onDragEnd({ visibleDayRange, willDecelerate in
//                print("dragEnd \(visibleDayRange.lowerBound) \(willDecelerate)")
//            })
            .onDeceleratingEnd({ visibleDayRange in
                visibleFirstDay = YearMonthDay.fromDayComponents(visibleDayRange.lowerBound)
                print(visibleDayRange.lowerBound)
            })

            .monthHeaders { month in

                let monthHeaderText = monthDateFormatter.string(from: calendar.date(from: month.components)!)
                Group {
                    if case .vertical = monthsLayout {
                        HStack {
                            Text(monthHeaderText)
                                .font(.title2)
                            Spacer()
                        }
                        .padding()
                    } else {
                        Text(monthHeaderText)
                            .font(.title2)
                            .padding()
                    }
                }
                .accessibilityAddTraits(.isHeader)
            }

            .days { day in
                SwiftUIDayView(dayNumber: day.day, isSelected: isDaySelected(day), isMarked: isDayMarked(day))
                    .onTapGesture(perform: {
                        tapCallback(day)
                    })
            }

            .onDaySelection { day in
                selectedDate = YearMonthDay.fromDayComponents(day)
            }

            .onAppear {
                calendarViewProxy.scrollToMonth(containing: .now, scrollPosition: .centered, animated: false)
            }

            .frame(maxWidth: 375, maxHeight: .infinity)
    }

    // MARK: Private

    private let calendar: Calendar
    private let monthsLayout: MonthsLayout
    private let visibleDateRange: ClosedRange<Date>

    private let monthDateFormatter: DateFormatter

    @StateObject private var calendarViewProxy = CalendarViewProxy()

    @State private var selectedDayRange: DayComponentsRange?
    @State private var selectedDayRangeAtStartOfDrag: DayComponentsRange?

    private func isDaySelected(_ day: DayComponents) -> Bool {
        if let selectedDayRange {
            return day == selectedDayRange.lowerBound || day == selectedDayRange.upperBound
        } else {
            return YearMonthDay.fromDayComponents(day) == selectedDate
        }
    }

    private func isDayMarked(_ day: DayComponents) -> Bool {
        return markedDates.contains(YearMonthDay.fromDayComponents(day))
    }
}

// MARK: - SwiftUIScreenDemo_Previews

#Preview("vertical") {
    CalendarView(calendar: Calendar.current, monthsLayout: .vertical)
}

//#Preview("horizontal") {
//    CalendarView(calendar: Calendar.current, monthsLayout: .horizontal, markedDates: [.init(year: 2024, month: 4, day: 2, weekday: 0), .init(year: 2024, month: 4, day: 3, weekday: 0), .init(year: 2024, month: 4, day: 4, weekday: 0),
//        ], selectedDate: .constant(YearMonthDay.fromDate(.now))
//    )
//}
