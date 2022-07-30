//
//  ScaleFactoryTests.swift
//

import SwiftVizScale
import XCTest

class ScaleFactoryTests: XCTestCase {
    func testIntScaleFactoryMethods() throws {
        let low: Int = 6
        let high: Int = 124
        let scale1 = ContinuousScale<CGFloat>(from: low, to: high)
        let scale2 = ContinuousScale<CGFloat>(low ... high)
        let scale3 = ContinuousScale<CGFloat>(high)

        XCTAssertEqual(scale1.domainLower, scale2.domainLower)
        XCTAssertEqual(scale1.domainLower, 6)
        XCTAssertEqual(scale3.domainLower, 0)
    }

    func testDoubleScaleFactoryMethods() throws {
        let low: Double = 6
        let high: Double = 124

        let scale1 = ContinuousScale<CGFloat>(from: low, to: high)
        let scale2 = ContinuousScale<CGFloat>(low ... high)
        let scale3 = ContinuousScale<CGFloat>(high)

        XCTAssertEqual(scale1.domainLower, scale2.domainLower)
        XCTAssertEqual(scale1.domainLower, 6)
        XCTAssertEqual(scale3.domainLower, 0)
    }

    func testScaleConvenienceMethod() throws {
        let lin = ContinuousScale<CGFloat>(from: 0, to: 100.0)
        guard let result = lin.scale(5.0, to: 10.0) else {
            XCTFail()
            return
        }
        XCTAssertEqual(result, 0.5, accuracy: 0.001)
    }

    func testInvertConvenienceMethod() throws {
        let lin = ContinuousScale<CGFloat>(from: 0, to: 100.0)
        guard let result = lin.invert(5.0, to: 10.0) else {
            XCTFail()
            return
        }
        XCTAssertEqual(result, 50, accuracy: 0.001)
    }
}
