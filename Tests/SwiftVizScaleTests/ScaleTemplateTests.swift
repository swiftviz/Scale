//
//  ScaleTemplateTests.swift
//
//
//  Created by Joseph Heck on 4/1/22.
//

import Foundation
import SwiftVizScale
import XCTest

class ScaleTemplateTests: XCTestCase {
    func testDefaultInitializers() throws {
        let linear = LinearScale<Double, CGFloat>()
        XCTAssertEqual(linear.defaultDomain, true)

        let log = LogScale<Double, CGFloat>()
        XCTAssertEqual(log.defaultDomain, true)

        let power = PowerScale<Double, CGFloat>()
        XCTAssertEqual(power.defaultDomain, true)
    }

    func testFullyConfiguratedInitializers() throws {
        let linear = LinearScale<Double, CGFloat>(from: 0, to: 1)
        XCTAssertEqual(linear.defaultDomain, false)

        let log = LogScale<Double, CGFloat>(from: 1, to: 10)
        XCTAssertEqual(log.defaultDomain, false)

        let power = PowerScale<Double, CGFloat>(from: 0, to: 1)
        XCTAssertEqual(power.defaultDomain, false)
    }

    func testRefineScaleTemplate() throws {
        let linear = LinearScale<Double, CGFloat>().withDomain(lower: 0, higher: 1)
        XCTAssertEqual(linear.defaultDomain, false)

        let log = LogScale<Double, CGFloat>().withDomain(lower: 1, higher: 10)
        XCTAssertEqual(log.defaultDomain, false)

        let power = PowerScale<Double, CGFloat>().withDomain(lower: 0, higher: 1)
        XCTAssertEqual(power.defaultDomain, false)
    }
}
