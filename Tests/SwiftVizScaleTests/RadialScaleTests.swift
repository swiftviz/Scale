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
            XCTAssertTrue(tick.value! >= myScale.domainLower)
            XCTAssertTrue(tick.value! <= myScale.domainHigher)
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

    func testArrayDomainModifier() {
        let myScale = RadialScale<Double, Float>(from: 1.0, to: 10.0)
        XCTAssertEqual(myScale.transformType, .none)

        let updated = myScale.domain([0.0, 15.0, 5.0])
        XCTAssertEqual(updated.domainLower, 0.0)
        XCTAssertEqual(updated.domainHigher, 20.0)
    }

    func testScaleDomainOfOneValue() {
        let scale = RadialScale<Double, CGFloat>()

        let updated = scale.domain([5.0])
        XCTAssertEqual(updated.domainLower, 5)
        XCTAssertEqual(updated.domainHigher, 5)
    }

    func testScaleDomainOfOneValueNiced() {
        let scale = RadialScale<Double, CGFloat>()

        let updated = scale.domain([5.0], nice: true)
        XCTAssertEqual(updated.domainLower, 5)
        XCTAssertEqual(updated.domainHigher, 5)
    }

    func testReversedRangeModifiers() {
        var scale = RadialScale<Double, CGFloat>(0 ... 100).range(0 ... 100)
        XCTAssertEqual(scale.reversed, false)
        scale = RadialScale(from: 0, to: 100, reversed: true, rangeLower: 0, rangeHigher: 100)
        XCTAssertEqual(scale.reversed, true)
        scale = scale.range(0 ... 40)
        XCTAssertEqual(scale.reversed, true)
        scale = scale.range(reversed: false, 0 ... 40)
        XCTAssertEqual(scale.reversed, false)
    }

    func testReversedCalculations() {
        let scale = RadialScale<Double, CGFloat>(from: 0, to: 100, reversed: true, rangeLower: 0, rangeHigher: 100)
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

    func testReversedTicks() {
        // Yes, ticks on a Radial Scale are kind of stupid. Radial Scale
        // is primarily intended for scaling for the area of a size element so that it visually
        // increases proportionally with the value.
        let reversed = RadialScale<Double, CGFloat>(from: 0, to: 100, reversed: true, rangeLower: 0, rangeHigher: 100)
        let reverseTicks = reversed.ticks(rangeLower: 0, rangeHigher: 20)
        XCTAssertEqual(reverseTicks.count, 2)
        assertTick(reverseTicks[0], "80.0", 16)
        assertTick(reverseTicks[1], "100.0", 0)

        let forward = reversed.range(reversed: false, lower: 0, higher: 20) // identity
        let forwardTicks = forward.ticks(rangeLower: 0, rangeHigher: 20)
        print(forwardTicks)
        XCTAssertEqual(forwardTicks.count, 2)
        assertTick(forwardTicks[0], "0.0", 0)
        assertTick(forwardTicks[1], "20.0", 16)
    }
}
