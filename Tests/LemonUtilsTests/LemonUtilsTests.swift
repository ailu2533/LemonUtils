@testable import LemonUtils
import XCTest

final class LemonUtilsTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }

    func testStartOfWeek() {
        let date = Date()
        let startOfWeek = date.startOfWeek

        // Verify that the startOfWeek date is indeed the first day of the current week
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: startOfWeek!)
        XCTAssertEqual(components.day, 15) // Sunday is 1 in Calendar

        // Check if the startOfWeek date is within the same week as the original date
        let sameWeekComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        let startOfWeekComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startOfWeek!)
        XCTAssertEqual(sameWeekComponents.yearForWeekOfYear, startOfWeekComponents.yearForWeekOfYear)
        XCTAssertEqual(sameWeekComponents.weekOfYear, startOfWeekComponents.weekOfYear)
    }
}
