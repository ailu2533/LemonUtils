import SwiftUI

public enum TimeUnit {
    case year, month, day, hour, minute, second
}

public struct TimeOffsetPickerView: View {
    @Binding var timeOffset: TimeOffset // Binding to the TimeOffset structure
    var units: Set<TimeUnit>

    private let yearData = Array(0 ..< 100).map { "\($0) 年" }
    private let monthData = Array(0 ..< 100).map { "\($0) 月" }
    private let dayData = Array(0 ..< 100).map { "\($0) 天" }
    private let hourData = Array(0 ..< 24).map { "\($0) 时" }
    private let minuteData = Array(0 ..< 60).map { "\($0) 分" }
    private let secondData = Array(0 ..< 60).map { "\($0) 秒" }

    public init(timeOffset: Binding<TimeOffset>, units: Set<TimeUnit>) {
        _timeOffset = timeOffset
        self.units = units
    }

    public var body: some View {
        let selectionsBinding = Binding(get: {
            var values = [Int]()
            if units.contains(.year) {
                values.append(timeOffset.year)
            }
            if units.contains(.month) {
                values.append(timeOffset.month)
            }
            if units.contains(.day) {
                values.append(timeOffset.day)
            }
            if units.contains(.hour) {
                values.append(timeOffset.hour)
            }
            if units.contains(.minute) {
                values.append(timeOffset.minute)
            }
            if units.contains(.second) {
                values.append(timeOffset.second)
            }
            return values
        }, set: { newValue in
            timeOffset.isMax = false
            var index = 0
            if units.contains(.year) {
                timeOffset.year = newValue[index]
                index += 1
            }
            if units.contains(.month) {
                timeOffset.month = newValue[index]
                index += 1
            }
            if units.contains(.day) {
                timeOffset.day = newValue[index]
                index += 1
            }
            if units.contains(.hour) {
                timeOffset.hour = newValue[index]
                index += 1
            }
            if units.contains(.minute) {
                timeOffset.minute = newValue[index]
                index += 1
            }
            if units.contains(.second) {
                timeOffset.second = newValue[index]
            }
        })

        VStack {
            MultiComponentPickerView(data: createDataArray(), selections: selectionsBinding)
                .frame(height: 200)
        }
    }

    private func createDataArray() -> [[String]] {
        var data: [[String]] = []
        if units.contains(.year) {
            data.append(yearData)
        }
        if units.contains(.month) {
            data.append(monthData)
        }
        if units.contains(.day) {
            data.append(dayData)
        }
        if units.contains(.hour) {
            data.append(hourData)
        }
        if units.contains(.minute) {
            data.append(minuteData)
        }
        if units.contains(.second) {
            data.append(secondData)
        }
        return data
    }
}

struct TimeOffsetPickerView_Previews: PreviewProvider {
    @State static var timeOffset = TimeOffset()

    static var previews: some View {
        TimeOffsetPickerView(timeOffset: $timeOffset, units: [.year, .month, .day, .hour, .minute, .second])
    }
}
