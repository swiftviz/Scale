//
//  TickLabelTests.swift
//
//  Created by Joseph Heck on 3/14/20.
//

@testable import SwiftVizScale
import XCTest

final class TickTests: XCTestCase {
    func testTickInit() {
        let result = Tick(value: "one", location: 1.0)
        XCTAssertNotNil(result)
        XCTAssertEqual("one", result?.label)
        XCTAssertEqual(1.0, result?.rangeLocation)
    }

    func testTickInitNotRealLocation() {
        let result = Tick(value: "one", location: 1)
        XCTAssertNotNil(result)
        XCTAssertEqual("one", result.label)
        XCTAssertEqual(1, result.rangeLocation)
    }

    func testTickLabelFailInitFloat() {
        let result = Tick(value: "one", location: Float.nan)
        XCTAssertNil(result)
    }

    func testTickLabelFailInitDouble() {
        let result = Tick(value: "one", location: Double.nan)
        XCTAssertNil(result)
    }

    func testStringInterpLabel() {
        guard let url = URL(string: "https://google.com/"),
              let tick = Tick(value: url, location: 5.0)
        else {
            XCTFail()
            return
        }
        XCTAssertEqual(tick.label, "https://google.com/")
    }

    func testStringInterpLabelDouble() {
        guard let tick = Tick(value: 3.14, location: 5.0)
        else {
            XCTFail()
            return
        }
        XCTAssertEqual(tick.label, "3.14")
    }

    func testStringInterpLabelDoubleFormatter() {
        let formatter = NumberFormatter()
        formatter.maximumIntegerDigits = 1
        formatter.maximumFractionDigits = 1
        guard let tick = Tick(value: 3.14, location: 5.0, formatter: formatter)
        else {
            XCTFail()
            return
        }
        XCTAssertEqual(tick.label, "3.1")
    }

    func testStringInterpLabelDateWrongFormatter() {
        let formatter = NumberFormatter()
        formatter.maximumIntegerDigits = 1
        formatter.maximumFractionDigits = 1
        guard let tick = Tick(value: Date(timeIntervalSince1970: 312), location: 5.0, formatter: formatter)
        else {
            XCTFail()
            return
        }
        XCTAssertEqual(tick.label, "")
    }

    func testDefaultTicksInt() {
        let scale = LinearScale.IntScale(from: 0, to: 10)
        XCTAssertEqual(scale.ticks(rangeLower: 0, rangeHigher: 100).count, 10)
    }

    func testDefaultTicksFloat() {
        let scale = LinearScale.FloatScale(from: 0, to: 10)
        XCTAssertEqual(scale.ticks(rangeLower: 0, rangeHigher: 100).count, 6)
    }

    func testDefaultTicksDouble() {
        let scale = LinearScale.DoubleScale(from: 0, to: 10)
        XCTAssertEqual(scale.ticks(rangeLower: 0, rangeHigher: 100).count, 6)
    }
}
