//
//  AnyContinuousScaleTests.swift
//
//
//  Created by Joseph Heck on 4/6/22.
//

@testable import SwiftVizScale
import XCTest

class ContinuousScaleTests: XCTestCase {
    func testAnyContinuousScaleInitializer() throws {
        let cScale = ContinuousScale<Double, CGFloat>(0.0 ... 50.0)

        XCTAssertEqual(cScale.domainLower, 0, accuracy: 0.001)
        XCTAssertEqual(cScale.domainHigher, 50, accuracy: 0.001)
        XCTAssertEqual(cScale.transformType, .none)
        XCTAssertEqual(cScale.scaleType, .linear)
    }

    func testAnyContinuousScaleModifiers() throws {
        let cScale = ContinuousScale<Double, CGFloat>(0.0 ... 50.0)

        XCTAssertEqual(cScale.domainLower, 0, accuracy: 0.001)
        XCTAssertEqual(cScale.domainHigher, 50, accuracy: 0.001)

        XCTAssertNil(cScale.scale(25))
        XCTAssertNil(cScale.invert(25))

        var updated = cScale.domain(lower: -50, higher: 50)
        XCTAssertEqual(updated.domainLower, -50, accuracy: 0.001)
        XCTAssertEqual(updated.domainHigher, 50, accuracy: 0.001)

        updated = cScale.range(lower: 0, higher: 100)
        XCTAssertEqual(updated.scale(10), 20)
        XCTAssertEqual(updated.invert(60), 30)

        updated = cScale.transform(.drop)
        XCTAssertEqual(updated.transformType, .drop)
    }

    func testAnyContinuousScaleMethods() throws {
        let cScale = ContinuousScale<Double, CGFloat>(0.0 ... 50.0)

        XCTAssertEqual(cScale.domainLower, 0, accuracy: 0.001)
        XCTAssertEqual(cScale.domainHigher, 50, accuracy: 0.001)

        XCTAssertEqual(20, cScale.scale(10, from: 0, to: 100))
        XCTAssertEqual(25, cScale.invert(50, from: 0, to: 100))
    }

    func testAnyContinuousScaleConversions() throws {
        let linearScale = ContinuousScale<Double, CGFloat>(1.0 ... 50.0)
        XCTAssertEqual(linearScale.scaleType, .linear)

        let log = linearScale.scaleType(.log)
        XCTAssertEqual(log.scaleType, .log)

        let power = linearScale.scaleType(.power(2))
        XCTAssertEqual(power.scaleType, .power(2))
    }

    func testArrayDomainModifier() {
        let myScale = ContinuousScale<Double, CGFloat>(1.0 ... 50.0)
        XCTAssertEqual(myScale.scaleType, .linear)

        let updated = myScale.domain([0.0, 15.0, 5.0])
        XCTAssertEqual(updated.domainLower, 0.0)
        XCTAssertEqual(updated.domainHigher, 20.0)
    }

    func testArrayDomainModifierWithoutNice() {
        let myScale = ContinuousScale<Double, CGFloat>(1.0 ... 50.0)
        XCTAssertEqual(myScale.scaleType, .linear)

        let updated = myScale.domain([0.0, 15.0, 5.0], nice: false)
        XCTAssertEqual(updated.domainLower, 0.0)
        XCTAssertEqual(updated.domainHigher, 15.0)
    }

    func testScaleType() {
        let anyScale = ContinuousScale<Double, CGFloat>(1.0 ... 50.0)
        XCTAssertEqual(anyScale.scaleType.description, "linear")

        let linearScale = ContinuousScale<Double, CGFloat>(1.0 ... 50.0).transform(.clamp)
        XCTAssertEqual(linearScale.scaleType.description, "linear")

        let logScale = ContinuousScale<Int, CGFloat>(1 ... 100).scaleType(.log).range(lower: 0, higher: 300)
        XCTAssertEqual(logScale.scaleType.description, "log")
    }

    func testScaleDescription() {
        let myScale = ContinuousScale<Double, CGFloat>(1.0 ... 50.0)
        XCTAssertEqual(String(describing: myScale), "linear(xform:none)[1.0:50.0]->[nil:nil]")

        let clampedScale = ContinuousScale<Double, CGFloat>(1.0 ... 50.0).transform(.clamp)
        XCTAssertEqual(String(describing: clampedScale), "linear(xform:clamp)[1.0:50.0]->[nil:nil]")

        let secondScale = ContinuousScale<Int, CGFloat>(1 ... 100).scaleType(.log).range(lower: 0, higher: 300)
        XCTAssertEqual(String(describing: secondScale), "log(xform:none)[1:100]->[Optional(0.0):Optional(300.0)]")
    }
}
