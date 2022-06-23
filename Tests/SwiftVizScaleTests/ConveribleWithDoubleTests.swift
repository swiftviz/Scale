//
//  ConveribleWithDoubleTests.swift
//

import Foundation
import SwiftVizScale
import XCTest

class ConveribleWithDoubleTests: XCTestCase {
    // Int

    func testForwardIntConversion() throws {
        let value = 5
        XCTAssertEqual(5.0, value.toDouble())
    }

    func testReverseIntConversion() throws {
        let value = 5.0
        XCTAssertEqual(5, Double.fromDouble(value))
    }

    // Float

    func testForwardFloatConversion() throws {
        let value: Float = 5
        XCTAssertEqual(5.0, value.toDouble())
    }

    func testReverseFloatConversion() throws {
        let value = 5.0
        XCTAssertEqual(5.0, Float.fromDouble(value))
    }

    // CGFloat

    func testForwardCGFloatConversion() throws {
        let value: CGFloat = 5
        XCTAssertEqual(5.0, value.toDouble())
    }

    func testReverseCGFloatConversion() throws {
        let value = 5.0
        XCTAssertEqual(5, CGFloat.fromDouble(value))
    }

    // Double

    func testForwardDoubleConversion() throws {
        let value: Double = 5
        XCTAssertEqual(5.0, value.toDouble())
    }

    func testReverseDoubleConversion() throws {
        let value = 5.0
        XCTAssertEqual(5.0, Double.fromDouble(value))
    }
}
