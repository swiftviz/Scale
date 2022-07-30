//
//  ExternalPackageTests.swift
//

import Foundation
import SwiftVizScale
import XCTest

final class PackagingTests: XCTestCase {
    func testManualTicks() {
        let scale = ContinuousScale<CGFloat>(lower: 0.0, higher: 10.0, transform: .none)
        // verifies the method is visible externally - else this won't compile
        let ticks = scale.ticksFromValues([2.0], from: 0.0, to: 10.0)
        XCTAssertEqual(ticks.count, 1)
    }

    func testManualTicksOutsideRangeNone() {
        let scale = ContinuousScale<CGFloat>(lower: 0.0, higher: 10.0, transform: .none)
        let ticks = scale.ticksFromValues([2.0, 4.0, 8.0, 16.0], from: 0.0, to: 10.0)
        XCTAssertEqual(ticks.count, 3)
    }

    func testManualTicksOutsideRangeClamped() {
        let scale = ContinuousScale<CGFloat>(lower: 0.0, higher: 10.0, transform: .clamp)
        let ticks = scale.ticksFromValues([2.0, 4.0, 8.0, 16.0], from: 0.0, to: 10.0)
        XCTAssertEqual(ticks.count, 3)
    }

    func testManualTicksOutsideRangeDropped() {
        let scale = ContinuousScale<CGFloat>(lower: 0.0, higher: 10.0, transform: .drop)
        let ticks = scale.ticksFromValues([2.0, 4.0, 8.0, 16.0], from: 0.0, to: 10.0)
        XCTAssertEqual(ticks.count, 3)
    }

    func testScaleTransform() {
        let scale = ContinuousScale<CGFloat>(lower: 0.0, higher: 10.0, transform: .none)
        // default isClamped is false - no clamping
        let inputs = [11.0, 1.0, 7.0]
        XCTAssertEqual(inputs.map { scale.transformAgainstDomain($0) }, inputs)

        let cScale = ContinuousScale<CGFloat>(lower: 5.0, higher: 10.0, transform: .clamp)
        XCTAssertEqual(inputs.map { cScale.transformAgainstDomain($0) }, [10.0, 5.0, 7.0])

        let dScale = ContinuousScale<CGFloat>(lower: 5.0, higher: 10.0, transform: .drop)
        XCTAssertEqual(inputs.map { dScale.transformAgainstDomain($0) }, [nil, nil, 7.0])
    }
}
