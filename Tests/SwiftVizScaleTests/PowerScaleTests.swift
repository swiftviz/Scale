//
//  PowerScaleTests.swift
//
//
//  Created by Joseph Heck on 3/10/22.
//

@testable import SwiftVizScale
import XCTest

class PowerScaleTests: XCTestCase {
    func testPowerScaleFactoryMethods() throws {
        let first = PowerScale<Double, CGFloat>(from: 0, to: 100, exponent: 3)
        let second = PowerScale<Double, CGFloat>(0.0 ... 100.0, exponent: 3)
        let third = PowerScale<Double, CGFloat>(100, exponent: 0.5)
        XCTAssertNotNil(first)
        XCTAssertNotNil(second)
        XCTAssertNotNil(third)
    }

    func testPowerScale_scale_identity() throws {
        let pow = PowerScale<Double, CGFloat>(from: 0, to: 100, exponent: 1)
        guard let result = pow.scale(2, from: 0, to: 100) else {
            XCTFail()
            return
        }
        XCTAssertEqual(result, 2.0, accuracy: 0.001)
    }

    func testPowerScale_scale_square() throws {
        let pow = PowerScale<Double, CGFloat>(from: 0, to: 10, exponent: 2)
        guard let result = pow.scale(2, from: 0, to: 100) else {
            XCTFail()
            return
        }
        XCTAssertEqual(result, 20.0, accuracy: 0.001)
    }

    func testPowerScale_invert_identity() throws {
        let pow = PowerScale<Double, CGFloat>(from: 0, to: 100, exponent: 1)
        guard let result = pow.invert(5, from: 0, to: 100) else {
            XCTFail()
            return
        }
        XCTAssertEqual(result, 5, accuracy: 0.001)
    }

    func testPowerScale_invert_square() throws {
        let pow = PowerScale<Double, CGFloat>(from: 0, to: 10, exponent: 2)
        guard let result = pow.invert(16, from: 0, to: 100) else {
            XCTFail()
            return
        }
        XCTAssertEqual(result, 1.6, accuracy: 0.001)
    }

    func testDomainModifier() {
        let scale = PowerScale<Double, Float>()
        XCTAssertEqual(0, scale.domainLower)
        XCTAssertEqual(1, scale.domainHigher)
        XCTAssertNil(scale.rangeLower)
        XCTAssertNil(scale.rangeHigher)

        let updated = scale.domain(lower: 10, higher: 100)
        XCTAssertEqual(10, updated.domainLower)
        XCTAssertEqual(100, updated.domainHigher)
    }

    func testDomain2Modifier() {
        let scale = PowerScale<Double, Float>()
        XCTAssertEqual(0, scale.domainLower)
        XCTAssertEqual(1, scale.domainHigher)
        XCTAssertNil(scale.rangeLower)
        XCTAssertNil(scale.rangeHigher)

        let updated = scale.domain(10 ... 100)
        XCTAssertEqual(10, updated.domainLower)
        XCTAssertEqual(100, updated.domainHigher)
    }

    func testRangeModifier() {
        let scale = PowerScale<Double, Float>()
        XCTAssertNil(scale.rangeLower)
        XCTAssertNil(scale.rangeHigher)

        let updated = scale.range(10 ... 100)
        XCTAssertEqual(10, updated.rangeLower)
        XCTAssertEqual(100, updated.rangeHigher)
        XCTAssertTrue(updated.fullyConfigured())
    }

    func testRange2Modifier() {
        let scale = PowerScale<Double, Float>()
        XCTAssertNil(scale.rangeLower)
        XCTAssertNil(scale.rangeHigher)

        let updated = scale.range(lower: 10, higher: 100)
        XCTAssertEqual(10, updated.rangeLower)
        XCTAssertEqual(100, updated.rangeHigher)
        XCTAssertTrue(updated.fullyConfigured())
    }

    func testTransformModifier() {
        let scale = PowerScale<Double, Float>()
        XCTAssertEqual(scale.transformType, DomainDataTransform.none)

        let updated = scale.transform(.clamp)
        XCTAssertEqual(updated.transformType, DomainDataTransform.clamp)
    }

