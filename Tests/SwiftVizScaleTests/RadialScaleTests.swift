//
//  RadialScaleTests.swift
//
//
//  Created by Joseph Heck on 4/6/22.
//

@testable import SwiftVizScale
import XCTest

class RadialScaleTests: XCTestCase {
    func testRadialScale() {
        let myScale = RadialScale<Double, CGFloat>(from: 0.0, to: 10.0)
        XCTAssertEqual(myScale.transformType, .none)
        XCTAssertEqual(myScale.scaleType, .radial)
        XCTAssertEqual(myScale.desiredTicks, 10)

        let testRange = CGFloat(0) ... CGFloat(10.0)
        let reconfiguredScale = myScale.range(testRange)

        XCTAssertEqual(4, reconfiguredScale.scale(2))
        XCTAssertEqual(2, reconfiguredScale.invert(4))
    }

    func testRadialScaleRangeInitializer() {
        let myScale = RadialScale(0.0 ... 10.0, rangeLower: CGFloat(0), rangeHigher: CGFloat(10))
        XCTAssertEqual(myScale.transformType, .none)
        XCTAssertEqual(myScale.scaleType, .radial)
        XCTAssertEqual(myScale.desiredTicks, 10)

        XCTAssertEqual(myScale.rangeLower, 0)
        XCTAssertEqual(myScale.rangeHigher, 10)
    }

    func testRadialScaleCompleteInitializer() {
        let myScale = RadialScale(from: 0, to: 100, transform: .clamp, desiredTicks: 5, rangeLower: 0, rangeHigher: 50)
        XCTAssertEqual(myScale.transformType, .clamp)
        XCTAssertEqual(myScale.scaleType, .radial)
        XCTAssertEqual(myScale.desiredTicks, 5)

        XCTAssertEqual(myScale.rangeLower, 0)
        XCTAssertEqual(myScale.rangeHigher, 50)
    }

    func testRadialScaleSingleInitializer() {
        let myScale = RadialScale(100, transform: .clamp, desiredTicks: 5, rangeLower: 0, rangeHigher: 50)
        XCTAssertEqual(myScale.transformType, .clamp)
        XCTAssertEqual(myScale.scaleType, .radial)
        XCTAssertEqual(myScale.desiredTicks, 5)

        XCTAssertEqual(myScale.rangeLower, 0)
        XCTAssertEqual(myScale.rangeHigher, 50)
    }

    func testRadialScaleWithRange() {
        let myScale = RadialScale<Double, CGFloat>(from: 0.0, to: 10.0)
        XCTAssertEqual(myScale.transformType, .none)
        XCTAssertEqual(myScale.scaleType, .radial)
        XCTAssertEqual(myScale.desiredTicks, 10)

        XCTAssertEqual(4, myScale.scale(2, from: 0, to: 10))
        XCTAssertEqual(2, myScale.invert(4, from: 0, to: 10))
    }

    func testRadialScaleTicks() {
        let myScale = RadialScale<Double, CGFloat>(from: 0.0, to: 10.0)
        XCTAssertEqual(myScale.transformType, .none)

        let testRange = CGFloat(0) ... CGFloat(100.0)
        let defaultTicks = myScale.ticks(rangeLower: testRange.lowerBound, rangeHigher: testRange.upperBound)
        XCTAssertEqual(defaultTicks.count, 1)
        for tick in defaultTicks {
            print(tick)
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(tick.value >= myScale.domainLower)
            XCTAssertTrue(tick.value <= myScale.domainHigher)
        }
    }

    func testRadialScaleDomainModifier() {
        let scale = RadialScale<Double, Float>()
        XCTAssertEqual(0, scale.domainLower)
        XCTAssertEqual(1, scale.domainHigher)
        XCTAssertNil(scale.rangeLower)
        XCTAssertNil(scale.rangeHigher)

        let updated = scale.domain(lower: 10, higher: 100)
        XCTAssertEqual(10, updated.domainLower)
        XCTAssertEqual(100, updated.domainHigher)
    }

    func testRadialScaleDomain2Modifier() {
        let scale = RadialScale<Double, Float>()
        XCTAssertEqual(0, scale.domainLower)
        XCTAssertEqual(1, scale.domainHigher)
        XCTAssertNil(scale.rangeLower)
        XCTAssertNil(scale.rangeHigher)

        let updated = scale.domain(10 ... 100)
        XCTAssertEqual(10, updated.domainLower)
        XCTAssertEqual(100, updated.domainHigher)
    }

    func testRadialScaleRangeModifier() {
        let scale = RadialScale<Double, Float>()
        XCTAssertEqual(0, scale.domainLower)
        XCTAssertEqual(1, scale.domainHigher)
        XCTAssertNil(scale.rangeLower)
        XCTAssertNil(scale.rangeHigher)

        let updated = scale.range(10 ... 100)
        XCTAssertEqual(10, updated.rangeLower)
        XCTAssertEqual(100, updated.rangeHigher)
        XCTAssertTrue(updated.fullyConfigured())
    }

    func testRadialScaleRange2Modifier() {
        let scale = RadialScale<Double, Float>()
        XCTAssertEqual(0, scale.domainLower)
        XCTAssertEqual(1, scale.domainHigher)
        XCTAssertNil(scale.rangeLower)
        XCTAssertNil(scale.rangeHigher)

        let updated = scale.range(lower: 10, higher: 100)
        XCTAssertEqual(10, updated.rangeLower)
        XCTAssertEqual(100, updated.rangeHigher)
        XCTAssertTrue(updated.fullyConfigured())
    }

    func testRadialScaleTransformModifier() {
        let scale = RadialScale<Double, Float>()
        XCTAssertEqual(scale.transformType, DomainDataTransform.none)

        let updated = scale.transform(.clamp)
        XCTAssertEqual(updated.transformType, DomainDataTransform.clamp)
    }
}
