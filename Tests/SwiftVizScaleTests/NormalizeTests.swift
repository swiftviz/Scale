//
//  NormalizeTests.swift
//

@testable import SwiftVizScale
import XCTest

final class NormalizeTests: XCTestCase {
    func testNormalizeMid() {
        let resultValue = normalize(150.0, lower: 100.0, higher: 200.0)
        XCTAssertFalse(resultValue.isNaN)
        XCTAssertEqual(resultValue, 0.5, accuracy: 0.01)
    }

    func testNormalizeLower() {
        let resultValue = normalize(100.0, lower: 100.0, higher: 200.0)

        XCTAssertFalse(resultValue.isNaN)
        XCTAssertEqual(resultValue, 0.0, accuracy: 0.01)
    }

    func testNormalizeNearZero() {
        let resultValue = normalize(0.1, lower: 0.0, higher: 100.0)

        XCTAssertFalse(resultValue.isNaN)
        XCTAssertEqual(resultValue, 0.0, accuracy: 0.01)
    }

    func testNormalizeUpper() {
        let resultValue = normalize(199.9, lower: 100.0, higher: 200.0)
        XCTAssertFalse(resultValue.isNaN)
        XCTAssertEqual(resultValue, 1.0, accuracy: 0.01)
    }

    func testNormalizeUpperLimit() {
        let resultValue = normalize(200.0, lower: 100.0, higher: 200.0)
        XCTAssertFalse(resultValue.isNaN)
        XCTAssertEqual(resultValue, 1.0, accuracy: 0.01)
    }

    func testNormalizeAbove() {
        let resultValue = normalize(201.0, lower: 100.0, higher: 200.0)
        XCTAssertEqual(resultValue, 1.01, accuracy: 0.0001)
    }
}
