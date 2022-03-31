//
//  NiceValueTests.swift
//
//
//  Created by Joseph Heck on 3/7/22.
//

import Foundation
import XCTest

class NiceValueTests: XCTestCase {
    func doubleConversionMatches(input: Double, lower: Double, higher: Double) {
        let lowConvertedValue = Double.niceVersion(for: input, min: true)
        let highConvertedValue = Double.niceVersion(for: input, min: false)
        XCTAssertEqual(lower, lowConvertedValue)
        XCTAssertEqual(higher, highConvertedValue)
    }

    func floatConversionMatches(input: Float, lower: Float, higher: Float) {
        let lowConvertedValue = Float.niceVersion(for: input, min: true)
        let highConvertedValue = Float.niceVersion(for: input, min: false)
        XCTAssertEqual(lower, lowConvertedValue)
        XCTAssertEqual(higher, highConvertedValue)
    }

    func cgFloatConversionMatches(input: CGFloat, lower: CGFloat, higher: CGFloat) {
        let lowConvertedValue = CGFloat.niceVersion(for: input, min: true)
        let highConvertedValue = CGFloat.niceVersion(for: input, min: false)
        XCTAssertEqual(lower, lowConvertedValue)
        XCTAssertEqual(higher, highConvertedValue)
    }

    func intConversionMatches(input: Int, lower: Int, higher: Int) {
        let lowConvertedValue = Int.niceVersion(for: input, min: true)
        let highConvertedValue = Int.niceVersion(for: input, min: false)
        XCTAssertEqual(lower, lowConvertedValue)
        XCTAssertEqual(higher, highConvertedValue)
    }

    func testNegativeNiceValues() throws {
        doubleConversionMatches(input: 0.0, lower: 0.0, higher: 0.0)
        doubleConversionMatches(input: -1.0, lower: -1.0, higher: -1.0)
        doubleConversionMatches(input: -1.1, lower: -1.0, higher: -2.0)
        doubleConversionMatches(input: -1.6, lower: -2.0, higher: -2.0)
        doubleConversionMatches(input: -3.0, lower: -2.0, higher: -5.0)
        doubleConversionMatches(input: -4.0, lower: -5.0, higher: -5.0)
        doubleConversionMatches(input: -6.0, lower: -5.0, higher: -10.0)
        doubleConversionMatches(input: -11.0, lower: -10.0, higher: -20.0)
        doubleConversionMatches(input: -101.0, lower: -100, higher: -200)
        doubleConversionMatches(input: -1010.0, lower: -1000, higher: -2000)
        doubleConversionMatches(input: -1110.0, lower: -1000, higher: -2000)
    }

    func testNiceValuesOfDoubleSequence() throws {
        doubleConversionMatches(input: 0.0, lower: 0.0, higher: 0.0)
        doubleConversionMatches(input: 1.0, lower: 1.0, higher: 1.0)
        doubleConversionMatches(input: 1.1, lower: 1.0, higher: 2.0)
        doubleConversionMatches(input: 1.2, lower: 1.0, higher: 2.0)
        doubleConversionMatches(input: 1.3, lower: 1.0, higher: 2.0)
        doubleConversionMatches(input: 1.4, lower: 1.0, higher: 2.0)
        doubleConversionMatches(input: 1.5, lower: 1.0, higher: 2.0)
        doubleConversionMatches(input: 1.6, lower: 2.0, higher: 2.0)
        doubleConversionMatches(input: 1.7, lower: 2.0, higher: 2.0)
        doubleConversionMatches(input: 1.8, lower: 2.0, higher: 2.0)
        doubleConversionMatches(input: 1.9, lower: 2.0, higher: 2.0)
        doubleConversionMatches(input: 2.0, lower: 2.0, higher: 2.0)
        doubleConversionMatches(input: 3.0, lower: 2.0, higher: 5.0)
        doubleConversionMatches(input: 4.0, lower: 5.0, higher: 5.0)
        doubleConversionMatches(input: 5.0, lower: 5.0, higher: 5.0)
        doubleConversionMatches(input: 6.0, lower: 5.0, higher: 10.0)
        doubleConversionMatches(input: 7.0, lower: 5.0, higher: 10.0)
        doubleConversionMatches(input: 8.0, lower: 10.0, higher: 10.0)
        doubleConversionMatches(input: 9.0, lower: 10.0, higher: 10.0)
        doubleConversionMatches(input: 10.0, lower: 10.0, higher: 10.0)
        doubleConversionMatches(input: 11.0, lower: 10.0, higher: 20.0)
        doubleConversionMatches(input: 101.0, lower: 100, higher: 200)
        doubleConversionMatches(input: 111.0, lower: 100, higher: 200)
        doubleConversionMatches(input: 1010.0, lower: 1000, higher: 2000)
        doubleConversionMatches(input: 1110.0, lower: 1000, higher: 2000)
    }

