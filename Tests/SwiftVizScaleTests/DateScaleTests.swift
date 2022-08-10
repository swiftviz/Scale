//
//  DateScaleTests.swift
//

@testable import SwiftVizScale
import XCTest

final class DateScaleTests: XCTestCase {
    let now = ISO8601DateFormatter().date(from: "2022-08-07T10:41:00+0000")!

    func testScaleDescription() throws {
        let myScale = DateScale<CGFloat>(lower: now, higher: now.addingTimeInterval(500))

        XCTAssertEqual(String(describing: myScale), "linear(xform:none)[2022-08-07 10:41:00 +0000:2022-08-07 10:49:20 +0000]->[nil:nil]")

        let clampedScale = myScale.transform(.clamp)
        XCTAssertEqual(String(describing: clampedScale), "linear(xform:clamp)[2022-08-07 10:41:00 +0000:2022-08-07 10:49:20 +0000]->[nil:nil]")
    }

    func testProps() throws {
        let myScale = DateScale<CGFloat>(lower: now, higher: now.addingTimeInterval(500))
        XCTAssertEqual(myScale.desiredTicks, 10)
    }

    func testDateConversionAssumptions() throws {
        XCTAssertEqual(now.timeIntervalSinceReferenceDate, 681_561_660.0)
    }

    func testDomainModifiers() throws {
        let myScale = DateScale<CGFloat>(lower: now, higher: now.addingTimeInterval(500))
        let updated = myScale.domain(lower: now.addingTimeInterval(-500), higher: now)
        XCTAssertEqual(updated.domainLower, now.addingTimeInterval(-500))
        XCTAssertEqual(updated.domainHigher, now)

        let dateSet = [now, now.addingTimeInterval(-600), now.addingTimeInterval(600)]
        let setUpdated = updated.domain(dateSet)
        XCTAssertEqual(setUpdated.domainLower, now.addingTimeInterval(-600))
        XCTAssertEqual(setUpdated.domainHigher, now.addingTimeInterval(600))
    }

    func testTransformModifier() throws {
        let myScale = DateScale<CGFloat>(lower: now, higher: now.addingTimeInterval(500))
        XCTAssertEqual(myScale.transformType, .none)
        let updated = myScale.transform(.clamp)
        XCTAssertEqual(updated.transformType, .clamp)
    }

    func testScaleTypeModifier() throws {
        let myScale = DateScale<CGFloat>(lower: now, higher: now.addingTimeInterval(500))
        XCTAssertEqual(myScale.scaleType, .linear)
        let updated = myScale.scaleType(.log)
        XCTAssertEqual(updated.scaleType, .log)
    }

    func testRangeModifier() throws {
        let myScale = DateScale<CGFloat>(lower: now, higher: now.addingTimeInterval(500))
        XCTAssertNil(myScale.rangeLower)
        XCTAssertNil(myScale.rangeHigher)
        XCTAssertEqual(myScale.reversed, false)
        var updated = myScale.range(lower: 0, higher: 100)
        XCTAssertEqual(updated.rangeLower, 0)
        XCTAssertEqual(updated.rangeHigher, 100)
        XCTAssertEqual(myScale.reversed, false)
        updated = updated.range(reversed: true, lower: 0, higher: 100)
        XCTAssertEqual(updated.rangeLower, 0)
        XCTAssertEqual(updated.rangeHigher, 100)
        XCTAssertEqual(updated.reversed, true)

        updated = updated.range(reversed: false, 50 ... 200)
        XCTAssertEqual(updated.rangeLower, 50)
        XCTAssertEqual(updated.rangeHigher, 200)
        XCTAssertEqual(updated.reversed, false)

        updated = updated.range(100 ... 250)
        XCTAssertEqual(updated.rangeLower, 100)
        XCTAssertEqual(updated.rangeHigher, 250)
        XCTAssertEqual(updated.reversed, false)
    }

    func testScalingOutput() throws {
        let myScale = DateScale<CGFloat>(lower: now, higher: now.addingTimeInterval(600)).range(0 ... 100)
        XCTAssertEqual(myScale.scale(now.addingTimeInterval(300)), 50)
    }

    func testInvertOutput() throws {
        let myScale = DateScale<CGFloat>(lower: now, higher: now.addingTimeInterval(600)).range(0 ... 100).transform(.drop)
        XCTAssertEqual(myScale.invert(25), now.addingTimeInterval(150))

        XCTAssertNil(myScale.invert(250))
    }

    var testFormatter: Formatter {
        let f = ISO8601DateFormatter()
        f.formatOptions.insert(ISO8601DateFormatter.Options.withFractionalSeconds)
        return f
    }

