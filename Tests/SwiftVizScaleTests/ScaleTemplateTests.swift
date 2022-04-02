//
//  ScaleTemplateTests.swift
//
//
//  Created by Joseph Heck on 4/1/22.
//

import Foundation
@testable import SwiftVizScale
import XCTest

class ScaleTemplateTests: XCTestCase {
    func testDefaultInitializers() throws {
        let linear = LinearScale<Double, CGFloat>()
        XCTAssertFalse(linear.fullyConfigured())

        let log = LogScale<Double, CGFloat>()
        XCTAssertFalse(log.fullyConfigured())

        let power = PowerScale<Double, CGFloat>()
        XCTAssertFalse(power.fullyConfigured())
    }

    func testFullyConfiguratedInitializers() throws {
        let linear = LinearScale<Double, CGFloat>(from: 0, to: 1)
        XCTAssertFalse(linear.fullyConfigured())

        let log = LogScale<Double, CGFloat>(from: 1, to: 10)
        XCTAssertFalse(log.fullyConfigured())

        let power = PowerScale<Double, CGFloat>(from: 0, to: 1)
        XCTAssertFalse(power.fullyConfigured())
    }

    func testRefineScaleTemplate() throws {
        let linear = LinearScale<Double, CGFloat>().range(lower: 0, higher: 1)
        XCTAssertTrue(linear.fullyConfigured())

        let log = LogScale<Double, CGFloat>().range(lower: 1, higher: 10)
        XCTAssertTrue(log.fullyConfigured())

        let power = PowerScale<Double, CGFloat>().range(lower: 0, higher: 1)
        XCTAssertTrue(power.fullyConfigured())
    }
}
