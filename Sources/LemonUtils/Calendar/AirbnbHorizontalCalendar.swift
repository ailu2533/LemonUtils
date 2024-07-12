import Combine
import HorizonCalendar
import LemonDateUtils
import SwiftUI
import UIKit

extension YearMonthDay {
    public static func fromDayComponents(_ date: DayComponents) -> YearMonthDay {
        let year = date.month.year
        let month = date.month.month
        let day = date.day

        return .init(year: year, month: month, day: day)
    }
}

public struct SwiftUIDayView: View {
    let dayNumber: Int
    let isSelected: Bool
    let isMarked: Bool

    public var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .fill(isMarked ? Color(.buttonOrange) : .clear)
                .strokeBorder(isSelected ? Color.accentColor : .clear, lineWidth: 2)
                .background {
                    Circle()
                        .foregroundColor(isSelected ? Color(UIColor.systemBackground) : .clear)
                }
                .aspectRatio(1, contentMode: .fill)
            Text("\(dayNumber)").foregroundColor(Color(UIColor.label))
                .fontWeight(.medium)
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
        .frame(width: 30, height: 30)
    }

    // MARK: Private

    private static let calendar = Calendar.current
}

public class CalendarConfiguration {
    public var calendar: Calendar = Calendar.current

    public var monthsLayout: MonthsLayout = .horizontal
    public var endDate: Date = .now
    public var startDate: Date = .now.offset(.year, value: -1)!

    public var dateFormatTemplate: String = "MMMM yyyy"

    public var tapCallback: (DayComponents) -> Void = { _ in } // 回调通常不需要被观察

    public var isDayMarkedCallback: (YearMonthDay) -> Bool = { _ in false }

    public init(isDayMarkedCallback: @escaping (YearMonthDay) -> Bool) {
        self.isDayMarkedCallback = isDayMarkedCallback
    }
}

@available(macOS 10.15, *)
public struct CalendarView: View {
    @Binding public var selectedDate: YearMonthDay
    @Binding public var visibleFirstDay: YearMonthDay?
    public var config: CalendarConfiguration

    public init(selectedDate: Binding<YearMonthDay>, visibleFirstDay: Binding<YearMonthDay?>, config: CalendarConfiguration) {
        _selectedDate = selectedDate
        _visibleFirstDay = visibleFirstDay
        self.config = config

        monthDateFormatter = DateFormatter()
        let calendar = config.calendar
        monthDateFormatter.calendar = calendar
        monthDateFormatter.locale = calendar.locale
        monthDateFormatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "MMMM yyyy",
            options: 0,
            locale: calendar.locale ?? Locale.current)
    }

    private let monthDateFormatter: DateFormatter

    private var visibleDateRange: ClosedRange<Date> {
        config.startDate ... config.endDate
    }

    @StateObject private var calendarViewProxy = CalendarViewProxy()
    @State private var selectedDayRange: DayComponentsRange?
    @State private var selectedDayRangeAtStartOfDrag: DayComponentsRange?

    public var body: some View {
        let view = CalendarViewRepresentable(
            calendar: config.calendar,
            visibleDateRange: visibleDateRange,
            monthsLayout: config.monthsLayout,
            dataDependency: selectedDayRange,
            proxy: calendarViewProxy
        )

        configureCalendarView(view)
            .onAppear {
                calendarViewProxy.scrollToMonth(containing: selectedDate.date(), scrollPosition: .centered, animated: false)
            }
            .frame(maxWidth: 375, maxHeight: .infinity)
    }

    private func configureCalendarView(_ view: CalendarViewRepresentable) -> CalendarViewRepresentable {
        view
//            .interMonthSpacing(8)
            .monthDayInsets(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
            .verticalDayMargin(8)
            .horizontalDayMargin(8)
            .backgroundColor(UIColor.clear)
            .monthHeaders { month in
                let date = config.calendar.date(from: month.components)!
                let monthHeaderText = monthDateFormatter.string(from: date)
                Group {
                    if case .vertical = config.monthsLayout {
                        HStack {
                            Text(monthHeaderText).font(.title2)
                            Spacer()
                        }.padding()
                    } else {
                        Text(monthHeaderText).font(.title2).padding()
                    }
                }.accessibilityAddTraits(.isHeader)
            }
            .days { day in
                SwiftUIDayView(dayNumber: day.day, isSelected: isDaySelected(day), isMarked: isDayMarked(day))
                    .onTapGesture {
                        config.tapCallback(day)
                    }
            }
            .onDaySelection { day in
                selectedDate = YearMonthDay.fromDayComponents(day)
            }
            .onDeceleratingEnd { visibleDayRange in
                let lb = visibleDayRange.lowerBound
                visibleFirstDay = YearMonthDay(year: lb.month.year, month: lb.month.month, day: lb.day)
            }
    }

    private func isDaySelected(_ day: DayComponents) -> Bool {
        if let range = selectedDayRange {
            return day == range.lowerBound || day == range.upperBound
        } else {
            return YearMonthDay.fromDayComponents(day) == selectedDate
        }
    }

    private func isDayMarked(_ day: DayComponents) -> Bool {
        return config.isDayMarkedCallback(YearMonthDay.fromDayComponents(day))
    }
}
