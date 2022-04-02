//
//  PowerScaleTests.swift
//
//
//  Created by Joseph Heck on 3/10/22.
//

import SwiftVizScale
import XCTest

class PowerScaleTests: XCTestCase {
    func testPowerScaleFactoryMethods() throws {
        let first = PowerScale<Double, CGFloat>(from: 0, to: 100, exponent: 3)
        let second = PowerScale<Double, CGFloat>(0.0 ... 100.0, exponent: 3)
        let third = PowerScale<Double, CGFloat>(100, exponent: 0.5)
        XCTAssertNotNil(first)
        XCTAssertNotNil(second)
        XCTAssertNotNil(third)
    }

    func testPowerScale_scale_identity() throws {
        let pow = PowerScale<Double, CGFloat>(from: 0, to: 100, exponent: 1)
        guard let result = pow.scale(2, from: 0, to: 100) else {
            XCTFail()
            return
        }
        XCTAssertEqual(result, 2.0, accuracy: 0.001)
    }

    func testPowerScale_scale_square() throws {
        let pow = PowerScale<Double, CGFloat>(from: 0, to: 10, exponent: 2)
        guard let result = pow.scale(2, from: 0, to: 100) else {
            XCTFail()
            return
        }
        XCTAssertEqual(result, 20.0, accuracy: 0.001)
    }

    func testPowerScale_invert_identity() throws {
        let pow = PowerScale<Double, CGFloat>(from: 0, to: 100, exponent: 1)
        guard let result = pow.invert(5, from: 0, to: 100) else {
            XCTFail()
            return
        }
        XCTAssertEqual(result, 5, accuracy: 0.001)
    }

    func testPowerScale_invert_square() throws {
        let pow = PowerScale<Double, CGFloat>(from: 0, to: 10, exponent: 2)
        guard let result = pow.invert(16, from: 0, to: 100) else {
            XCTFail()
            return
        }
        XCTAssertEqual(result, 1.6, accuracy: 0.001)
    }
}
