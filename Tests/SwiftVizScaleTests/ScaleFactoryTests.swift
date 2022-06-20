//
//  ScaleFactoryTests.swift
//
//
//  Created by Joseph Heck on 3/9/22.
//

import SwiftVizScale
import XCTest

class ScaleFactoryTests: XCTestCase {
    func testIntScaleFactoryMethods() throws {
        let low = 6
        let high = 124
        let scale1 = LinearScale<Int, CGFloat>(from: low, to: high)
        let scale2 = LinearScale<Int, CGFloat>(low ... high)
        let scale3 = LinearScale<Int, CGFloat>(high)

        XCTAssertEqual(scale1.domainLower, scale2.domainLower)
        XCTAssertEqual(scale1.domainExtent, scale2.domainExtent)
        XCTAssertEqual(scale1.domainLower, 6)
        XCTAssertEqual(scale3.domainLower, 0)
    }

//    func testFloatScaleFactoryMethods() throws {
//        let low: Float = 6
//        let high: Float = 124
//
//        let scale1 = LinearScale<Float, CGFloat>(from: low, to: high)
//        let scale2 = LinearScale<Float, CGFloat>(low ... high)
//        let scale3 = LinearScale<Float, CGFloat>(high)
//
//        XCTAssertEqual(scale1.domainLower, scale2.domainLower)
//        XCTAssertEqual(scale1.domainExtent, scale2.domainExtent)
//        XCTAssertEqual(scale1.domainLower, 6)
//        XCTAssertEqual(scale3.domainLower, 0)
//    }

    func testDoubleScaleFactoryMethods() throws {
        let low: Double = 6
        let high: Double = 124

        let scale1 = LinearScale<Double, CGFloat>(from: low, to: high)
        let scale2 = LinearScale<Double, CGFloat>(low ... high)
        let scale3 = LinearScale<Double, CGFloat>(high)

        XCTAssertEqual(scale1.domainLower, scale2.domainLower)
        XCTAssertEqual(scale1.domainExtent, scale2.domainExtent)
        XCTAssertEqual(scale1.domainLower, 6)
        XCTAssertEqual(scale3.domainLower, 0)
    }

    func testScaleConvenienceMethod() throws {
        let lin = LinearScale<Double, CGFloat>(from: 0, to: 100.0)
        guard let result = lin.scale(5.0, to: 10.0) else {
            XCTFail()
            return
        }
        XCTAssertEqual(result, 0.5, accuracy: 0.001)
    }

    func testInvertConvenienceMethod() throws {
        let lin = LinearScale<Double, CGFloat>(from: 0, to: 100.0)
        guard let result = lin.invert(5.0, to: 10.0) else {
            XCTFail()
            return
        }
        XCTAssertEqual(result, 50, accuracy: 0.001)
    }
}
