//
//  AnyContinuousScaleTests.swift
//
//
//  Created by Joseph Heck on 4/6/22.
//

import SwiftVizScale
import XCTest

class AnyContinuousScaleTests: XCTestCase {
    func testAnyContinuousScaleInitializer() throws {
        let linear = LinearScale<Double, CGFloat>(0.0 ... 50.0)
        let cScale = AnyContinuousScale(linear)
        XCTAssertEqual(cScale.domainExtent, 50)
        XCTAssertEqual(cScale.domainLower, 0, accuracy: 0.001)
        XCTAssertEqual(cScale.domainHigher, 50, accuracy: 0.001)
        XCTAssertEqual(cScale.transformType, .none)
        XCTAssertEqual(cScale.scaleType, .linear)
    }

    func testAnyContinuousScaleModifiers() throws {
        let linear = LinearScale<Double, CGFloat>(0.0 ... 50.0)
        let cScale = AnyContinuousScale(linear)
        XCTAssertEqual(cScale.domainExtent, 50)
        XCTAssertEqual(cScale.domainLower, 0, accuracy: 0.001)
        XCTAssertEqual(cScale.domainHigher, 50, accuracy: 0.001)

        XCTAssertNil(cScale.scale(25))
        XCTAssertNil(cScale.invert(25))

        var updated = cScale.domain(lower: -50, higher: 50)
        XCTAssertEqual(updated.domainExtent, 100)
        XCTAssertEqual(updated.domainLower, -50, accuracy: 0.001)
        XCTAssertEqual(updated.domainHigher, 50, accuracy: 0.001)

        updated = cScale.range(lower: 0, higher: 100)
        XCTAssertEqual(updated.scale(10), 20)
        XCTAssertEqual(updated.invert(60), 30)

        updated = cScale.transform(.drop)
        XCTAssertEqual(updated.transformType, .drop)
    }

    func testAnyContinuousScaleMethods() throws {
        let linear = LinearScale<Double, CGFloat>(0.0 ... 50.0)
        let cScale = AnyContinuousScale(linear)
        XCTAssertEqual(cScale.domainExtent, 50)
        XCTAssertEqual(cScale.domainLower, 0, accuracy: 0.001)
        XCTAssertEqual(cScale.domainHigher, 50, accuracy: 0.001)

        XCTAssertEqual(20, cScale.scale(10, from: 0, to: 100))
        XCTAssertEqual(25, cScale.invert(50, from: 0, to: 100))
    }

    func testAnyContinuousScaleConversions() throws {
        let linearScale = AnyContinuousScale(LinearScale<Double, CGFloat>(1.0 ... 50.0))
        XCTAssertEqual(linearScale.scaleType, .linear)

        let log = linearScale.scaleType(.log)
        XCTAssertEqual(log.scaleType, .log)

        let power = linearScale.scaleType(.power(2))
        XCTAssertEqual(power.scaleType, .power(2))
    }

    func testArrayDomainModifier() {
        let myScale = AnyContinuousScale(LinearScale<Double, CGFloat>(1.0 ... 50.0))
        XCTAssertEqual(myScale.scaleType, .linear)

        let updated = myScale.domain([0.0, 15.0, 5.0])
        XCTAssertEqual(updated.domainLower, 0.0)
        XCTAssertEqual(updated.domainHigher, 20.0)
    }

    func testArrayDomainModifierWithoutNice() {
        let myScale = AnyContinuousScale(LinearScale<Double, CGFloat>(1.0 ... 50.0))
        XCTAssertEqual(myScale.scaleType, .linear)

        let updated = myScale.domain([0.0, 15.0, 5.0], nice: false)
        XCTAssertEqual(updated.domainLower, 0.0)
        XCTAssertEqual(updated.domainHigher, 15.0)
    }
}
