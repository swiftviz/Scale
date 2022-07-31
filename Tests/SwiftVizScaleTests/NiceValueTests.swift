//
//  NiceValueTests.swift
//

import Foundation
import XCTest

class NiceValueTests: XCTestCase {
    // MARK: assertion helpers

    func assertCalculatedNiceValue(input: Double, expectedLowerValue: Double, expectedHigherValue: Double, file: StaticString = #file, line: UInt = #line) {
        let lowConvertedValue = Double.niceVersion(for: input, trendTowardsZero: true)
        let highConvertedValue = Double.niceVersion(for: input, trendTowardsZero: false)
        print(lowConvertedValue, highConvertedValue)
        XCTAssertEqual(expectedLowerValue, lowConvertedValue, file: file, line: line)
        XCTAssertEqual(expectedHigherValue, highConvertedValue, file: file, line: line)
    }

    func assertCalculatedNiceValue(input: Int, expectedLowerValue: Int, expectedHigherValue: Int, file: StaticString = #file, line: UInt = #line) {
        let lowConvertedValue = Int.niceVersion(for: input, trendTowardsZero: true)
        let highConvertedValue = Int.niceVersion(for: input, trendTowardsZero: false)
        XCTAssertEqual(expectedLowerValue, lowConvertedValue, file: file, line: line)
        XCTAssertEqual(expectedHigherValue, highConvertedValue, file: file, line: line)
    }

    func verifyRangeAttributes(min: Double, max: Double, steps: Int, calcSteps: Int, stepsize: Double, niceMax: Double, file: StaticString = #file, line: UInt = #line) throws {
        XCTAssertTrue(steps > 1, file: file, line: line)
        let calculatedRange = Double.rangeOfNiceValues(min: min, max: max, ofSize: steps)
        XCTAssertTrue(calculatedRange.first! <= min, file: file, line: line)
        XCTAssertTrue(calculatedRange.last! >= max, file: file, line: line)
        XCTAssertEqual(calculatedRange.count, calcSteps, file: file, line: line)
        if calculatedRange.count > 1 {
            let derivedStepSize = calculatedRange[1] - calculatedRange[0]
            XCTAssertEqual(derivedStepSize, stepsize, accuracy: 0.01, file: file, line: line)
            XCTAssertEqual(calculatedRange.last!, niceMax, accuracy: 0.01, file: file, line: line)
        }
    }

    func verifyIntRangeAttributes(min: Int, max: Int, steps: Int, calcSteps: Int, stepsize: Int, niceMax: Int, file: StaticString = #file, line: UInt = #line) throws {
        XCTAssertTrue(steps > 1, file: file, line: line)
        let calculatedRange = Int.rangeOfNiceValues(min: min, max: max, ofSize: steps)
        XCTAssertTrue(calculatedRange.first! <= min, file: file, line: line)
        XCTAssertTrue(calculatedRange.last! >= max, file: file, line: line)
        XCTAssertEqual(calculatedRange.count, calcSteps, file: file, line: line)
        let derivedStepSize = calculatedRange[1] - calculatedRange[0]
        XCTAssertEqual(derivedStepSize, stepsize, file: file, line: line)
        XCTAssertEqual(calculatedRange.last!, niceMax, file: file, line: line)
    }

    // MARK: tests

    func testRangeOfNiceValues() throws {
        let result = Double.rangeOfNiceValues(min: 1, max: 999, ofSize: 10)
        // print(result)
    }

    func testNegativeNiceValues() throws {
        assertCalculatedNiceValue(input: 0.0, expectedLowerValue: 0.0, expectedHigherValue: 0.0)
        assertCalculatedNiceValue(input: -1.0, expectedLowerValue: -1.0, expectedHigherValue: -1.0)
        assertCalculatedNiceValue(input: -1.1, expectedLowerValue: -1.0, expectedHigherValue: -2.0)
        assertCalculatedNiceValue(input: -1.6, expectedLowerValue: -1.0, expectedHigherValue: -2.0)
        assertCalculatedNiceValue(input: -3.0, expectedLowerValue: -2.0, expectedHigherValue: -5.0)
        assertCalculatedNiceValue(input: -4.0, expectedLowerValue: -2.0, expectedHigherValue: -5.0)
        assertCalculatedNiceValue(input: -6.0, expectedLowerValue: -5.0, expectedHigherValue: -10.0)
        assertCalculatedNiceValue(input: -11.0, expectedLowerValue: -10.0, expectedHigherValue: -20.0)
        assertCalculatedNiceValue(input: -101.0, expectedLowerValue: -100, expectedHigherValue: -200)
        assertCalculatedNiceValue(input: -1010.0, expectedLowerValue: -1000, expectedHigherValue: -2000)
        assertCalculatedNiceValue(input: -1110.0, expectedLowerValue: -1000, expectedHigherValue: -2000)
    }

