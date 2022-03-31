////
////  TimeScaleTests.swift
////
////
////  Created by Joseph Heck on 3/19/20.
////
//
// @testable import SwiftViz
// import XCTest
//
// func assertEqualDates(_ firstDate: Date, _ secondDate: Date, accuracy: TimeInterval,
//                      file: StaticString = #file, line: UInt = #line)
// {
//    // let timeDelta = firstDate.timeIntervalSince(secondDate)
//    XCTAssertTrue(firstDate.timeIntervalSince(secondDate) < accuracy, file: file, line: line)
// }
//
//// an extension to ClosedRange<Date>.contains to allow for slip in the date calculations
//// when interpretting through scale or invert
// public extension ClosedRange where Bound == Date {
//    func contains(_ element: Bound, within: TimeInterval) -> Bool {
//        element > lowerBound.addingTimeInterval(-within) &&
//            element < upperBound.addingTimeInterval(within)
//    }
// }
//
// final class TimeScaleTests: XCTestCase {
//    func testTimeScaleTicks() {
//        let end = Date()
//        let start = end - TimeInterval(300)
//        let testRange = CGFloat(0) ... CGFloat(100.0)
//
//        let scale = DateScale(domain: start ... end)
//        XCTAssertFalse(scale.isClamped)
//        // XCTAssertTrue(scale.domain.contains(end))
//        // XCTAssertTrue(scale.domain.contains(start))
//
//        let defaultTicks = scale.ticks(range: testRange)
//        XCTAssertEqual(defaultTicks.count, 11)
//        for tick in defaultTicks {
//            // every tick should be from within the scale's domain (input) range
//            XCTAssertTrue(testRange.contains(tick.rangeLocation))
//            // print ("tick.value: \(tick.value) domain: \(scale.domain)")
//            // let result = scale.domain.contains(tick.value)
//            // print ("contained result: \(result)")
//            XCTAssert(scale.domain.contains(tick.value, within: TimeInterval(0.1)))
//        }
//    }
//
//    func testTimeScaleManualTicks() {
//        let end = Date()
//        let start = end - TimeInterval(300)
//        let testRange = CGFloat(0) ... CGFloat(100.0)
//
//        let scale = DateScale(domain: start ... end)
//
//        let middleDate = end - TimeInterval(150)
//        let manualTicks = scale.ticks([start, middleDate, end], range: testRange)
//
//        XCTAssertEqual(manualTicks.count, 3)
//        for tick in manualTicks {
//            // every tick should be from within the scale's domain (input) range
//            XCTAssertTrue(testRange.contains(tick.rangeLocation))
//            XCTAssert(scale.domain.contains(tick.value))
//
//            XCTAssertTrue(testRange.contains(tick.rangeLocation))
//            XCTAssert(scale.domain.contains(tick.value, within: TimeInterval(0.1)))
//        }
//    }
//
//    func testTimeScaleClamp() {
//        let end = Date()
//        let start = end - TimeInterval(300)
//        let testRange = CGFloat(0) ... CGFloat(100.0)
//        let scale = DateScale(domain: start ... end)
//        let clampedScale = DateScale(domain: start ... end, isClamped: true)
//
//        let middleDate = end - TimeInterval(150)
//        let highDate = end + TimeInterval(150)
//        let lowDate = end - TimeInterval(450)
//
//        // no clamp effect
//        XCTAssertEqual(scale.scale(middleDate, range: testRange), 50)
//        XCTAssertEqual(clampedScale.scale(middleDate, range: testRange), 50)
//
//        // clamp constrained high
//        XCTAssertEqual(scale.scale(highDate, range: testRange), 150)
//        XCTAssertEqual(clampedScale.scale(highDate, range: testRange), 100)
//
//        // clamp constrained low
//        XCTAssertEqual(scale.scale(lowDate, range: testRange), -50)
//        XCTAssertEqual(clampedScale.scale(lowDate, range: testRange), 0)
//    }
//
//    func testTimeInvertClamp() {
//        let end = Date()
//        let start = end - TimeInterval(300)
//        let testRange = CGFloat(0) ... CGFloat(100.0)
//        let scale = DateScale(domain: start ... end)
//        let clampedScale = DateScale(domain: start ... end, isClamped: true)
//
//        let middleDate = end - TimeInterval(150)
//        let highDate = end + TimeInterval(150)
//        let lowDate = end - TimeInterval(450)
//
//        // no clamp effect
//        assertEqualDates(scale.invert(50, range: testRange), middleDate,
//                         accuracy: TimeInterval(0.1))
//        assertEqualDates(clampedScale.invert(50, range: testRange), middleDate,
//                         accuracy: TimeInterval(0.1))
//
//        // clamp constrained high
//        assertEqualDates(scale.invert(150, range: testRange), highDate,
//                         accuracy: TimeInterval(0.1))
//        assertEqualDates(clampedScale.invert(150, range: testRange), end,
//                         accuracy: TimeInterval(0.1))
//
//        // clamp constrained low
//        assertEqualDates(scale.invert(-50, range: testRange), lowDate,
//                         accuracy: TimeInterval(0.1))
//        assertEqualDates(clampedScale.invert(-50, range: testRange), start,
//                         accuracy: TimeInterval(0.1))
//    }
// }