    func testArrayDomainModifier() {
        let myScale = PowerScale<Double, Float>(from: 1.0, to: 10.0)
        XCTAssertEqual(myScale.transformType, .none)

        let updated = myScale.domain([1.0, 15.0, 5.0])
        XCTAssertEqual(updated.domainLower, 0.0)
        XCTAssertEqual(updated.domainHigher, 20.0)
    }

    func testArrayDomainModifierWithoutNice() {
        let myScale = PowerScale<Double, Float>(from: 1.0, to: 10.0)
        XCTAssertEqual(myScale.transformType, .none)

        let updated = myScale.domain([1.0, 15.0, 5.0], nice: false)
        XCTAssertEqual(updated.domainLower, 1.0)
        XCTAssertEqual(updated.domainHigher, 15.0)
    }

    func testScaleDomainOfOneValue() {
        let scale = PowerScale<Double, CGFloat>()

        let updated = scale.domain([5.0])
        XCTAssertEqual(updated.domainLower, 0)
        XCTAssertEqual(updated.domainHigher, 5)
    }

    func testScaleDomainOfOneValueNiced() {
        let scale = PowerScale<Double, CGFloat>()

        let updated = scale.domain([5.0], nice: true)
        XCTAssertEqual(updated.domainLower, 0)
        XCTAssertEqual(updated.domainHigher, 5)
    }

    func testReversedRangeModifiers() {
        var scale = PowerScale<Double, CGFloat>(0 ... 100).range(0 ... 100)
        XCTAssertEqual(scale.reversed, false)
        scale = PowerScale(from: 0, to: 100, reversed: true, rangeLower: 0, rangeHigher: 100)
        XCTAssertEqual(scale.reversed, true)
        scale = scale.range(0 ... 40)
        XCTAssertEqual(scale.reversed, true)
        scale = scale.range(reversed: false, 0 ... 40)
        XCTAssertEqual(scale.reversed, false)
    }

    func testReversedCalculations() {
        let scale = PowerScale<Double, CGFloat>(from: 0, to: 100, reversed: true, rangeLower: 0, rangeHigher: 100)
        XCTAssertEqual(scale.scale(0), 100)
        XCTAssertEqual(scale.scale(100), 0)
        XCTAssertEqual(scale.scale(10), 90)
        // verify invert
        XCTAssertEqual(scale.invert(90)!, 10.0, accuracy: 0.001)

        let forward = scale.range(reversed: false, lower: 0, higher: 100) // log identity
        XCTAssertEqual(forward.scale(0), 0)
        XCTAssertEqual(forward.scale(100), 100)
        XCTAssertEqual(forward.scale(10)!, 10.0, accuracy: 0.001)
        // verify invert
        XCTAssertEqual(forward.invert(90)!, 90.0, accuracy: 0.001)
    }

    func testReversedTicks() {
        let reversed = PowerScale<Double, CGFloat>(from: 0, to: 100, reversed: true, rangeLower: 0, rangeHigher: 100)
        let reverseTicks = reversed.ticks(rangeLower: 0, rangeHigher: 20)
        XCTAssertEqual(reverseTicks.count, 6)
        assertTick(reverseTicks[0], "0.0", 20)
        assertTick(reverseTicks[1], "20.0", 16)
        assertTick(reverseTicks[2], "40.0", 12)
        assertTick(reverseTicks[3], "60.0", 8)
        assertTick(reverseTicks[4], "80.0", 4)
        assertTick(reverseTicks[5], "100.0", 0)

        let forward = reversed.range(reversed: false, lower: 0, higher: 20) // identity
        let forwardTicks = forward.ticks(rangeLower: 0, rangeHigher: 20)
        XCTAssertEqual(forwardTicks.count, 6)
        assertTick(forwardTicks[0], "0.0", 0)
        assertTick(forwardTicks[1], "20.0", 4)
        assertTick(forwardTicks[2], "40.0", 8)
        assertTick(forwardTicks[3], "60.0", 12)
        assertTick(forwardTicks[4], "80.0", 16)
        assertTick(forwardTicks[5], "100.0", 20)
    }
}
