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

        XCTAssertEqual(first.description, "0..<5")
        XCTAssertEqual(last.description, "10...15")
    }

    func testHistogramBinRangeComparable() throws {
        let first = HistogramBinRange(lowerBound: 0, upperBound: 5)
        let second = HistogramBinRange(lowerBound: 5, upperBound: 10)
        let last = HistogramBinRange(lowerBound: 10, upperBound: 15, _final: true)

        XCTAssertTrue(first < second)
        XCTAssertTrue(second < last)
        XCTAssertTrue(first < last)
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

    func testInferredHistogramInitializerInt() throws {
        let h = Histogram(data: listIntOutliers)
        XCTAssertNotNil(h)
        // create an array of range-count tuples to inspect how the histogram was created
        let flayedHistogram = Array(h)

        XCTAssertEqual(flayedHistogram.count, 4)
        // print(flayedHistogram[0])
        let (firstRange, firstCount) = flayedHistogram[0]
        XCTAssertEqual(firstRange.lowerBound, 2)
        XCTAssertEqual(firstRange.upperBound, 22)
        XCTAssertEqual(firstCount, 11)

        // print(flayedHistogram[1])
        let (secondRange, secondCount) = flayedHistogram[1]
        XCTAssertEqual(secondRange.lowerBound, 22)
        XCTAssertEqual(secondRange.upperBound, 42)
        XCTAssertEqual(secondCount, 0)

        // print(flayedHistogram[2])
        let (thirdRange, thirdCount) = flayedHistogram[2]
        XCTAssertEqual(thirdRange.lowerBound, 42)
        XCTAssertEqual(thirdRange.upperBound, 62)
        XCTAssertEqual(thirdCount, 0)

        // print(flayedHistogram[3])
        let (fourthRange, fourthCount) = flayedHistogram[3]
        XCTAssertEqual(fourthRange.lowerBound, 62)
        XCTAssertEqual(fourthRange.upperBound, 65)
        XCTAssertEqual(fourthCount, 1)

        XCTAssertEqual(h.lowerBound, 2)
        XCTAssertEqual(h.upperBound, 65)
        XCTAssertFalse(h.isEmpty)
    }

    func testEmptyDoubleHistogram() throws {
        let emptyDouble: [Double] = []
        let h = Histogram(data: emptyDouble)
        XCTAssertEqual(h.lowerBound, 0)
        XCTAssertEqual(h.upperBound, 0)
        XCTAssertTrue(h.isEmpty)
    }

    func testEmptyIntHistogram() throws {
        let emptyDouble: [Int] = []
        let h = Histogram(data: emptyDouble)
        XCTAssertEqual(h.lowerBound, 0)
        XCTAssertEqual(h.upperBound, 0)
        XCTAssertTrue(h.isEmpty)
    }

    func testInferredHistogramInitializerFloat() throws {
        let h = Histogram(data: listDoubleClose)
        XCTAssertNotNil(h)
        // create an array of range-count tuples to inspect how the histogram was created
        let flayedHistogram = Array(h)

        XCTAssertEqual(flayedHistogram.count, 3)
        // print(flayedHistogram[0])
        let (firstRange, firstCount) = flayedHistogram[0]
        XCTAssertEqual(firstRange.lowerBound, 2)
        XCTAssertEqual(firstRange.upperBound, 4, accuracy: 0.01)
        XCTAssertEqual(firstCount, 6)

        // print(flayedHistogram[1])
        let (secondRange, secondCount) = flayedHistogram[1]
        XCTAssertEqual(secondRange.lowerBound, 4, accuracy: 0.01)
        XCTAssertEqual(secondRange.upperBound, 6, accuracy: 0.01)
        XCTAssertEqual(secondCount, 5)

        // print(flayedHistogram[2])
        let (thirdRange, thirdCount) = flayedHistogram[2]
        XCTAssertEqual(thirdRange.lowerBound, 6, accuracy: 0.01)
        XCTAssertEqual(thirdRange.upperBound, 8)
        XCTAssertEqual(thirdCount, 4)
    }

    func testStrideHistogramInitializer() throws {
        let h = Histogram(data: listDoubleClose, minimumStride: 2.0)
        XCTAssertNotNil(h)
        // create an array of range-count tuples to inspect how the histogram was created
        let flayedHistogram = Array(h)

        XCTAssertEqual(flayedHistogram.count, 3)
        // print(flayedHistogram[0])
        let (firstRange, firstCount) = flayedHistogram[0]
        XCTAssertEqual(firstRange.lowerBound, 2)
        XCTAssertEqual(firstRange.upperBound, 4)
        XCTAssertEqual(firstCount, 6)

        // print(flayedHistogram[1])
        let (secondRange, secondCount) = flayedHistogram[1]
        XCTAssertEqual(secondRange.lowerBound, 4)
        XCTAssertEqual(secondRange.upperBound, 6)
        XCTAssertEqual(secondCount, 5)

        // print(flayedHistogram[2])
        let (thirdRange, thirdCount) = flayedHistogram[2]
        XCTAssertEqual(thirdRange.lowerBound, 6)
        XCTAssertEqual(thirdRange.upperBound, 8)
        XCTAssertEqual(thirdCount, 4)
    }

    func testHistogramDescription() throws {
        let h = Histogram(data: listDoubleClose, minimumStride: 2.0)
        XCTAssertEqual(String(describing: h), "[2.0..<4.0: 6, 4.0..<6.0: 5, 6.0..<8.0: 4]")
    }

    func testStrideHistogramInitializerDesiredCountIntClose() throws {
        let h = Histogram(data: listIntClose, minimumStride: 1, desiredCount: 10)
        XCTAssertNotNil(h)
        // create an array of range-count tuples to inspect how the histogram was created
        let flayedHistogram = Array(h)

        XCTAssertEqual(flayedHistogram.count, 6)
    }

    func testStrideHistogramInitializerDesiredCountDoubleClose() throws {
        let h = Histogram(data: listDoubleClose, minimumStride: 1, desiredCount: 10)
        XCTAssertNotNil(h)
        // create an array of range-count tuples to inspect how the histogram was created
        let flayedHistogram = Array(h)

        XCTAssertEqual(flayedHistogram.count, 6)
    }

    func testStrideHistogramInitializerDesiredCountFloatOutlier() throws {
        let h = Histogram(data: listDoubleOutliers, minimumStride: 1.0, desiredCount: 10)
        XCTAssertNotNil(h)
        // create an array of range-count tuples to inspect how the histogram was created
        let flayedHistogram = Array(h)

        XCTAssertEqual(flayedHistogram.count, 11)
    }

    func testStrideHistogramInitializerDesiredCountFloatClose() throws {
        let h = Histogram(data: listIntOutliers, minimumStride: 1, desiredCount: 10)
        XCTAssertNotNil(h)
        // create an array of range-count tuples to inspect how the histogram was created
        let flayedHistogram = Array(h)

        XCTAssertEqual(flayedHistogram.count, 11)
    }

    func testThresholdHistogramInitializer() throws {
        let h = Histogram(data: listIntOutliers, thresholds: [0, 2, 5, 10, 20, 50, 100])
        XCTAssertNotNil(h)
        // create an array of range-count tuples to inspect how the histogram was created
        let flayedHistogram = Array(h)

        XCTAssertEqual(flayedHistogram.count, 6)
        XCTAssertEqual(h.description, "[0..<2: 0, 2..<5: 4, 5..<10: 6, 10..<20: 0, 20..<50: 1, 50...100: 1]")
    }

    func testIntHistogramWithBounds() throws {
        let h = Histogram(data: listIntOutliers, minimumStride: 1, bounds: 0 ... 15, desiredCount: 10)

        // create an array of range-count tuples to inspect how the histogram was created
        let flayedHistogram = Array(h)
        XCTAssertEqual(flayedHistogram.count, 8)
        // Note that with setting the bounds, the outliers are excluded...
        XCTAssertEqual(h.description, "[0..<2: 0, 2..<4: 3, 4..<6: 0, 6..<8: 1, 8..<10: 0, 10..<12: 0, 12..<14: 0, 14...15: 0]")
    }

    func testFloatHistogramWithBounds() throws {
        let h = Histogram(data: listDoubleClose, minimumStride: 1, bounds: 0 ... 15, desiredCount: 10)

        // create an array of range-count tuples to inspect how the histogram was created
        let flayedHistogram = Array(h)
        XCTAssertEqual(flayedHistogram.count, 10)
        XCTAssertEqual(h.description, "[0.0..<1.5: 0, 1.5..<3.0: 4, 3.0..<4.5: 4, 4.5..<6.0: 3, 6.0..<7.5: 4, 7.5..<9.0: 1, 9.0..<10.5: 0, 10.5..<12.0: 0, 12.0..<13.5: 0, 13.5..<15.0: 0]")
    }
}
