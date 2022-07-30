//
//  HistogramTests.swift
//
//
//  Created by Joseph Heck on 7/30/22.
//

@testable import SwiftVizScale
import XCTest

final class HistogramTests: XCTestCase {
    let listIntOutliers: [Int] = [3, 6, 2, 2, 65, 7, 5, 2, 21, 5, 7, 8]
    let listDoubleOutliers: [Double] = [3, 6, 2, 2, 65, 7, 5, 2, 21, 5, 7, 8]

    let listIntClose: [Int] = [3, 6, 2, 2, 7, 5, 2, 5, 7, 8, 4, 2, 5, 4, 3, 6]
    let listDoubleClose: [Double] = [3, 6, 2, 2, 7, 5, 2, 5, 7, 8, 4, 2, 5, 4, 3, 6]

    func testHistogramBinRangeExpressions() throws {
        let first = HistogramBinRange(lowerBound: 0, upperBound: 5)
        let second = HistogramBinRange(lowerBound: 5, upperBound: 10)
        let last = HistogramBinRange(lowerBound: 10, upperBound: 15, _final: true)

        XCTAssertTrue(first.contains(0))
        XCTAssertTrue(first.contains(1))
        XCTAssertFalse(first.contains(5))
        XCTAssertTrue(second.contains(5))

        XCTAssertTrue(last.contains(10))
        XCTAssertTrue(last.contains(12))
        XCTAssertTrue(last.contains(15))
    }

    func testHistogramBinRangeRelative() throws {
        let first = HistogramBinRange(lowerBound: 0, upperBound: 5)
        let second = HistogramBinRange(lowerBound: 5, upperBound: 10)
        let last = HistogramBinRange(lowerBound: 10, upperBound: 15, _final: true)

        let myCollection = [-4, -2, 1, 2, 3, 6, 10, 12, 15, 20, 25, 30]

        let rangeFirst = first.relative(to: myCollection)
        let rangeSecond = second.relative(to: myCollection)
        let rangeLast = last.relative(to: myCollection)
        XCTAssertEqual(rangeFirst, 0 ..< 6)
        XCTAssertEqual(rangeSecond, 5 ..< 11)
        XCTAssertEqual(rangeLast, 10 ..< 16)

        let offCollection = [30, 31, 32, 33]
        XCTAssertEqual(rangeFirst.relative(to: offCollection), 0 ..< 6)
    }

    func testInferredHistogramInitializer() throws {
        let h = Histogram(data: listIntOutliers)
        XCTAssertNotNil(h)
        // create an array of range-count tuples to inspect how the histogram was created
        let flayedHistogram = Array(h)

        XCTAssertEqual(flayedHistogram.count, 3)
        // print(flayedHistogram[0])
        let (firstRange, firstCount) = flayedHistogram[0]
        XCTAssertEqual(firstRange.lowerBound, 2)
        XCTAssertEqual(firstRange.upperBound, 29)
        XCTAssertEqual(firstCount, 11)

        // print(flayedHistogram[1])
        let (secondRange, secondCount) = flayedHistogram[1]
        XCTAssertEqual(secondRange.lowerBound, 29)
        XCTAssertEqual(secondRange.upperBound, 56)
        XCTAssertEqual(secondCount, 0)

        // print(flayedHistogram[2])
        let (thirdRange, thirdCount) = flayedHistogram[2]
        XCTAssertEqual(thirdRange.lowerBound, 56)
        XCTAssertEqual(thirdRange.upperBound, 65)
        XCTAssertEqual(thirdCount, 1)
    }
}