    func testNiceValuesOfDoubleSequence() throws {
        assertCalculatedNiceValue(input: 0.0, expectedLowerValue: 0.0, expectedHigherValue: 0.0)
        assertCalculatedNiceValue(input: 1.0, expectedLowerValue: 1.0, expectedHigherValue: 1.0)
        assertCalculatedNiceValue(input: 1.1, expectedLowerValue: 1.0, expectedHigherValue: 2.0)
        assertCalculatedNiceValue(input: 1.2, expectedLowerValue: 1.0, expectedHigherValue: 2.0)
        assertCalculatedNiceValue(input: 1.3, expectedLowerValue: 1.0, expectedHigherValue: 2.0)
        assertCalculatedNiceValue(input: 1.4, expectedLowerValue: 1.0, expectedHigherValue: 2.0)
        assertCalculatedNiceValue(input: 1.5, expectedLowerValue: 1.0, expectedHigherValue: 2.0)
        assertCalculatedNiceValue(input: 1.6, expectedLowerValue: 1.0, expectedHigherValue: 2.0)
        assertCalculatedNiceValue(input: 1.7, expectedLowerValue: 1.0, expectedHigherValue: 2.0)
        assertCalculatedNiceValue(input: 1.8, expectedLowerValue: 1.0, expectedHigherValue: 2.0)
        assertCalculatedNiceValue(input: 1.9, expectedLowerValue: 1.0, expectedHigherValue: 2.0)
        assertCalculatedNiceValue(input: 2.0, expectedLowerValue: 2.0, expectedHigherValue: 2.0)
        assertCalculatedNiceValue(input: 3.0, expectedLowerValue: 2.0, expectedHigherValue: 5.0)
        assertCalculatedNiceValue(input: 4.0, expectedLowerValue: 2.0, expectedHigherValue: 5.0)
        assertCalculatedNiceValue(input: 5.0, expectedLowerValue: 5.0, expectedHigherValue: 5.0)
        assertCalculatedNiceValue(input: 6.0, expectedLowerValue: 5.0, expectedHigherValue: 10.0)
        assertCalculatedNiceValue(input: 7.0, expectedLowerValue: 5.0, expectedHigherValue: 10.0)
        assertCalculatedNiceValue(input: 8.0, expectedLowerValue: 5.0, expectedHigherValue: 10.0)
        assertCalculatedNiceValue(input: 9.0, expectedLowerValue: 5.0, expectedHigherValue: 10.0)
        assertCalculatedNiceValue(input: 10.0, expectedLowerValue: 10.0, expectedHigherValue: 10.0)
        assertCalculatedNiceValue(input: 11.0, expectedLowerValue: 10.0, expectedHigherValue: 20.0)
        assertCalculatedNiceValue(input: 101.0, expectedLowerValue: 100, expectedHigherValue: 200)
        assertCalculatedNiceValue(input: 111.0, expectedLowerValue: 100, expectedHigherValue: 200)
        assertCalculatedNiceValue(input: 1010.0, expectedLowerValue: 1000, expectedHigherValue: 2000)
        assertCalculatedNiceValue(input: 1110.0, expectedLowerValue: 1000, expectedHigherValue: 2000)
    }

    func testNiceValuesOfIntSequence() throws {
        assertCalculatedNiceValue(input: 0, expectedLowerValue: 0, expectedHigherValue: 0)
        assertCalculatedNiceValue(input: 1, expectedLowerValue: 1, expectedHigherValue: 1)
        assertCalculatedNiceValue(input: 2, expectedLowerValue: 2, expectedHigherValue: 2)
        assertCalculatedNiceValue(input: 3, expectedLowerValue: 2, expectedHigherValue: 5)
        assertCalculatedNiceValue(input: 4, expectedLowerValue: 5, expectedHigherValue: 5)
        assertCalculatedNiceValue(input: 5, expectedLowerValue: 5, expectedHigherValue: 5)
        assertCalculatedNiceValue(input: 6, expectedLowerValue: 5, expectedHigherValue: 10)
        assertCalculatedNiceValue(input: 7, expectedLowerValue: 5, expectedHigherValue: 10)
        assertCalculatedNiceValue(input: 8, expectedLowerValue: 10, expectedHigherValue: 10)
        assertCalculatedNiceValue(input: 9, expectedLowerValue: 10, expectedHigherValue: 10)
        assertCalculatedNiceValue(input: 10, expectedLowerValue: 10, expectedHigherValue: 10)
        assertCalculatedNiceValue(input: 11, expectedLowerValue: 10, expectedHigherValue: 20)
        assertCalculatedNiceValue(input: 101, expectedLowerValue: 100, expectedHigherValue: 200)
        assertCalculatedNiceValue(input: 111, expectedLowerValue: 100, expectedHigherValue: 200)
        assertCalculatedNiceValue(input: 1010, expectedLowerValue: 1000, expectedHigherValue: 2000)
        assertCalculatedNiceValue(input: 1110, expectedLowerValue: 1000, expectedHigherValue: 2000)
    }