    func testNiceValuesOfFloatSequence() throws {
        floatConversionMatches(input: 0.0, lower: 0.0, higher: 0.0)
        floatConversionMatches(input: 1.0, lower: 1.0, higher: 1.0)
        floatConversionMatches(input: 1.1, lower: 1.0, higher: 2.0)
        floatConversionMatches(input: 1.2, lower: 1.0, higher: 2.0)
        floatConversionMatches(input: 1.3, lower: 1.0, higher: 2.0)
        floatConversionMatches(input: 1.4, lower: 1.0, higher: 2.0)
        floatConversionMatches(input: 1.5, lower: 1.0, higher: 2.0)
        floatConversionMatches(input: 1.6, lower: 2.0, higher: 2.0)
        floatConversionMatches(input: 1.7, lower: 2.0, higher: 2.0)
        floatConversionMatches(input: 1.8, lower: 2.0, higher: 2.0)
        floatConversionMatches(input: 1.9, lower: 2.0, higher: 2.0)
        floatConversionMatches(input: 2.0, lower: 2.0, higher: 2.0)
        floatConversionMatches(input: 3.0, lower: 2.0, higher: 5.0)
        floatConversionMatches(input: 4.0, lower: 5.0, higher: 5.0)
        floatConversionMatches(input: 5.0, lower: 5.0, higher: 5.0)
        floatConversionMatches(input: 6.0, lower: 5.0, higher: 10.0)
        floatConversionMatches(input: 7.0, lower: 5.0, higher: 10.0)
        floatConversionMatches(input: 8.0, lower: 10.0, higher: 10.0)
        floatConversionMatches(input: 9.0, lower: 10.0, higher: 10.0)
        floatConversionMatches(input: 10.0, lower: 10.0, higher: 10.0)
        floatConversionMatches(input: 11.0, lower: 10.0, higher: 20.0)
        floatConversionMatches(input: 101.0, lower: 100, higher: 200)
        floatConversionMatches(input: 111.0, lower: 100, higher: 200)
        floatConversionMatches(input: 1010.0, lower: 1000, higher: 2000)
        floatConversionMatches(input: 1110.0, lower: 1000, higher: 2000)
    }

    func testNiceValuesOfCGFloatSequence() throws {
        cgFloatConversionMatches(input: 0.0, lower: 0.0, higher: 0.0)
        cgFloatConversionMatches(input: 1.0, lower: 1.0, higher: 1.0)
        cgFloatConversionMatches(input: 1.1, lower: 1.0, higher: 2.0)
        cgFloatConversionMatches(input: 1.2, lower: 1.0, higher: 2.0)
        cgFloatConversionMatches(input: 1.3, lower: 1.0, higher: 2.0)
        cgFloatConversionMatches(input: 1.4, lower: 1.0, higher: 2.0)
        cgFloatConversionMatches(input: 1.5, lower: 1.0, higher: 2.0)
        cgFloatConversionMatches(input: 1.6, lower: 2.0, higher: 2.0)
        cgFloatConversionMatches(input: 1.7, lower: 2.0, higher: 2.0)
        cgFloatConversionMatches(input: 1.8, lower: 2.0, higher: 2.0)
        cgFloatConversionMatches(input: 1.9, lower: 2.0, higher: 2.0)
        cgFloatConversionMatches(input: 2.0, lower: 2.0, higher: 2.0)
        cgFloatConversionMatches(input: 3.0, lower: 2.0, higher: 5.0)
        cgFloatConversionMatches(input: 4.0, lower: 5.0, higher: 5.0)
        cgFloatConversionMatches(input: 5.0, lower: 5.0, higher: 5.0)
        cgFloatConversionMatches(input: 6.0, lower: 5.0, higher: 10.0)
        cgFloatConversionMatches(input: 7.0, lower: 5.0, higher: 10.0)
        cgFloatConversionMatches(input: 8.0, lower: 10.0, higher: 10.0)
        cgFloatConversionMatches(input: 9.0, lower: 10.0, higher: 10.0)
        cgFloatConversionMatches(input: 10.0, lower: 10.0, higher: 10.0)
        cgFloatConversionMatches(input: 11.0, lower: 10.0, higher: 20.0)
        cgFloatConversionMatches(input: 101.0, lower: 100, higher: 200)
        cgFloatConversionMatches(input: 111.0, lower: 100, higher: 200)
        cgFloatConversionMatches(input: 1010.0, lower: 1000, higher: 2000)
        cgFloatConversionMatches(input: 1110.0, lower: 1000, higher: 2000)
    }