    var testCal: Calendar {
        var testCal = Calendar(identifier: .iso8601)
        testCal.timeZone = TimeZone(identifier: "UTC")!
        return testCal
    }

    var testNow: Date {
        let dateAsComponents = DateComponents(calendar: testCal, timeZone: TimeZone(identifier: "UTC"), year: 2022, month: 08, day: 08, hour: 22, minute: 43, second: 09, nanosecond: 11_000_000)
        assert(dateAsComponents.isValidDate)
        return testCal.date(from: dateAsComponents)!
    }

    let secMin: Double = 60
    let secHour: Double = 60 * 60
    let secDay: Double = 60 * 60 * 24
    let secMonth: Double = 60 * 60 * 24 * 28
    let secYear: Double = 60 * 60 * 24 * 365

    func testValidDateTickValues() throws {
        let myScale = DateScale<CGFloat>(lower: testNow, higher: testNow.addingTimeInterval(600)).range(0 ... 100).transform(.drop)

        let startSecs = testNow.timeIntervalSinceReferenceDate

        var testValues: [Date] = []
        for aValue in stride(from: startSecs - 200, to: startSecs + 800, by: 100) {
            testValues.append(Date(timeIntervalSinceReferenceDate: aValue))
        }
        XCTAssertEqual(testValues.count, 10)
        let resultValues = myScale.validTickValues(testValues)
        XCTAssertEqual(resultValues.count, 7)
        // print(testValues)
        // print(resultValues)

        let otherResults = myScale.validTickValues(testValues, formatter: testFormatter)
        XCTAssertEqual(otherResults.count, 7)
        // print(otherResults)
    }

    func testDateTickFromValues() throws {
        let myScale = DateScale<CGFloat>(lower: testNow, higher: testNow.addingTimeInterval(600))

        let startSecs = testNow.timeIntervalSinceReferenceDate

        var testValues: [Date] = []
        for aValue in stride(from: startSecs - 200, to: startSecs + 800, by: 100) {
            testValues.append(Date(timeIntervalSinceReferenceDate: aValue))
        }
        XCTAssertEqual(testValues.count, 10)

        let ticks = myScale.ticksFromValues(testValues, from: 0, to: 100, formatter: testFormatter)
        XCTAssertEqual(ticks.count, 7)
    }

    func testDefaultTickValues_10min() throws {
        let myScale = DateScale<CGFloat>(lower: testNow, higher: testNow.addingTimeInterval(600)).range(0 ... 100).transform(.drop)

        let ticks = myScale.defaultTickValues(formatter: testFormatter, calendar: testCal)

        XCTAssertEqual(ticks.count, 7)
        XCTAssertEqual(ticks, [
            "2022-08-08T22:43:09.011Z",
            "2022-08-08T22:45:09.011Z",
            "2022-08-08T22:47:09.011Z",
            "2022-08-08T22:49:09.011Z",
            "2022-08-08T22:51:09.011Z",
            "2022-08-08T22:53:09.011Z",
            "2022-08-08T22:55:09.011Z",
        ])

        let localFormattedTicks = myScale.defaultTickValues()
        XCTAssertEqual(localFormattedTicks.count, 7)
        // print(localFormattedTicks)
    }

    func testDefaultTickValues_6_1hr() throws {
        let myScale = DateScale<CGFloat>(lower: testNow, higher: testNow.addingTimeInterval(6.1 * secHour))
        let ticks = myScale.ticks(reversed: false, rangeLower: 0, rangeHigher: 100, formatter: testFormatter, calendar: testCal)

        XCTAssertEqual(ticks.count, 7)
        let tickStrings = ticks.map { tick in
            tick.label
        }
        let tickRangeValues = ticks.map { tick in
            tick.rangeLocation
        }
        XCTAssertEqual(tickStrings, [
            "2022-08-08T22:43:09.011Z",
            "2022-08-08T23:43:09.011Z",
            "2022-08-09T00:43:09.011Z",
            "2022-08-09T01:43:09.011Z",
            "2022-08-09T02:43:09.011Z",
            "2022-08-09T03:43:09.011Z",
            "2022-08-09T04:43:09.011Z",
        ])

        XCTAssertEqual(tickRangeValues[0], 0, accuracy: 0.001)
//        XCTAssertEqual(tickRangeValues[1], 16.393, accuracy: 0.001)
//        XCTAssertEqual(tickRangeValues[2], 32.786, accuracy: 0.001)
//        XCTAssertEqual(tickRangeValues[3], 49.180, accuracy: 0.001)
//        XCTAssertEqual(tickRangeValues[4], 65.573, accuracy: 0.001)
//        XCTAssertEqual(tickRangeValues[5], 81.967, accuracy: 0.001)
//        XCTAssertEqual(tickRangeValues[6], 98.360, accuracy: 0.001)
    }
}