    func testNiceMinimumForRangeDoubleNegativeValues() throws {
        XCTAssertEqual(Double.niceMinimumValueForRange(min: -1, max: 10), -1)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: -2, max: 10), -2)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: -3, max: 3), -5)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: -3, max: 10), -5)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: -3, max: 100), -5)
    }

    func testNiceMinimumForRangeDouble() throws {
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 0, max: 10), 0)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 1, max: 10), 0)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 2, max: 10), 0)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 3, max: 10), 0)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 4, max: 10), 0)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 8, max: 10), 0)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 9, max: 10), 0)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 0, max: 20), 0)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 1, max: 20), 0)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 2, max: 20), 0)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 3, max: 20), 0)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 0, max: 50), 0)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 1, max: 50), 0)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 2, max: 50), 0)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 3, max: 50), 0)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 0, max: 100), 0)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 1, max: 100), 0)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 2, max: 100), 0)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 3, max: 100), 0)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 91, max: 100), 0)
    }

    func testNiceMinimumForRangeInt() throws {
        XCTAssertEqual(Int.niceMinimumValueForRange(min: 0, max: 10), 0)
        XCTAssertEqual(Int.niceMinimumValueForRange(min: 1, max: 10), 0)
        XCTAssertEqual(Int.niceMinimumValueForRange(min: 2, max: 10), 2)
        XCTAssertEqual(Int.niceMinimumValueForRange(min: 3, max: 10), 2)
        XCTAssertEqual(Int.niceMinimumValueForRange(min: 4, max: 10), 5)
        XCTAssertEqual(Int.niceMinimumValueForRange(min: 0, max: 20), 0)
        XCTAssertEqual(Int.niceMinimumValueForRange(min: 1, max: 20), 0)
        XCTAssertEqual(Int.niceMinimumValueForRange(min: 2, max: 20), 0)
        XCTAssertEqual(Int.niceMinimumValueForRange(min: 3, max: 20), 0)
        XCTAssertEqual(Int.niceMinimumValueForRange(min: 0, max: 50), 0)
        XCTAssertEqual(Int.niceMinimumValueForRange(min: 1, max: 50), 0)
        XCTAssertEqual(Int.niceMinimumValueForRange(min: 2, max: 50), 0)
        XCTAssertEqual(Int.niceMinimumValueForRange(min: 3, max: 50), 0)
        XCTAssertEqual(Int.niceMinimumValueForRange(min: 0, max: 100), 0)
        XCTAssertEqual(Int.niceMinimumValueForRange(min: 1, max: 100), 0)
        XCTAssertEqual(Int.niceMinimumValueForRange(min: 2, max: 100), 0)
        XCTAssertEqual(Int.niceMinimumValueForRange(min: 3, max: 100), 0)
    }

    func testDoubleNiceRange() throws {
        let min = 0.1
        let max = 12.56
        try verifyRangeAttributes(min: min, max: max, steps: 2, calcSteps: 2, stepsize: 20, niceMax: 20)
        try verifyRangeAttributes(min: min, max: max, steps: 3, calcSteps: 3, stepsize: 10, niceMax: 20)
        try verifyRangeAttributes(min: min, max: max, steps: 4, calcSteps: 4, stepsize: 5, niceMax: 15)
        try verifyRangeAttributes(min: min, max: max, steps: 4, calcSteps: 4, stepsize: 5, niceMax: 15)
        try verifyRangeAttributes(min: min, max: max, steps: 6, calcSteps: 4, stepsize: 5, niceMax: 15)
        try verifyRangeAttributes(min: min, max: max, steps: 7, calcSteps: 4, stepsize: 5, niceMax: 15)
        try verifyRangeAttributes(min: min, max: max, steps: 8, calcSteps: 8, stepsize: 2, niceMax: 14)
        try verifyRangeAttributes(min: min, max: max, steps: 9, calcSteps: 8, stepsize: 2, niceMax: 14)
        try verifyRangeAttributes(min: min, max: max, steps: 10, calcSteps: 8, stepsize: 2, niceMax: 14)
        try verifyRangeAttributes(min: min, max: max, steps: 11, calcSteps: 8, stepsize: 2, niceMax: 14)
        try verifyRangeAttributes(min: min, max: max, steps: 12, calcSteps: 8, stepsize: 2, niceMax: 14)
        try verifyRangeAttributes(min: min, max: max, steps: 13, calcSteps: 8, stepsize: 2, niceMax: 14)
        try verifyRangeAttributes(min: min, max: max, steps: 14, calcSteps: 14, stepsize: 1, niceMax: 13)
        try verifyRangeAttributes(min: min, max: max, steps: 15, calcSteps: 14, stepsize: 1, niceMax: 13)
        try verifyRangeAttributes(min: min, max: max, steps: 16, calcSteps: 14, stepsize: 1, niceMax: 13)
        try verifyRangeAttributes(min: min, max: max, steps: 17, calcSteps: 14, stepsize: 1, niceMax: 13)
        try verifyRangeAttributes(min: min, max: max, steps: 18, calcSteps: 14, stepsize: 1, niceMax: 13)
        try verifyRangeAttributes(min: min, max: max, steps: 19, calcSteps: 14, stepsize: 1, niceMax: 13)
        try verifyRangeAttributes(min: min, max: max, steps: 20, calcSteps: 14, stepsize: 1, niceMax: 13)
        try verifyRangeAttributes(min: min, max: max, steps: 30, calcSteps: 27, stepsize: 0.5, niceMax: 13)
        try verifyRangeAttributes(min: min, max: max, steps: 40, calcSteps: 27, stepsize: 0.5, niceMax: 13)
        try verifyRangeAttributes(min: min, max: max, steps: 50, calcSteps: 27, stepsize: 0.5, niceMax: 13)
        try verifyRangeAttributes(min: min, max: max, steps: 60, calcSteps: 27, stepsize: 0.5, niceMax: 13)
        try verifyRangeAttributes(min: min, max: max, steps: 70, calcSteps: 64, stepsize: 0.2, niceMax: 12.6)
        try verifyRangeAttributes(min: min, max: max, steps: 80, calcSteps: 64, stepsize: 0.2, niceMax: 12.6)
        try verifyRangeAttributes(min: min, max: max, steps: 90, calcSteps: 64, stepsize: 0.2, niceMax: 12.6)
        try verifyRangeAttributes(min: min, max: max, steps: 100, calcSteps: 64, stepsize: 0.2, niceMax: 12.6)
        try verifyRangeAttributes(min: min, max: max, steps: 110, calcSteps: 64, stepsize: 0.2, niceMax: 12.6)
        try verifyRangeAttributes(min: min, max: max, steps: 120, calcSteps: 64, stepsize: 0.2, niceMax: 12.6)
        try verifyRangeAttributes(min: min, max: max, steps: 130, calcSteps: 127, stepsize: 0.1, niceMax: 12.6)
        try verifyRangeAttributes(min: min, max: max, steps: 140, calcSteps: 127, stepsize: 0.1, niceMax: 12.6)
        try verifyRangeAttributes(min: min, max: max, steps: 150, calcSteps: 127, stepsize: 0.1, niceMax: 12.6)
        try verifyRangeAttributes(min: min, max: max, steps: 160, calcSteps: 127, stepsize: 0.1, niceMax: 12.6)
        try verifyRangeAttributes(min: min, max: max, steps: 170, calcSteps: 127, stepsize: 0.1, niceMax: 12.6)
        try verifyRangeAttributes(min: min, max: max, steps: 180, calcSteps: 127, stepsize: 0.1, niceMax: 12.6)
        try verifyRangeAttributes(min: min, max: max, steps: 190, calcSteps: 127, stepsize: 0.1, niceMax: 12.6)
    }

    func testIntNiceRange() throws {
        let min = 1
        let max = 125
        try verifyIntRangeAttributes(min: min, max: max, steps: 2, calcSteps: 2, stepsize: 200, niceMax: 200)
        try verifyIntRangeAttributes(min: min, max: max, steps: 3, calcSteps: 3, stepsize: 100, niceMax: 200)
        try verifyIntRangeAttributes(min: min, max: max, steps: 3, calcSteps: 3, stepsize: 100, niceMax: 200)
    }

    func testLogRangeNiceValue() throws {
        let min: Double = 2
        let max: Double = 2013
        let result = Double.logRangeOfNiceValues(min: min, max: max)
        XCTAssertEqual(result, [2.0, 5.0, 10.0, 20.0, 50.0, 100.0, 200.0, 500.0, 1000.0, 2000.0])
    }

    func testLongerLogRangeNiceValue() throws {
        let min = 0.02
        let max: Double = 2013
        let result = Double.logRangeOfNiceValues(min: min, max: max)
        XCTAssertEqual(result.count, 16)
    }

    func testStupidLogRangeNiceValue() throws {
        let min: Double = 0
        let max: Double = 20
        let result = Double.logRangeOfNiceValues(min: min, max: max)
        // print(result)
        XCTAssertEqual(result.count, 974)
    }
}