    func testNiceValuesOfIntSequence() throws {
        intConversionMatches(input: 0, lower: 0, higher: 0)
        intConversionMatches(input: 1, lower: 1, higher: 1)
        intConversionMatches(input: 2, lower: 2, higher: 2)
        intConversionMatches(input: 3, lower: 2, higher: 5)
        intConversionMatches(input: 4, lower: 5, higher: 5)
        intConversionMatches(input: 5, lower: 5, higher: 5)
        intConversionMatches(input: 6, lower: 5, higher: 10)
        intConversionMatches(input: 7, lower: 5, higher: 10)
        intConversionMatches(input: 8, lower: 10, higher: 10)
        intConversionMatches(input: 9, lower: 10, higher: 10)
        intConversionMatches(input: 10, lower: 10, higher: 10)
        intConversionMatches(input: 11, lower: 10, higher: 20)
        intConversionMatches(input: 101, lower: 100, higher: 200)
        intConversionMatches(input: 111, lower: 100, higher: 200)
        intConversionMatches(input: 1010, lower: 1000, higher: 2000)
        intConversionMatches(input: 1110, lower: 1000, higher: 2000)
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
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 2, max: 10), 2)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 3, max: 10), 2)
        XCTAssertEqual(Double.niceMinimumValueForRange(min: 4, max: 10), 5)
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
    }

    func testNiceMinimumForRangeFloat() throws {
        XCTAssertEqual(Float.niceMinimumValueForRange(min: 0, max: 10), 0)
        XCTAssertEqual(Float.niceMinimumValueForRange(min: 1, max: 10), 0)
        XCTAssertEqual(Float.niceMinimumValueForRange(min: 2, max: 10), 2)
        XCTAssertEqual(Float.niceMinimumValueForRange(min: 3, max: 10), 2)
        XCTAssertEqual(Float.niceMinimumValueForRange(min: 4, max: 10), 5)
        XCTAssertEqual(Float.niceMinimumValueForRange(min: 0, max: 20), 0)
        XCTAssertEqual(Float.niceMinimumValueForRange(min: 1, max: 20), 0)
        XCTAssertEqual(Float.niceMinimumValueForRange(min: 2, max: 20), 0)
        XCTAssertEqual(Float.niceMinimumValueForRange(min: 3, max: 20), 0)
        XCTAssertEqual(Float.niceMinimumValueForRange(min: 0, max: 50), 0)
        XCTAssertEqual(Float.niceMinimumValueForRange(min: 1, max: 50), 0)
        XCTAssertEqual(Float.niceMinimumValueForRange(min: 2, max: 50), 0)
        XCTAssertEqual(Float.niceMinimumValueForRange(min: 3, max: 50), 0)
        XCTAssertEqual(Float.niceMinimumValueForRange(min: 0, max: 100), 0)
        XCTAssertEqual(Float.niceMinimumValueForRange(min: 1, max: 100), 0)
        XCTAssertEqual(Float.niceMinimumValueForRange(min: 2, max: 100), 0)
        XCTAssertEqual(Float.niceMinimumValueForRange(min: 3, max: 100), 0)
    }

    func testNiceMinimumForRangeCGFloat() throws {
        XCTAssertEqual(CGFloat.niceMinimumValueForRange(min: 0, max: 10), 0)
        XCTAssertEqual(CGFloat.niceMinimumValueForRange(min: 1, max: 10), 0)
        XCTAssertEqual(CGFloat.niceMinimumValueForRange(min: 2, max: 10), 2)
        XCTAssertEqual(CGFloat.niceMinimumValueForRange(min: 3, max: 10), 2)
        XCTAssertEqual(CGFloat.niceMinimumValueForRange(min: 4, max: 10), 5)
        XCTAssertEqual(CGFloat.niceMinimumValueForRange(min: 0, max: 20), 0)
        XCTAssertEqual(CGFloat.niceMinimumValueForRange(min: 1, max: 20), 0)
        XCTAssertEqual(CGFloat.niceMinimumValueForRange(min: 2, max: 20), 0)
        XCTAssertEqual(CGFloat.niceMinimumValueForRange(min: 3, max: 20), 0)
        XCTAssertEqual(CGFloat.niceMinimumValueForRange(min: 0, max: 50), 0)
        XCTAssertEqual(CGFloat.niceMinimumValueForRange(min: 1, max: 50), 0)
        XCTAssertEqual(CGFloat.niceMinimumValueForRange(min: 2, max: 50), 0)
        XCTAssertEqual(CGFloat.niceMinimumValueForRange(min: 3, max: 50), 0)
        XCTAssertEqual(CGFloat.niceMinimumValueForRange(min: 0, max: 100), 0)
        XCTAssertEqual(CGFloat.niceMinimumValueForRange(min: 1, max: 100), 0)
        XCTAssertEqual(CGFloat.niceMinimumValueForRange(min: 2, max: 100), 0)
        XCTAssertEqual(CGFloat.niceMinimumValueForRange(min: 3, max: 100), 0)
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

    func verifyRangeAttributes(min: Double, max: Double, steps: Int, calcSteps: Int, stepsize: Double, niceMax: Double) throws {
        XCTAssertTrue(steps > 1)
        let calculatedRange = Double.rangeOfNiceValues(min: min, max: max, ofSize: steps)
        XCTAssertTrue(calculatedRange.first! <= min)
        XCTAssertTrue(calculatedRange.last! >= max)
        XCTAssertEqual(calculatedRange.count, calcSteps)
        let derivedStepSize = calculatedRange[1] - calculatedRange[0]
        XCTAssertEqual(derivedStepSize, stepsize, accuracy: 0.01)
        XCTAssertEqual(calculatedRange.last!, niceMax, accuracy: 0.01)
    }

    func testDoubleNiceRange() throws {
        let min = 0.1
        let max = 12.56
        try verifyRangeAttributes(min: min, max: max, steps: 2, calcSteps: 2, stepsize: 20, niceMax: 20)
        try verifyRangeAttributes(min: min, max: max, steps: 3, calcSteps: 3, stepsize: 10, niceMax: 20)
        try verifyRangeAttributes(min: min, max: max, steps: 4, calcSteps: 4, stepsize: 5, niceMax: 15)
        try verifyRangeAttributes(min: min, max: max, steps: 5, calcSteps: 5, stepsize: 5, niceMax: 20)
        try verifyRangeAttributes(min: min, max: max, steps: 6, calcSteps: 5, stepsize: 5, niceMax: 20)
        try verifyRangeAttributes(min: min, max: max, steps: 7, calcSteps: 5, stepsize: 5, niceMax: 20)
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

    func verifyFloatRangeAttributes(min: Float, max: Float, steps: Int, calcSteps: Int, stepsize: Float, niceMax: Float) throws {
        XCTAssertTrue(steps > 1)
        let calculatedRange = Float.rangeOfNiceValues(min: min, max: max, ofSize: steps)
        XCTAssertTrue(calculatedRange.first! <= min)
        XCTAssertTrue(calculatedRange.last! >= max)
        XCTAssertEqual(calculatedRange.count, calcSteps)
        let derivedStepSize = calculatedRange[1] - calculatedRange[0]
        XCTAssertEqual(derivedStepSize, stepsize, accuracy: 0.01)
        XCTAssertEqual(calculatedRange.last!, niceMax, accuracy: 0.01)
    }

    func testFloatNiceRange() throws {
        let min: Float = 0.1
        let max: Float = 12.56
        try verifyFloatRangeAttributes(min: min, max: max, steps: 2, calcSteps: 2, stepsize: 20, niceMax: 20)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 3, calcSteps: 3, stepsize: 10, niceMax: 20)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 4, calcSteps: 4, stepsize: 5, niceMax: 15)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 5, calcSteps: 5, stepsize: 5, niceMax: 20)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 6, calcSteps: 5, stepsize: 5, niceMax: 20)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 7, calcSteps: 5, stepsize: 5, niceMax: 20)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 8, calcSteps: 8, stepsize: 2, niceMax: 14)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 9, calcSteps: 8, stepsize: 2, niceMax: 14)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 10, calcSteps: 8, stepsize: 2, niceMax: 14)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 11, calcSteps: 8, stepsize: 2, niceMax: 14)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 12, calcSteps: 8, stepsize: 2, niceMax: 14)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 13, calcSteps: 8, stepsize: 2, niceMax: 14)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 14, calcSteps: 14, stepsize: 1, niceMax: 13)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 15, calcSteps: 14, stepsize: 1, niceMax: 13)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 16, calcSteps: 14, stepsize: 1, niceMax: 13)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 17, calcSteps: 14, stepsize: 1, niceMax: 13)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 18, calcSteps: 14, stepsize: 1, niceMax: 13)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 19, calcSteps: 14, stepsize: 1, niceMax: 13)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 20, calcSteps: 14, stepsize: 1, niceMax: 13)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 30, calcSteps: 27, stepsize: 0.5, niceMax: 13)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 40, calcSteps: 27, stepsize: 0.5, niceMax: 13)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 50, calcSteps: 27, stepsize: 0.5, niceMax: 13)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 60, calcSteps: 27, stepsize: 0.5, niceMax: 13)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 70, calcSteps: 64, stepsize: 0.2, niceMax: 12.6)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 80, calcSteps: 64, stepsize: 0.2, niceMax: 12.6)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 90, calcSteps: 64, stepsize: 0.2, niceMax: 12.6)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 100, calcSteps: 64, stepsize: 0.2, niceMax: 12.6)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 110, calcSteps: 64, stepsize: 0.2, niceMax: 12.6)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 120, calcSteps: 64, stepsize: 0.2, niceMax: 12.6)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 130, calcSteps: 127, stepsize: 0.1, niceMax: 12.6)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 140, calcSteps: 127, stepsize: 0.1, niceMax: 12.6)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 150, calcSteps: 127, stepsize: 0.1, niceMax: 12.6)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 160, calcSteps: 127, stepsize: 0.1, niceMax: 12.6)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 170, calcSteps: 127, stepsize: 0.1, niceMax: 12.6)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 180, calcSteps: 127, stepsize: 0.1, niceMax: 12.6)
        try verifyFloatRangeAttributes(min: min, max: max, steps: 190, calcSteps: 127, stepsize: 0.1, niceMax: 12.6)
    }

    func verifyCGFloatRangeAttributes(min: CGFloat, max: CGFloat, steps: Int, calcSteps: Int, stepsize: CGFloat, niceMax: CGFloat) throws {
        XCTAssertTrue(steps > 1)
        let calculatedRange = CGFloat.rangeOfNiceValues(min: min, max: max, ofSize: steps)
        XCTAssertTrue(calculatedRange.first! <= min)
        XCTAssertTrue(calculatedRange.last! >= max)
        XCTAssertEqual(calculatedRange.count, calcSteps)
        let derivedStepSize = calculatedRange[1] - calculatedRange[0]
        XCTAssertEqual(derivedStepSize, stepsize, accuracy: 0.01)
        XCTAssertEqual(calculatedRange.last!, niceMax, accuracy: 0.01)
    }

    func testCGFloatNiceRange() throws {
        let min: CGFloat = 0.1
        let max: CGFloat = 12.56
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 2, calcSteps: 2, stepsize: 20, niceMax: 20)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 3, calcSteps: 3, stepsize: 10, niceMax: 20)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 4, calcSteps: 4, stepsize: 5, niceMax: 15)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 5, calcSteps: 5, stepsize: 5, niceMax: 20)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 6, calcSteps: 5, stepsize: 5, niceMax: 20)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 7, calcSteps: 5, stepsize: 5, niceMax: 20)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 8, calcSteps: 8, stepsize: 2, niceMax: 14)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 9, calcSteps: 8, stepsize: 2, niceMax: 14)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 10, calcSteps: 8, stepsize: 2, niceMax: 14)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 11, calcSteps: 8, stepsize: 2, niceMax: 14)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 12, calcSteps: 8, stepsize: 2, niceMax: 14)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 13, calcSteps: 8, stepsize: 2, niceMax: 14)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 14, calcSteps: 14, stepsize: 1, niceMax: 13)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 15, calcSteps: 14, stepsize: 1, niceMax: 13)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 16, calcSteps: 14, stepsize: 1, niceMax: 13)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 17, calcSteps: 14, stepsize: 1, niceMax: 13)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 18, calcSteps: 14, stepsize: 1, niceMax: 13)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 19, calcSteps: 14, stepsize: 1, niceMax: 13)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 20, calcSteps: 14, stepsize: 1, niceMax: 13)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 30, calcSteps: 27, stepsize: 0.5, niceMax: 13)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 40, calcSteps: 27, stepsize: 0.5, niceMax: 13)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 50, calcSteps: 27, stepsize: 0.5, niceMax: 13)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 60, calcSteps: 27, stepsize: 0.5, niceMax: 13)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 70, calcSteps: 64, stepsize: 0.2, niceMax: 12.6)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 80, calcSteps: 64, stepsize: 0.2, niceMax: 12.6)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 90, calcSteps: 64, stepsize: 0.2, niceMax: 12.6)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 100, calcSteps: 64, stepsize: 0.2, niceMax: 12.6)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 110, calcSteps: 64, stepsize: 0.2, niceMax: 12.6)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 120, calcSteps: 64, stepsize: 0.2, niceMax: 12.6)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 130, calcSteps: 127, stepsize: 0.1, niceMax: 12.6)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 140, calcSteps: 127, stepsize: 0.1, niceMax: 12.6)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 150, calcSteps: 127, stepsize: 0.1, niceMax: 12.6)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 160, calcSteps: 127, stepsize: 0.1, niceMax: 12.6)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 170, calcSteps: 127, stepsize: 0.1, niceMax: 12.6)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 180, calcSteps: 127, stepsize: 0.1, niceMax: 12.6)
        try verifyCGFloatRangeAttributes(min: min, max: max, steps: 190, calcSteps: 127, stepsize: 0.1, niceMax: 12.6)
    }

    func verifyIntRangeAttributes(min: Int, max: Int, steps: Int, calcSteps: Int, stepsize: Int, niceMax: Int) throws {
        XCTAssertTrue(steps > 1)
        let calculatedRange = Int.rangeOfNiceValues(min: min, max: max, ofSize: steps)
        XCTAssertTrue(calculatedRange.first! <= min)
        XCTAssertTrue(calculatedRange.last! >= max)
        XCTAssertEqual(calculatedRange.count, calcSteps)
        let derivedStepSize = calculatedRange[1] - calculatedRange[0]
        XCTAssertEqual(derivedStepSize, stepsize)
        XCTAssertEqual(calculatedRange.last!, niceMax)
    }

    func testIntNiceRange() throws {
        let min = 1
        let max = 125
        try verifyIntRangeAttributes(min: min, max: max, steps: 2, calcSteps: 2, stepsize: 200, niceMax: 200)
        try verifyIntRangeAttributes(min: min, max: max, steps: 3, calcSteps: 3, stepsize: 100, niceMax: 200)
        try verifyIntRangeAttributes(min: min, max: max, steps: 3, calcSteps: 3, stepsize: 100, niceMax: 200)
    }
}
