//
//  ScaleTemplateTests.swift
//

import Foundation
@testable import SwiftVizScale
import XCTest

class ScaleTemplateTests: XCTestCase {
    func testDefaultInitializers() throws {
        let linear = ContinuousScale<CGFloat>()
        XCTAssertFalse(linear.fullyConfigured())

        let log = ContinuousScale<CGFloat>().scaleType(.log)
        XCTAssertFalse(log.fullyConfigured())

        let power = ContinuousScale<CGFloat>().scaleType(.power(1))
        XCTAssertFalse(power.fullyConfigured())
    }

    func testFullyConfiguratedInitializers() throws {
        let linear = ContinuousScale<CGFloat>(lower: 0, higher: 1)
        XCTAssertFalse(linear.fullyConfigured())

        let log = ContinuousScale<CGFloat>(lower: 1, higher: 10).scaleType(.log)
        XCTAssertFalse(log.fullyConfigured())

        let power = ContinuousScale<CGFloat>(lower: 0, higher: 1).scaleType(.power(1))
        XCTAssertFalse(power.fullyConfigured())
    }

    func testRefineScaleTemplate() throws {
        let linear = ContinuousScale<CGFloat>().range(reversed: false, lower: 0, higher: 1)
        XCTAssertTrue(linear.fullyConfigured())

        let log = ContinuousScale<CGFloat>().range(lower: 1, higher: 10).scaleType(.log)
        XCTAssertTrue(log.fullyConfigured())

        let power = ContinuousScale<CGFloat>().range(lower: 0, higher: 1).scaleType(.power(1))
        XCTAssertTrue(power.fullyConfigured())
    }
}
