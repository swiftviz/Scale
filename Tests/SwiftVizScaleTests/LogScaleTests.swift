//
//  LogScaleTests.swift
//  SwiftVizTests
//
//  Created by Joseph Heck on 3/3/20.
//

@testable import SwiftVizScale
import XCTest

class LogScaleTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the
        // invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the
        // invocation of each test method in the class.
    }

    func testLogScale_scale() {
        let myScale = LogScale<Double, Float>(from: 1.0, to: 100.0, transform: .none)
        XCTAssertEqual(myScale.transformType, .none)
        let testRange = Float(0) ... Float(100.0)
        guard let scaledValue = myScale.scale(10.0, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail("scaling dropped value")
            return
        }
        XCTAssertEqual(50.0, scaledValue, accuracy: 0.01)
    }

    func testLogScale_invert() {
        let myScale = LogScale<Double, Float>(from: 1.0, to: 100.0, transform: .none)
        XCTAssertEqual(myScale.transformType, .none)
        let testRange = Float(0) ... Float(100.0)
        guard let result = myScale.invert(50.0, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail("invert dropped value")
            return
        }
        XCTAssertEqual(10, result, accuracy: 0.01)
    }

    func testLogScale_Intscale() {
        let myScale = LogScale<Int, Float>(from: 1, to: 100, transform: .none)
        XCTAssertEqual(myScale.transformType, .none)
        let testRange = Float(0) ... Float(100.0)
        guard let scaledValue = myScale.scale(10, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail("scaling dropped value")
            return
        }
        XCTAssertEqual(50.0, scaledValue, accuracy: 0.01)
    }

    func testLogScale_Intinvert() {
        let myScale = LogScale<Int, Float>(from: 1, to: 100, transform: .none)
        XCTAssertEqual(myScale.transformType, .none)
        let testRange = Float(0) ... Float(100.0)
        guard let result = myScale.invert(50.0, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail("invert dropped value")
            return
        }
        XCTAssertEqual(10, result)
    }

    func testLogScale_RangeInitializaer() {
        let myScale = LogScale<Double, CGFloat>(1 ... 100, transform: .none)
        XCTAssertEqual(myScale.transformType, .none)
        let testRange = Double(0) ... Double(100.0)
        guard let result = myScale.invert(50.0, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail("invert dropped value")
            return
        }
        XCTAssertEqual(10, result)
    }

    func testLogScaleTicks() {
        let myScale = LogScale<Double, Float>(from: 0.01, to: 100.0, transform: .none)
        XCTAssertEqual(myScale.transformType, .none)

        let testRange = Float(0.0) ... Float(100.0)

        let defaultTicks = myScale.ticks(rangeLower: testRange.lowerBound, rangeHigher: testRange.upperBound)
        // print(defaultTicks.map { $0.value })
        XCTAssertEqual(defaultTicks.count, 5)
        for tick in defaultTicks {
            // every tick should be from within the scale's range (output area)
            print(tick)
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(myScale.domainLower <= tick.value!)
            XCTAssertTrue(myScale.domainHigher >= tick.value!)
        }
    }

    func testLogScaleManualTicks() {
        let myScale = LogScale<Double, Float>(from: 0.01, to: 100.0, transform: .none)
        XCTAssertEqual(myScale.transformType, .none)

        let testRange = Float(0) ... Float(100.0)

        let manualTicks = myScale.ticksFromValues([0.1, 1, 10], from: testRange.lowerBound, to: testRange.upperBound)

        XCTAssertEqual(manualTicks.count, 3)
        for tick in manualTicks {
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(myScale.domainLower <= tick.value!)
            XCTAssertTrue(myScale.domainHigher >= tick.value!)
        }
    }

    func testLogScaleTicksWeirdDomain() {
        let myScale = LogScale<Double, Float>(from: 0.8, to: 999.0, transform: .none)
        XCTAssertEqual(myScale.transformType, .none)

        let testRange = Float(0.0) ... Float(100.0)

        let defaultTicks = myScale.ticks(rangeLower: testRange.lowerBound, rangeHigher: testRange.upperBound)
        // print(defaultTicks.map { $0.value })
        XCTAssertEqual(defaultTicks.count, 4)
        for tick in defaultTicks {
            print(tick)
            // every tick should be from within the scale's range (output area)
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(myScale.domainLower <= tick.value!)
            XCTAssertTrue(myScale.domainHigher >= tick.value!)
        }
    }

    func testLogScaleTicksOutsideDomain() {
        let myScale = LogScale<Double, Float>(from: 10.0, to: 1000.0, transform: .none)
        XCTAssertEqual(myScale.transformType, .none)

        let testRange = Float(0.0) ... Float(100.0)

        let manualTicks = myScale.ticksFromValues([0.1, 1, 10, 100, 1000], from: testRange.lowerBound, to: testRange.upperBound)

        XCTAssertEqual(manualTicks.count, 3)
        for tick in manualTicks {
            // every tick should be from within the scale's range (output area)
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(myScale.domainLower <= tick.value!)
            XCTAssertTrue(myScale.domainHigher >= tick.value!)
        }
    }

    func testLogScaleClamp() {
        let scale = LogScale<Double, Float>(from: 1.0, to: 100.0)
        let clampedScale = LogScale<Double, Float>(from: 1.0, to: 100.0, transform: .clamp)

        XCTAssertEqual(scale.transformType, .none)
        XCTAssertEqual(clampedScale.transformType, .clamp)
        let testRange = Float(0) ... Float(100.0)

        // no clamp effect
        XCTAssertEqual(scale.scale(10, from: testRange.lowerBound, to: testRange.upperBound), 50)
        XCTAssertEqual(clampedScale.scale(10, from: testRange.lowerBound, to: testRange.upperBound), 50)

        // clamp constrained high
        guard let scaledValue = scale.scale(1000, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(scaledValue, 150, accuracy: 0.001)
        guard let clampedScaledValue = clampedScale.scale(1000, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(clampedScaledValue, 100, accuracy: 0.001)

        // clamp constrained low
        XCTAssertEqual(scale.scale(0.1, from: testRange.lowerBound, to: testRange.upperBound), -50)
        XCTAssertEqual(clampedScale.scale(0.1, from: testRange.lowerBound, to: testRange.upperBound), 0)
    }

    func testLogInvertClamp() {
        let scale = LogScale<Double, Float>(from: 1.0, to: 100.0)
        let clampedScale = LogScale<Double, Float>(from: 1.0, to: 100.0, transform: .clamp)

        XCTAssertEqual(scale.transformType, .none)
        XCTAssertEqual(clampedScale.transformType, .clamp)
        let testRange = Float(0) ... Float(100.0)

        // no clamp effect
        XCTAssertEqual(scale.invert(50, from: testRange.lowerBound, to: testRange.upperBound), 10)
        XCTAssertEqual(clampedScale.invert(50, from: testRange.lowerBound, to: testRange.upperBound), 10)

        // clamp constrained high
        guard let scaledValue = scale.invert(150, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(scaledValue, 1000, accuracy: 0.001)
        guard let clampedScaleValue = clampedScale.invert(150, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(clampedScaleValue, 100, accuracy: 0.001)

        // clamp constrained low
        XCTAssertEqual(scale.invert(-50, from: testRange.lowerBound, to: testRange.upperBound), 0.1)
        XCTAssertEqual(clampedScale.invert(-50, from: testRange.lowerBound, to: testRange.upperBound), 1.0)
    }

    func testDomainModifier() {
        let scale = LogScale<Double, Float>()
        XCTAssertEqual(1, scale.domainLower)
        XCTAssertEqual(10, scale.domainHigher)
        XCTAssertNil(scale.rangeLower)
        XCTAssertNil(scale.rangeHigher)

        let updated = scale.domain(lower: 10, higher: 100)
        XCTAssertEqual(10, updated.domainLower)
        XCTAssertEqual(100, updated.domainHigher)
    }

    func testDomain2Modifier() {
        let scale = LogScale<Double, Float>()
        XCTAssertEqual(1, scale.domainLower)
        XCTAssertEqual(10, scale.domainHigher)
        XCTAssertNil(scale.rangeLower)
        XCTAssertNil(scale.rangeHigher)

        let updated = scale.domain(10 ... 100)
        XCTAssertEqual(10, updated.domainLower)
        XCTAssertEqual(100, updated.domainHigher)
    }

    func testRangeModifier() {
        let scale = LogScale<Double, Float>()
        XCTAssertNil(scale.rangeLower)
        XCTAssertNil(scale.rangeHigher)

        let updated = scale.range(10 ... 100)
        XCTAssertEqual(10, updated.rangeLower)
        XCTAssertEqual(100, updated.rangeHigher)
        XCTAssertTrue(updated.fullyConfigured())
    }

    func testRange2Modifier() {
        let scale = LogScale<Double, Float>()
        XCTAssertNil(scale.rangeLower)
        XCTAssertNil(scale.rangeHigher)

        let updated = scale.range(lower: 10, higher: 100)
        XCTAssertEqual(10, updated.rangeLower)
        XCTAssertEqual(100, updated.rangeHigher)
        XCTAssertTrue(updated.fullyConfigured())
    }

    func testTransformModifier() {
        let scale = LogScale<Double, Float>()
        XCTAssertEqual(scale.transformType, DomainDataTransform.none)

        let updated = scale.transform(.clamp)
        XCTAssertEqual(updated.transformType, DomainDataTransform.clamp)
    }

    func testArrayDomainModifier() {
        let myScale = LogScale<Double, Float>(from: 1.0, to: 10.0)
        XCTAssertEqual(myScale.transformType, .none)

        let updated = myScale.domain([1.0, 15.0, 5.0])
        XCTAssertEqual(updated.domainLower, Double.leastNonzeroMagnitude)
        XCTAssertEqual(updated.domainHigher, 20.0)
    }

    func testArrayDomainModifierWithoutNice() {
        let myScale = LogScale<Double, Float>(from: 1.0, to: 10.0)
        XCTAssertEqual(myScale.transformType, .none)

        let updated = myScale.domain([10.0, 15.0, 51.0])
        XCTAssertEqual(updated.domainLower, Double.leastNonzeroMagnitude)
        XCTAssertEqual(updated.domainHigher, 100.0)
    }

    func testScaleDomainOfOneValue() {
        let scale = LogScale<Double, CGFloat>()

        let updated = scale.domain([5.0])
        XCTAssertEqual(updated.domainLower, Double.leastNonzeroMagnitude)
        XCTAssertEqual(updated.domainHigher, 5)
    }

    func testScaleDomainOfOneValueNiced() {
        let scale = LogScale<Double, CGFloat>()

        let updated = scale.domain([5.0], nice: true)
        XCTAssertEqual(updated.domainLower, Double.leastNonzeroMagnitude)
        XCTAssertEqual(updated.domainHigher, 5)
    }

    func testReversedRangeModifiers() {
        var scale = LogScale<Double, CGFloat>(1 ... 100).range(1 ... 100)
        XCTAssertEqual(scale.reversed, false)
        scale = LogScale(from: 1, to: 100, reversed: true, rangeLower: 1, rangeHigher: 100)
        XCTAssertEqual(scale.reversed, true)
        scale = scale.range(0 ... 40)
        XCTAssertEqual(scale.reversed, true)
        scale = scale.range(reversed: false, 0 ... 40)
        XCTAssertEqual(scale.reversed, false)
    }

    func testReversedCalculations() {
        let scale = LogScale<Double, CGFloat>(from: 1, to: 100, reversed: true, rangeLower: 1, rangeHigher: 100)
        XCTAssertEqual(scale.scale(1), 100)
        XCTAssertEqual(scale.scale(100), 1)
        XCTAssertEqual(scale.scale(10), 50.5)
        // verify invert
        XCTAssertEqual(scale.invert(50.5), 10)

        let forward = scale.range(reversed: false, lower: 1, higher: 100) // log identity
        XCTAssertEqual(forward.scale(1), 1)
        XCTAssertEqual(forward.scale(100), 100)
        XCTAssertEqual(forward.scale(10), 50.5)
        // verify invert
        XCTAssertEqual(forward.invert(50.5), 10)
    }

    func testReversedTicks() {
        let reversed = LogScale<Double, CGFloat>(from: 1, to: 100, reversed: true, rangeLower: 1, rangeHigher: 100)
        let reverseTicks = reversed.ticks(rangeLower: 0, rangeHigher: 20)
        XCTAssertEqual(reverseTicks.count, 5)
        print(reverseTicks)
//        [SwiftVizScale.Tick<CoreGraphics.CGFloat>(rangeLocation: 6.9897000433601875, label: "20.0"), SwiftVizScale.Tick<CoreGraphics.CGFloat>(rangeLocation: 3.979400086720377, label: "40.0"), SwiftVizScale.Tick<CoreGraphics.CGFloat>(rangeLocation: 2.2184874961635637, label: "60.0"), SwiftVizScale.Tick<CoreGraphics.CGFloat>(rangeLocation: 0.9691001300805646, label: "80.0"), SwiftVizScale.Tick<CoreGraphics.CGFloat>(rangeLocation: 0.0, label: "100.0")]

        assertTick(reverseTicks[0], "20.0", 6.9897)
        assertTick(reverseTicks[1], "40.0", 3.9794)
        assertTick(reverseTicks[2], "60.0", 2.2185)
        assertTick(reverseTicks[3], "80.0", 0.9691)
        assertTick(reverseTicks[4], "100.0", 0.0)

        let forward = reversed.range(reversed: false, lower: 0, higher: 20) // identity
        let forwardTicks = forward.ticks(rangeLower: 0, rangeHigher: 20)
        XCTAssertEqual(forwardTicks.count, 5)
        assertTick(forwardTicks[0], "20.0", 13.010)
        assertTick(forwardTicks[1], "40.0", 16.020)
        assertTick(forwardTicks[2], "60.0", 17.781)
        assertTick(forwardTicks[3], "80.0", 19.030)
        assertTick(forwardTicks[4], "100.0", 20)
    }
}
