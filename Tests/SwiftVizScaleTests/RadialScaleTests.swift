//
//  RadialScaleTests.swift
//

@testable import SwiftVizScale
import XCTest

class RadialScaleTests: XCTestCase {
    func testRadialScale() {
        let myScale = ContinuousScale<CGFloat>(from: 0.0, to: 10.0, type: .radial)
        XCTAssertEqual(myScale.transformType, .none)
        XCTAssertEqual(myScale.scaleType, .radial)
        XCTAssertEqual(myScale.desiredTicks, 10)

        let testRange = CGFloat(0) ... CGFloat(10.0)
        let reconfiguredScale = myScale.range(testRange)

        XCTAssertEqual(4, reconfiguredScale.scale(2))
        XCTAssertEqual(2, reconfiguredScale.invert(4))
    }

    func testRadialScaleRangeInitializer() {
        let myScale = ContinuousScale(0.0 ... 10.0, type: .radial, rangeLower: CGFloat(0), rangeHigher: CGFloat(10))
        XCTAssertEqual(myScale.transformType, .none)
        XCTAssertEqual(myScale.scaleType, .radial)
        XCTAssertEqual(myScale.desiredTicks, 10)

        XCTAssertEqual(myScale.rangeLower, 0)
        XCTAssertEqual(myScale.rangeHigher, 10)
    }

    func testRadialScaleCompleteInitializer() {
        let myScale = ContinuousScale(from: 0, to: 100, type: .radial, transform: .clamp, desiredTicks: 5, rangeLower: 0, rangeHigher: 50)
        XCTAssertEqual(myScale.transformType, .clamp)
        XCTAssertEqual(myScale.scaleType, .radial)
        XCTAssertEqual(myScale.desiredTicks, 5)

        XCTAssertEqual(myScale.rangeLower, 0)
        XCTAssertEqual(myScale.rangeHigher, 50)
    }

    func testReversedCalculations() {
        let scale = ContinuousScale<CGFloat>(from: 0, to: 100, type: .radial, reversed: true, rangeLower: 0, rangeHigher: 100)
        XCTAssertEqual(scale.scale(0), 10000)
        XCTAssertEqual(scale.scale(100), 0)
        XCTAssertEqual(scale.scale(10), 8100)
        // verify invert
        XCTAssertEqual(scale.invert(8100)!, 10.0, accuracy: 0.001)

        let forward = scale.range(reversed: false, lower: 0, higher: 100) // log identity
        XCTAssertEqual(forward.scale(0), 0)
        XCTAssertEqual(forward.scale(100), 10000)
        XCTAssertEqual(forward.scale(10)!, 100.0, accuracy: 0.001)
        // verify invert
        XCTAssertEqual(forward.invert(100)!, 10.0, accuracy: 0.001)
    }
}
