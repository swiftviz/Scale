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
        let scale1 = LinearScale.create(low, high)
        let scale2 = LinearScale.create(low ... high)
        let scale3 = LinearScale.create(high)

        XCTAssertEqual(scale1.domainLower, scale2.domainLower)
        XCTAssertEqual(scale1.domainExtent, scale2.domainExtent)
        XCTAssertEqual(scale1.domainLower, 6)
        XCTAssertEqual(scale3.domainLower, 0)
    }

    func testFloatScaleFactoryMethods() throws {
        let low: Float = 6
        let high: Float = 124

        let scale1 = LinearScale.create(low, high)
        let scale2 = LinearScale.create(low ... high)
        let scale3 = LinearScale.create(high)

        XCTAssertEqual(scale1.domainLower, scale2.domainLower)
        XCTAssertEqual(scale1.domainExtent, scale2.domainExtent)
        XCTAssertEqual(scale1.domainLower, 6)
        XCTAssertEqual(scale3.domainLower, 0)
    }

    func testDoubleScaleFactoryMethods() throws {
        let low: Double = 6
        let high: Double = 124

        let scale1 = LinearScale.create(low, high)
        let scale2 = LinearScale.create(low ... high)
        let scale3 = LinearScale.create(high)

        XCTAssertEqual(scale1.domainLower, scale2.domainLower)
        XCTAssertEqual(scale1.domainExtent, scale2.domainExtent)
        XCTAssertEqual(scale1.domainLower, 6)
        XCTAssertEqual(scale3.domainLower, 0)
    }

    func testDateScaleFactoryMethods() throws {
        let low = Date(timeIntervalSince1970: 123_456_789)
        let high: Date = low.addingTimeInterval(5 * 60)

        let scale1 = LinearScale.create(low, high)
        let scale2 = LinearScale.create(low ... high)

        XCTAssertEqual(scale1.domainLower, scale2.domainLower)
        XCTAssertEqual(scale1.domainExtent, scale2.domainExtent)
        XCTAssertEqual(scale1.domainLower, low.timeIntervalSince1970)
    }

    func testScaleConvenienceMethod() throws {
        let lin = LinearScale.create(0, 100.0)
        guard let result = lin.scale(5.0, to: 10.0) else {
            XCTFail()
            return
        }
        XCTAssertEqual(result, 0.5, accuracy: 0.001)
    }

    func testInvertConvenienceMethod() throws {
        let lin = LinearScale.create(0, 100.0)
        guard let result = lin.invert(5.0, to: 10.0) else {
            XCTFail()
            return
        }
        XCTAssertEqual(result, 50, accuracy: 0.001)
    }
}
