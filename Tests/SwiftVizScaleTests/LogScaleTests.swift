//
//  LogScaleTests.swift
//  SwiftVizTests
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
        let myScale = ContinuousScale<Float>(lower: 1.0, higher: 100.0, type: .log, transform: .none)
        XCTAssertEqual(myScale.transformType, .none)
        let testRange = Float(0) ... Float(100.0)
        guard let scaledValue = myScale.scale(10.0, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail("scaling dropped value")
            return
        }
        XCTAssertEqual(50.0, scaledValue, accuracy: 0.01)
    }

    func testLogScale_invert() {
        let myScale = ContinuousScale<Float>(lower: 1.0, higher: 100.0, type: .log, transform: .none)
        XCTAssertEqual(myScale.transformType, .none)
        let testRange = Float(0) ... Float(100.0)
        guard let result = myScale.invert(50.0, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail("invert dropped value")
            return
        }
        XCTAssertEqual(10, result, accuracy: 0.01)
    }

    func testLogScale_Intscale() {
        let myScale = ContinuousScale<Float>(lower: 1, higher: 100, type: .log, transform: .none)
        XCTAssertEqual(myScale.transformType, .none)
        let testRange = Float(0) ... Float(100.0)
        guard let scaledValue = myScale.scale(10, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail("scaling dropped value")
            return
        }
        XCTAssertEqual(50.0, scaledValue, accuracy: 0.01)
    }

    func testLogScale_Intinvert() {
        let myScale = ContinuousScale<Float>(lower: 1, higher: 100, type: .log, transform: .none)
        XCTAssertEqual(myScale.transformType, .none)
        let testRange = Float(0) ... Float(100.0)
        guard let result = myScale.invert(50.0, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail("invert dropped value")
            return
        }
        XCTAssertEqual(10, result)
    }

    func testLogScale_RangeInitializaer() {
        let myScale = ContinuousScale<CGFloat>(1 ... 100, type: .log, transform: .none)
        XCTAssertEqual(myScale.transformType, .none)
        let testRange = Double(0) ... Double(100.0)
        guard let result = myScale.invert(50.0, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail("invert dropped value")
            return
        }
        XCTAssertEqual(10, result)
    }

    func testLogScaleTicks() {
        let myScale = ContinuousScale<Float>(lower: 0.01, higher: 100.0, type: .log, transform: .none)
        XCTAssertEqual(myScale.transformType, .none)

        let testRange = Float(0.0) ... Float(100.0)

        let defaultTicks = myScale.ticks(rangeLower: testRange.lowerBound, rangeHigher: testRange.upperBound)
        // print(defaultTicks.map(\.value))
        XCTAssertEqual(defaultTicks.count, 12)
        for tick in defaultTicks {
            // every tick should be from within the scale's range (output area)
            // print(tick)
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(myScale.domainLower <= tick.value!)
            XCTAssertTrue(myScale.domainHigher >= tick.value!)
        }
    }

    func testLogScaleManualTicks() {
        let myScale = ContinuousScale<Float>(lower: 0.01, higher: 100.0, type: .log, transform: .none)
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
        let myScale = ContinuousScale<Float>(lower: 0.8, higher: 999.0, type: .log, transform: .none)
        XCTAssertEqual(myScale.transformType, .none)

        let testRange = Float(0.0) ... Float(100.0)

        let defaultTicks = myScale.ticks(rangeLower: testRange.lowerBound, rangeHigher: testRange.upperBound)
        // print(defaultTicks.map(\.value))
        XCTAssertEqual(defaultTicks.count, 9)
        for tick in defaultTicks {
            // print(tick)
            // every tick should be from within the scale's range (output area)
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(myScale.domainLower <= tick.value!)
            XCTAssertTrue(myScale.domainHigher >= tick.value!)
        }
    }

    func testLogScaleTicksOutsideDomain() {
        let myScale = ContinuousScale<Float>(lower: 10.0, higher: 1000.0, type: .log, transform: .none)
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
        let scale = ContinuousScale<Float>(lower: 1.0, higher: 100.0, type: .log)
        let clampedScale = ContinuousScale<Float>(lower: 1.0, higher: 100.0, type: .log, transform: .clamp)

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
        let scale = ContinuousScale<Float>(lower: 1.0, higher: 100.0, type: .log)
        let clampedScale = ContinuousScale<Float>(lower: 1.0, higher: 100.0, type: .log, transform: .clamp)

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

    func testScaleDomainOfOneValue() {
        let scale = ContinuousScale<CGFloat>(type: .log)

        let updated = scale.domain([5.0])
        XCTAssertEqual(updated.domainLower, Double.leastNonzeroMagnitude)
        XCTAssertEqual(updated.domainHigher, 5)
    }

    func testScaleDomainOfOneValueNiced() {
        let scale = ContinuousScale<CGFloat>(type: .log)

        let updated = scale.domain([5.0], nice: true)
        XCTAssertEqual(updated.domainLower, Double.leastNonzeroMagnitude)
        XCTAssertEqual(updated.domainHigher, 5)
    }

    func testReversedRangeModifiers() {
        var scale = ContinuousScale<CGFloat>(1 ... 100, type: .log).range(1 ... 100)
        XCTAssertEqual(scale.reversed, false)
        scale = ContinuousScale(lower: 1, higher: 100, type: .log, reversed: true, rangeLower: 1, rangeHigher: 100)
        XCTAssertEqual(scale.reversed, true)
        scale = scale.range(0 ... 40)
        XCTAssertEqual(scale.reversed, true)
        scale = scale.range(reversed: false, 0 ... 40)
        XCTAssertEqual(scale.reversed, false)
    }

    func testReversedCalculations() {
        let scale = ContinuousScale<CGFloat>(lower: 1, higher: 100, type: .log, reversed: true, rangeLower: 1, rangeHigher: 100)
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
        let reversed = ContinuousScale<CGFloat>(lower: 1, higher: 100, type: .log, reversed: true, rangeLower: 1, rangeHigher: 100)
        let reverseTicks = reversed.ticks(rangeLower: 0, rangeHigher: 20)
        XCTAssertEqual(reverseTicks.count, 6)
        assertTick(reverseTicks[0], "1.0", 20.0)
        assertTick(reverseTicks[1], "2.0", 16.989)
        assertTick(reverseTicks[2], "5.0", 13.01)
        assertTick(reverseTicks[3], "10.0", 10.0)
        assertTick(reverseTicks[4], "20.0", 6.989)
        assertTick(reverseTicks[5], "50.0", 3.010)

        let forward = reversed.range(reversed: false, lower: 0, higher: 20) // identity
        let forwardTicks = forward.ticks(rangeLower: 0, rangeHigher: 20)
        XCTAssertEqual(forwardTicks.count, 6)
        assertTick(forwardTicks[0], "1.0", 0)
        assertTick(forwardTicks[1], "2.0", 3.010)
        assertTick(forwardTicks[2], "5.0", 6.989)
        assertTick(forwardTicks[3], "10.0", 10)
        assertTick(forwardTicks[4], "20.0", 13.01)
        assertTick(forwardTicks[5], "50.0", 16.989)
    }
}
