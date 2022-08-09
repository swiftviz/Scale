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
        // let now = f.date(from: "2022-08-07T10:41:06.0110Z")!
        // turns out creating a date from ISO8601DateFormatter implicitly uses the local time zone...
        // So instead we'll construct it from components, being explicit about the time zone.
        let dateAsComponents = DateComponents(calendar: testCal, timeZone: TimeZone(identifier: "UTC"), year: 2022, month: 08, day: 08, hour: 22, minute: 43, second: 09, nanosecond: 11_000_000)
        assert(dateAsComponents.isValidDate)
        let now = testCal.date(from: dateAsComponents)!
        return (f, now)
    }

    let secMin: Double = 60
    let secHour: Double = 60 * 60
    let secDay: Double = 60 * 60 * 24
    let secMonth: Double = 60 * 60 * 24 * 28
    let secYear: Double = 60 * 60 * 24 * 365

    var testCal: Calendar {
        var testCal = Calendar(identifier: .iso8601)
        testCal.timeZone = TimeZone(identifier: "UTC")!
        return testCal
    }

    func testDateMagnitudes() throws {
        let (_, now) = formatterAndNow()
        XCTAssertEqual(DateMagnitude.magnitudeOfDateRange(now, now + 0.1), .subsecond)
        XCTAssertEqual(DateMagnitude.magnitudeOfDateRange(now, now + 1), .seconds)
        XCTAssertEqual(DateMagnitude.magnitudeOfDateRange(now, now + 6), .seconds)
        XCTAssertEqual(DateMagnitude.magnitudeOfDateRange(now, now + 60), .minutes)
        XCTAssertEqual(DateMagnitude.magnitudeOfDateRange(now, now + secHour), .hours)
        XCTAssertEqual(DateMagnitude.magnitudeOfDateRange(now, now + secDay), .days)
        XCTAssertEqual(DateMagnitude.magnitudeOfDateRange(now, now + secMonth), .months)
        XCTAssertEqual(DateMagnitude.magnitudeOfDateRange(now, now + secYear), .years(magnitude: 0, fraction: 1))
    }

    func testCalendricalDateRounding() throws {
        print(testCal.timeZone)
        let (formatter, now) = formatterAndNow()
        XCTAssertEqual(formatter.string(from: now), "2022-08-08T22:43:09.011Z")
        XCTAssertEqual(now.timeIntervalSinceReferenceDate, 681_691_389.011)

        let result = now.round(magnitude: .seconds, calendar: testCal)
        XCTAssertEqual(formatter.string(from: result!), "2022-08-08T22:43:09.000Z")

        XCTAssertEqual(
            formatter.string(from: now.round(magnitude: .subsecond, calendar: testCal)!),
            "2022-08-08T22:43:09.010Z"
        )

        XCTAssertEqual(
            formatter.string(from: now.round(magnitude: .seconds, calendar: testCal)!),
            "2022-08-08T22:43:09.000Z"
        )

        XCTAssertEqual(
            formatter.string(from: now.round(magnitude: .minutes, calendar: testCal)!),
            "2022-08-08T22:43:00.000Z"
        )

        XCTAssertEqual(
            formatter.string(from: now.round(magnitude: .hours, calendar: testCal)!),
            "2022-08-08T22:00:00.000Z"
        )

        XCTAssertEqual(
            formatter.string(from: now.round(magnitude: .days, calendar: testCal)!),
            "2022-08-08T00:00:00.000Z"
        )

        XCTAssertEqual(
            formatter.string(from: now.round(magnitude: .months, calendar: testCal)!),
            "2022-08-01T00:00:00.000Z"
        )

        XCTAssertEqual(
            formatter.string(from: now.round(magnitude: .years(magnitude: 1.0, fraction: 1.0), calendar: testCal)!),
            "2022-01-01T00:00:00.000Z"
        )
    }

    func testNiceStepForDateMagnitudes_subseconds() throws {
        XCTAssertEqual(Date.niceStepForMagnitude(step: 0.10, magnitude: .subsecond), 0.1)
        XCTAssertEqual(Date.niceStepForMagnitude(step: 0.11, magnitude: .subsecond), 0.2)
        XCTAssertEqual(Date.niceStepForMagnitude(step: 0.22, magnitude: .subsecond), 0.5)
        XCTAssertEqual(Date.niceStepForMagnitude(step: 0.54, magnitude: .subsecond), 1)

        XCTAssertEqual(Date.niceStepForMagnitude(step: 1.0, magnitude: .subsecond), 1)
        XCTAssertEqual(Date.niceStepForMagnitude(step: 1.1, magnitude: .subsecond), 2)
        XCTAssertEqual(Date.niceStepForMagnitude(step: 2.2, magnitude: .subsecond), 5)
        XCTAssertEqual(Date.niceStepForMagnitude(step: 5.4, magnitude: .subsecond), 10)
    }

    func testNiceStepForDateMagnitudes_seconds() throws {
        XCTAssertEqual(Date.niceStepForMagnitude(step: 0.2, magnitude: .seconds), 1)
        XCTAssertEqual(Date.niceStepForMagnitude(step: 1.2, magnitude: .seconds), 2)
        XCTAssertEqual(Date.niceStepForMagnitude(step: 4.3, magnitude: .seconds), 5)
        XCTAssertEqual(Date.niceStepForMagnitude(step: 5.3, magnitude: .seconds), 10)
        XCTAssertEqual(Date.niceStepForMagnitude(step: 15.3, magnitude: .seconds), 30)
    }

    func testNiceStepForDateMagnitudes_minutes() throws {
        XCTAssertEqual(Date.niceStepForMagnitude(step: 4.3, magnitude: .minutes), 60)
        XCTAssertEqual(Date.niceStepForMagnitude(step: 1.5 * 60, magnitude: .minutes), 60 * 2)
        XCTAssertEqual(Date.niceStepForMagnitude(step: 5.1 * 60, magnitude: .minutes), 60 * 10)
    }

    func testNiceStepForDateMagnitudes_hours() throws {
        XCTAssertEqual(Date.niceStepForMagnitude(step: 0.99 * 60 * 60, magnitude: .hours), 60 * 60 * 1)
        XCTAssertEqual(Date.niceStepForMagnitude(step: 4.3 * 60 * 60, magnitude: .hours), 60 * 60 * 6)
        XCTAssertEqual(Date.niceStepForMagnitude(step: 5.3 * 60 * 60, magnitude: .hours), 60 * 60 * 6)
        XCTAssertEqual(Date.niceStepForMagnitude(step: 15.3 * 60 * 60, magnitude: .hours), 60 * 60 * 12)
    }

    func testNiceStepForDateMagnitudes_days() throws {
        XCTAssertEqual(Date.niceStepForMagnitude(step: 0.99 * 24 * 60 * 60, magnitude: .days), 60 * 60 * 24)
        XCTAssertEqual(Date.niceStepForMagnitude(step: 1.2 * 24 * 60 * 60, magnitude: .days), 60 * 60 * 24 * 2)
        XCTAssertEqual(Date.niceStepForMagnitude(step: 6.8 * 24 * 60 * 60, magnitude: .days), 60 * 60 * 24 * 7)
    }

    func testNiceStepForDateMagnitudes_months() throws {
        XCTAssertEqual(Date.niceStepForMagnitude(step: 0.99 * 28 * 24 * 60 * 60, magnitude: .months), 28 * 24 * 60 * 60)
        XCTAssertEqual(Date.niceStepForMagnitude(step: 1.99 * 28 * 24 * 60 * 60, magnitude: .months), 28 * 24 * 60 * 60 * 2)
        XCTAssertEqual(Date.niceStepForMagnitude(step: 2.3 * 28 * 24 * 60 * 60, magnitude: .months), 28 * 24 * 60 * 60 * 6)
        XCTAssertEqual(Date.niceStepForMagnitude(step: 5.3 * 28 * 24 * 60 * 60, magnitude: .months), 28 * 24 * 60 * 60 * 6)
    }

    func testNiceStepForDateMagnitudes_years() throws {
        XCTAssertEqual(Date.niceStepForMagnitude(
            step: 1.1 * secYear,
            magnitude: .years(magnitude: 0, fraction: 1)
        ), 1 * secYear)

        XCTAssertEqual(Date.niceStepForMagnitude(
            step: 1.1 * secYear,
            magnitude: .years(magnitude: 0, fraction: 1.1)
        ), 2 * secYear)

        XCTAssertEqual(Date.niceStepForMagnitude(
            step: 3.1 * secYear,
            magnitude: .years(magnitude: 0, fraction: 3.1)
        ), 5 * secYear)

        XCTAssertEqual(Date.niceStepForMagnitude(
            step: 3.1 * 10 * secYear,
            magnitude: .years(magnitude: 1, fraction: 3.1)
        ), 50 * secYear)
    }

    func testNiceRangeAndStep_minutes_1() throws {
        let (formatter, now) = formatterAndNow()

        let dateMin = now
        let dateMax = now + 1.2 * secMin
        let (niceMin, step, niceMax) = Date.niceMinStepMax(min: dateMin, max: dateMax, ofSize: 10, calendar: testCal)
        XCTAssertTrue(niceMin <= dateMin)
        // print(formatter.string(from: dateMin))
        XCTAssertEqual(formatter.string(from: niceMin), "2022-08-08T22:43:00.000Z")
        XCTAssertEqual(step, 60) // 1 minute steps
        XCTAssertEqual(formatter.string(from: niceMax), "2022-08-08T22:45:00.000Z")
        // print(formatter.string(from: dateMax))
        XCTAssertTrue(niceMax >= dateMax)
    }

    func testNiceRangeAndStep_minutes_3() throws {
        let (formatter, now) = formatterAndNow()

        let dateMin = now
        let dateMax = now + 3.2 * secMin
        let (niceMin, step, niceMax) = Date.niceMinStepMax(min: dateMin, max: dateMax, ofSize: 10, calendar: testCal)
        XCTAssertTrue(niceMin <= dateMin)
        // print(formatter.string(from: dateMin))
        XCTAssertEqual(formatter.string(from: niceMin), "2022-08-08T22:43:00.000Z")
        XCTAssertEqual(step, 60) // 1 minute steps
        XCTAssertEqual(formatter.string(from: niceMax), "2022-08-08T22:47:00.000Z")
        // print(formatter.string(from: dateMax))
        XCTAssertTrue(niceMax >= dateMax)
    }

    func testNiceRangeAndStep_minutes_31() throws {
        let (formatter, now) = formatterAndNow()

        let dateMin = now
        let dateMax = now + 31.2 * secMin
        let (niceMin, step, niceMax) = Date.niceMinStepMax(min: dateMin, max: dateMax, ofSize: 10, calendar: testCal)
        XCTAssertTrue(niceMin <= dateMin)
        // print(formatter.string(from: dateMin))
        XCTAssertEqual(formatter.string(from: niceMin), "2022-08-08T22:43:00.000Z")
        XCTAssertEqual(step, 60 * 5) // 5 minute steps
        XCTAssertEqual(formatter.string(from: niceMax), "2022-08-08T23:19:00.000Z")
        // print(formatter.string(from: dateMax))
        XCTAssertTrue(niceMax >= dateMax)
    }

    func testDateTicks_minutes_31() throws {
        // NOTE(heckj): the minutes span seems like visually it should align to the local 5 minute
        // markers from the local calendar IF the step is 5 minutes.
        // Minute steps can be 1, 2, 5, and 10 minutes. Not sure the 1 and 2 minute steps matter,
        // but the 5 and 10 minute steps just reads "off" to me with this example.
        let (formatter, now) = formatterAndNow()

        let dateMin = now
        let dateMax = now + 31.2 * secMin
        let resultDates = Date.rangeOfNiceValues(min: dateMin, max: dateMax, ofSize: 10, using: testCal)
        XCTAssertEqual(resultDates.count, 8)

        // 31.x minutes results in 8 ticks, each 5 minutes apart,
        XCTAssertEqual(resultDates.map { formatter.string(from: $0) }, [
            "2022-08-08T22:43:00.000Z",
            "2022-08-08T22:48:00.000Z",
            "2022-08-08T22:53:00.000Z",
            "2022-08-08T22:58:00.000Z",
            "2022-08-08T23:03:00.000Z",
            "2022-08-08T23:08:00.000Z",
            "2022-08-08T23:13:00.000Z",
            "2022-08-08T23:18:00.000Z",
        ])
        XCTAssertTrue(resultDates.first! <= dateMin)
        XCTAssertTrue(resultDates.last! >= dateMax)
    }

    func testDateTicks_hours_11() throws {
        let (formatter, now) = formatterAndNow()

        let dateMin = now
        let dateMax = now + 11.1 * secHour
        let resultDates = Date.rangeOfNiceValues(min: dateMin, max: dateMax, ofSize: 10, using: testCal)
        XCTAssertEqual(resultDates.count, 8)

        // 31.x minutes results in 8 ticks, each 2 hours apart,
        XCTAssertEqual(resultDates.map { formatter.string(from: $0) }, [
            "2022-08-08T22:00:00.000Z",
            "2022-08-09T00:00:00.000Z",
            "2022-08-09T02:00:00.000Z",
            "2022-08-09T04:00:00.000Z",
            "2022-08-09T06:00:00.000Z",
            "2022-08-09T08:00:00.000Z",
            "2022-08-09T10:00:00.000Z",
            "2022-08-09T12:00:00.000Z",
        ])
        XCTAssertTrue(resultDates.first! <= dateMin)
        XCTAssertTrue(resultDates.last! >= dateMax)
    }

    func testDateTicks_days_23() throws {
        let (formatter, now) = formatterAndNow()

        let dateMin = now
        let dateMax = now + 23.1 * secDay
        let resultDates = Date.rangeOfNiceValues(min: dateMin, max: dateMax, ofSize: 10, using: testCal)
        XCTAssertEqual(resultDates.count, 5)

        // 23.1 days results in 5 ticks, each 7 days apart,
        XCTAssertEqual(resultDates.map { formatter.string(from: $0) }, [
            "2022-08-08T00:00:00.000Z",
            "2022-08-15T00:00:00.000Z",
            "2022-08-22T00:00:00.000Z",
            "2022-08-29T00:00:00.000Z",
            "2022-09-05T00:00:00.000Z",
        ])
        XCTAssertTrue(resultDates.first! <= dateMin)
        XCTAssertTrue(resultDates.last! >= dateMax)
    }
}
