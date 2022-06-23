//
//  ScaleTemplateTests.swift
//

import Foundation
@testable import SwiftVizScale
import XCTest

class ScaleTemplateTests: XCTestCase {
    func testDefaultInitializers() throws {
        let linear = ContinuousScale<Double, CGFloat>()
        XCTAssertFalse(linear.fullyConfigured())

        let log = ContinuousScale<Double, CGFloat>().scaleType(.log)
        XCTAssertFalse(log.fullyConfigured())

        let power = ContinuousScale<Double, CGFloat>().scaleType(.power(1))
        XCTAssertFalse(power.fullyConfigured())
    }

    func testFullyConfiguratedInitializers() throws {
        let linear = ContinuousScale<Double, CGFloat>(from: 0, to: 1)
        XCTAssertFalse(linear.fullyConfigured())

        let log = ContinuousScale<Double, CGFloat>(from: 1, to: 10).scaleType(.log)
        XCTAssertFalse(log.fullyConfigured())

        let power = ContinuousScale<Double, CGFloat>(from: 0, to: 1).scaleType(.power(1))
        XCTAssertFalse(power.fullyConfigured())
    }

    func testRefineScaleTemplate() throws {
        let linear = ContinuousScale<Double, CGFloat>().range(reversed: false, lower: 0, higher: 1)
        XCTAssertTrue(linear.fullyConfigured())

        let log = ContinuousScale<Double, CGFloat>().range(lower: 1, higher: 10).scaleType(.log)
        XCTAssertTrue(log.fullyConfigured())

        let power = ContinuousScale<Double, CGFloat>().range(lower: 0, higher: 1).scaleType(.power(1))
        XCTAssertTrue(power.fullyConfigured())
    }
}
