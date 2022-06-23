//
//  InterpolateTests.swift
//
//  Created by Joseph Heck on 4/19/19.
//

@testable import SwiftVizScale
import XCTest

final class InterpolateTests: XCTestCase {
    func testInterpolateMid() {
        let resultValue = interpolate(0.5, lower: 100.0, higher: 200.0)
        XCTAssertEqual(resultValue, 150.0, accuracy: 0.1)
    }

    func testInterpolateBelow() {
        let resultValue = interpolate(-0.5, lower: 100.0, higher: 200.0)
        XCTAssertEqual(resultValue, 50.0, accuracy: 0.1)
    }

    func testInterpolateLower() {
        let resultValue = interpolate(0.0, lower: 100.0, higher: 200.0)
        XCTAssertEqual(resultValue, 100.0, accuracy: 0.1)
    }

    func testInterpolateUpper() {
        let resultValue = interpolate(1.0, lower: 100.0, higher: 200.0)
        XCTAssertEqual(resultValue, 200.0, accuracy: 0.1)
    }

    func testInterpolateAbove() {
        let resultValue = interpolate(1.5, lower: 100.0, higher: 200.0)
        XCTAssertEqual(resultValue, 250.0, accuracy: 0.1)
    }

    func testInterpolateNearZero() {
        let resultValue = normalize(0.001, lower: 0.0, higher: 100.0)

        XCTAssertFalse(resultValue.isNaN)
        XCTAssertEqual(resultValue, 0.0, accuracy: 0.01)
    }
}
