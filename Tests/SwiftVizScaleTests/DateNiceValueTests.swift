//
//  DateNiceValueTests.swift
//

import Foundation
import SwiftVizScale
import XCTest

final class DateNiceValueTests: XCTestCase {
    func formatterAndNow() -> (ISO8601DateFormatter, Date) {
        let f = ISO8601DateFormatter()
        f.formatOptions.insert(ISO8601DateFormatter.Options.withFractionalSeconds)
        let now = f.date(from: "2022-08-07T10:41:06.0110Z")!
        // 2022-08-08T22:43:09Z
        return (f, now)
    }

    let secMin: Double = 60
    let secHour: Double = 60 * 60
    let secDay: Double = 60 * 60 * 24
    let secMonth: Double = 60 * 60 * 24 * 28
    let secYear: Double = 60 * 60 * 24 * 365

    func testDateMagnitudes() throws {
        let (_, now) = formatterAndNow()
        XCTAssertEqual(DateMagnitude.magnitudeOfDateRange(now, now + 0.1), .subsecond)
        XCTAssertEqual(DateMagnitude.magnitudeOfDateRange(now, now + 1), .seconds)
        XCTAssertEqual(DateMagnitude.magnitudeOfDateRange(now, now + 6), .seconds)
        XCTAssertEqual(DateMagnitude.magnitudeOfDateRange(now, now + 60), .minutes)
        XCTAssertEqual(DateMagnitude.magnitudeOfDateRange(now, now + secHour), .hours)
        XCTAssertEqual(DateMagnitude.magnitudeOfDateRange(now, now + secDay), .days)
        XCTAssertEqual(DateMagnitude.magnitudeOfDateRange(now, now + secMonth), .months)
        XCTAssertEqual(DateMagnitude.magnitudeOfDateRange(now, now + secYear), .years(magnitude: 0))
    }

    func testCalendricalDateRounding() throws {
        let (formatter, now) = formatterAndNow()
        let result = now.round(magnitude: .seconds)
        XCTAssertEqual(formatter.string(from: result!), "2022-08-07T10:41:00.000Z")

        XCTAssertEqual(formatter.string(from: now.round(magnitude: .subsecond)!), "2022-08-07T10:41:06.010Z")
        XCTAssertEqual(formatter.string(from: now.round(magnitude: .seconds)!), "2022-08-07T10:41:00.000Z")
        XCTAssertEqual(formatter.string(from: now.round(magnitude: .minutes)!), "2022-08-07T10:00:00.000Z")
        XCTAssertEqual(formatter.string(from: now.round(magnitude: .hours)!), "2022-08-07T07:00:00.000Z")
        XCTAssertEqual(formatter.string(from: now.round(magnitude: .days)!), "2022-08-01T07:00:00.000Z")
        XCTAssertEqual(formatter.string(from: now.round(magnitude: .months)!), "2022-01-01T08:00:00.000Z")
        XCTAssertEqual(formatter.string(from: now.round(magnitude: .years(magnitude: 1.0))!), "2022-01-01T08:00:00.000Z")
    }
}
