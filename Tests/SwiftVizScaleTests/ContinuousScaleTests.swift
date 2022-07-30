//
//  ContinuousScaleTests.swift
//

@testable import SwiftVizScale
import XCTest

class ContinuousScaleTests: XCTestCase {
    func testAnyContinuousScaleInitializer() throws {
        let cScale = ContinuousScale<CGFloat>(0.0 ... 50.0)

        XCTAssertEqual(cScale.domainLower, 0, accuracy: 0.001)
        XCTAssertEqual(cScale.domainHigher, 50, accuracy: 0.001)
        XCTAssertEqual(cScale.transformType, .none)
        XCTAssertEqual(cScale.scaleType, .linear)
    }

    func testAnyContinuousScaleModifiers() throws {
        let cScale = ContinuousScale<CGFloat>(0.0 ... 50.0)

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
        let cScale = ContinuousScale<CGFloat>(0.0 ... 50.0)

        XCTAssertEqual(cScale.domainLower, 0, accuracy: 0.001)
        XCTAssertEqual(cScale.domainHigher, 50, accuracy: 0.001)

        XCTAssertEqual(20, cScale.scale(10, from: 0, to: 100))
        XCTAssertEqual(25, cScale.invert(50, from: 0, to: 100))
    }

    func testAnyContinuousScaleConversions() throws {
        let linearScale = ContinuousScale<CGFloat>(1.0 ... 50.0)
        XCTAssertEqual(linearScale.scaleType, .linear)

        let log = linearScale.scaleType(.log)
        XCTAssertEqual(log.scaleType, .log)

        let power = linearScale.scaleType(.power(2))
        XCTAssertEqual(power.scaleType, .power(2))
    }

    func testArrayDomainModifier() {
        let myScale = ContinuousScale<CGFloat>(1.0 ... 50.0)
        XCTAssertEqual(myScale.scaleType, .linear)

        let updated = myScale.domain([0.0, 15.0, 5.0])
        XCTAssertEqual(updated.domainLower, 0.0)
        XCTAssertEqual(updated.domainHigher, 20.0)
    }

    func testArrayDomainModifierWithoutNice() {
        let myScale = ContinuousScale<CGFloat>(1.0 ... 50.0)
        XCTAssertEqual(myScale.scaleType, .linear)

        let updated = myScale.domain([0.0, 15.0, 5.0], nice: false)
        XCTAssertEqual(updated.domainLower, 0.0)
        XCTAssertEqual(updated.domainHigher, 15.0)
    }

    func testScaleType() {
        let anyScale = ContinuousScale<CGFloat>(1.0 ... 50.0)
        XCTAssertEqual(anyScale.scaleType.description, "linear")

        let linearScale = ContinuousScale<CGFloat>(1.0 ... 50.0).transform(.clamp)
        XCTAssertEqual(linearScale.scaleType.description, "linear")

        let logScale = ContinuousScale<CGFloat>(1 ... 100).scaleType(.log).range(lower: 0, higher: 300)
        XCTAssertEqual(logScale.scaleType.description, "log")
    }

    func testScaleDescription() {
        let myScale = ContinuousScale<CGFloat>(1.0 ... 50.0)

        XCTAssertEqual(String(describing: myScale), "linear(xform:none)[1.0:50.0]->[nil:nil]")

        let clampedScale = ContinuousScale<CGFloat>(1.0 ... 50.0).transform(.clamp)
        XCTAssertEqual(String(describing: clampedScale), "linear(xform:clamp)[1.0:50.0]->[nil:nil]")

        let secondScale = ContinuousScale<CGFloat>(1 ... 100, type: .log).range(lower: 0, higher: 300)
        XCTAssertEqual(String(describing: secondScale), "log(xform:none)[1.0:100.0]->[Optional(0.0):Optional(300.0)]")
    }

    func testScaleExampleValues() {
        // this is coming out as -18.503, which is VERY wrong...
        // incoming value example: stddev    NSTimeInterval    0.00062460815272012726
        // range to process that within: 1 ... 367
        // resulting value SHOULD be between those - not negative!
        let incoming = TimeInterval(0.00062460815272012726)
        let outputRange = CGFloat(1) ... CGFloat(367)
        // domain appears to be 0..0 in my example where this is failing
        let scale = ContinuousScale<CGFloat>(lower: 0.003, higher: 0.056)
        guard let result = scale.scale(incoming + 0.003, from: CGFloat(1.0), to: CGFloat(367.0)) else {
            XCTFail()
            return
        }
        XCTAssertTrue(outputRange.contains(result))
    }

    func testDoubleLinearScaleTicks() {
        let myScale = ContinuousScale<Float>(lower: 0.0, higher: 1.0)
        XCTAssertEqual(myScale.transformType, .none)

        let testRange = Float(0) ... Float(100.0)
        let defaultTicks = myScale.ticks(rangeLower: testRange.lowerBound, rangeHigher: testRange.upperBound)
        XCTAssertEqual(defaultTicks.count, 6)
        for tick in defaultTicks {
            print(tick)
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(tick.value! >= myScale.domainLower)
            XCTAssertTrue(tick.value! <= myScale.domainHigher)
        }
    }

    func testDoubleLinearScaleManualTicks() {
        let myScale = ContinuousScale<Float>(lower: 0.0, higher: 10.0)
        XCTAssertEqual(myScale.transformType, .none)

        let testRange = Float(0) ... Float(100.0)
        let manualTicks = myScale.ticksFromValues([0.1, 0.5], from: testRange.lowerBound, to: testRange.upperBound)

        XCTAssertEqual(manualTicks.count, 2)
        for tick in manualTicks {
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(tick.value! >= myScale.domainLower)
            XCTAssertTrue(tick.value! <= myScale.domainHigher)
        }
    }

    func testDoubleLinearScaleClamp() {
        let scale = ContinuousScale<Float>(lower: 0.0, higher: 10.0)
        let clampedScale = ContinuousScale<Float>(lower: 0.0, higher: 10.0, transform: .clamp)
        let dropScale = ContinuousScale<Float>(lower: 0, higher: 10, transform: .drop)
        XCTAssertEqual(scale.transformType, .none)
        XCTAssertEqual(clampedScale.transformType, .clamp)
        XCTAssertEqual(dropScale.transformType, .drop)
        let testRange = Float(0) ... Float(100.0)

        // no clamp effect
        XCTAssertEqual(scale.scale(5, from: testRange.lowerBound, to: testRange.upperBound), 50)
        XCTAssertEqual(clampedScale.scale(5, from: testRange.lowerBound, to: testRange.upperBound), 50)

        // clamp constrained high
        guard let scaledValue = scale.scale(11, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(scaledValue, 110, accuracy: 0.001)
        guard let clampedScaleValue = clampedScale.scale(11, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(clampedScaleValue, 100, accuracy: 0.001)
        XCTAssertNil(dropScale.scale(110, from: testRange.lowerBound, to: testRange.upperBound))

        // clamp constrained low
        XCTAssertEqual(scale.scale(-1, from: testRange.lowerBound, to: testRange.upperBound), -10)
        XCTAssertEqual(clampedScale.scale(-1, from: testRange.lowerBound, to: testRange.upperBound), 0)
        XCTAssertNil(dropScale.scale(-1, from: testRange.lowerBound, to: testRange.upperBound))
    }

    func testIntLinearScaleClamp() {
        let scale = ContinuousScale<Float>(lower: 0, higher: 10)
        let clampedScale = ContinuousScale<Float>(lower: 0, higher: 10, transform: .clamp)
        let dropScale = ContinuousScale<Float>(lower: 0, higher: 10, transform: .drop)

        XCTAssertEqual(scale.transformType, .none)
        XCTAssertEqual(clampedScale.transformType, .clamp)
        XCTAssertEqual(dropScale.transformType, .drop)

        let testRange = Float(0) ... Float(100.0)

        // no clamp effect
        XCTAssertEqual(scale.scale(5, from: testRange.lowerBound, to: testRange.upperBound), 50)
        XCTAssertEqual(clampedScale.scale(5, from: testRange.lowerBound, to: testRange.upperBound), 50)

        // clamp constrained high
        guard let scaledValue = scale.scale(11, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(scaledValue, 110, accuracy: 0.001)
        guard let clampedScaleValue = clampedScale.scale(11, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(clampedScaleValue, 100, accuracy: 0.001)
        XCTAssertNil(dropScale.scale(110, from: testRange.lowerBound, to: testRange.upperBound))

        // clamp constrained low
        XCTAssertEqual(scale.scale(-1, from: testRange.lowerBound, to: testRange.upperBound), -10)
        XCTAssertEqual(clampedScale.scale(-1, from: testRange.lowerBound, to: testRange.upperBound), 0)
        XCTAssertNil(dropScale.scale(-1, from: testRange.lowerBound, to: testRange.upperBound))
    }

    func testDoubleLinearInvertClamp() {
        let scale = ContinuousScale<Float>(lower: 0.0, higher: 10.0)
        let clampedScale = ContinuousScale<Float>(lower: 0.0, higher: 10.0, transform: .clamp)
        let dropScale = ContinuousScale<Float>(lower: 0, higher: 10, transform: .drop)
        XCTAssertEqual(scale.transformType, .none)
        XCTAssertEqual(clampedScale.transformType, .clamp)
        XCTAssertEqual(dropScale.transformType, .drop)
        let testRange = Float(0) ... Float(100.0)

        // no clamp effect
        XCTAssertEqual(scale.invert(50, from: testRange.lowerBound, to: testRange.upperBound), 5)
        XCTAssertEqual(clampedScale.invert(50, from: testRange.lowerBound, to: testRange.upperBound), 5)

        // clamp constrained high
        guard let invertedValue = scale.invert(110, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(invertedValue, 11, accuracy: 0.001)
        guard let invertedClampedValue = clampedScale.invert(110, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(invertedClampedValue, 10, accuracy: 0.001)
        XCTAssertNil(dropScale.invert(110, from: testRange.lowerBound, to: testRange.upperBound))

        // clamp constrained low
        XCTAssertEqual(scale.invert(-10, from: testRange.lowerBound, to: testRange.upperBound), -1)
        XCTAssertEqual(clampedScale.invert(-10, from: testRange.lowerBound, to: testRange.upperBound), 0)
        XCTAssertNil(dropScale.invert(-10, from: testRange.lowerBound, to: testRange.upperBound))
    }

    func testIntLinearInvertClamp() {
        let scale = ContinuousScale<Float>(lower: 0, higher: 10)
        let clampedScale = ContinuousScale<Float>(lower: 0, higher: 10, transform: .clamp)
        let dropScale = ContinuousScale<Float>(lower: 0, higher: 10, transform: .drop)
        XCTAssertEqual(scale.transformType, .none)
        XCTAssertEqual(clampedScale.transformType, .clamp)
        XCTAssertEqual(dropScale.transformType, .drop)
        let testRange = Float(0) ... Float(100.0)

        // no clamp effect
        XCTAssertEqual(scale.invert(50, from: testRange.lowerBound, to: testRange.upperBound), 5)
        XCTAssertEqual(clampedScale.invert(50, from: testRange.lowerBound, to: testRange.upperBound), 5)

        // clamp constrained high
        guard let invertedValue = scale.invert(110, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(invertedValue, 11)
        guard let invertedClampedValue = clampedScale.invert(110, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(invertedClampedValue, 10)
        XCTAssertNil(dropScale.invert(110, from: testRange.lowerBound, to: testRange.upperBound))

        // clamp constrained low
        XCTAssertEqual(scale.invert(-10, from: testRange.lowerBound, to: testRange.upperBound), -1)
        XCTAssertEqual(clampedScale.invert(-10, from: testRange.lowerBound, to: testRange.upperBound), 0)
        XCTAssertNil(dropScale.invert(-10, from: testRange.lowerBound, to: testRange.upperBound))
    }

    func testLinearScaleDomainModifier() {
        let scale = ContinuousScale<Float>()
        XCTAssertEqual(0, scale.domainLower)
        XCTAssertEqual(1, scale.domainHigher)
        XCTAssertNil(scale.rangeLower)
        XCTAssertNil(scale.rangeHigher)

        let updated = scale.domain(lower: 10, higher: 100)
        XCTAssertEqual(10, updated.domainLower)
        XCTAssertEqual(100, updated.domainHigher)
    }

    func testLinearScaleDomain2Modifier() {
        let scale = ContinuousScale<Float>()
        XCTAssertEqual(0, scale.domainLower)
        XCTAssertEqual(1, scale.domainHigher)
        XCTAssertNil(scale.rangeLower)
        XCTAssertNil(scale.rangeHigher)

        let updated = scale.domain(10 ... 100)
        XCTAssertEqual(10, updated.domainLower)
        XCTAssertEqual(100, updated.domainHigher)
    }

    func testLinearScaleRangeModifier() {
        let scale = ContinuousScale<Float>()
        XCTAssertEqual(0, scale.domainLower)
        XCTAssertEqual(1, scale.domainHigher)
        XCTAssertNil(scale.rangeLower)
        XCTAssertNil(scale.rangeHigher)

        let updated = scale.range(10 ... 100)
        XCTAssertEqual(10, updated.rangeLower)
        XCTAssertEqual(100, updated.rangeHigher)
        XCTAssertTrue(updated.fullyConfigured())
    }

    func testLinearScaleRange2Modifier() {
        let scale = ContinuousScale<Float>()
        XCTAssertEqual(0, scale.domainLower)
        XCTAssertEqual(1, scale.domainHigher)
        XCTAssertNil(scale.rangeLower)
        XCTAssertNil(scale.rangeHigher)

        let updated = scale.range(lower: 10, higher: 100)
        XCTAssertEqual(10, updated.rangeLower)
        XCTAssertEqual(100, updated.rangeHigher)
        XCTAssertTrue(updated.fullyConfigured())
    }

    func testLinearScaleTransformModifier() {
        let scale = ContinuousScale<Float>()
        XCTAssertEqual(scale.transformType, DomainDataTransform.none)

        let updated = scale.transform(.clamp)
        XCTAssertEqual(updated.transformType, DomainDataTransform.clamp)
    }

    func testScaleDomainOfOneValue() {
        let scale = ContinuousScale<CGFloat>()

        let updated = scale.domain([5.0])
        XCTAssertEqual(updated.domainLower, 0)
        XCTAssertEqual(updated.domainHigher, 5)
    }

    func testScaleDomainOfOneValueNiced() {
        let scale = ContinuousScale<CGFloat>()

        let updated = scale.domain([5.0], nice: true)
        XCTAssertEqual(updated.domainLower, 0)
        XCTAssertEqual(updated.domainHigher, 5)
    }

    func testReversedRangeModifiers() {
        var scale = ContinuousScale<CGFloat>(0 ... 20).range(0 ... 20)
        XCTAssertEqual(scale.reversed, false)
        scale = ContinuousScale(20, transform: .none, desiredTicks: 10, reversed: true, rangeLower: 0, rangeHigher: 20)
        XCTAssertEqual(scale.reversed, true)
        scale = scale.range(0 ... 40)
        XCTAssertEqual(scale.reversed, true)
        scale = scale.range(reversed: false, 0 ... 40)
        XCTAssertEqual(scale.reversed, false)
    }

    func testReversedCalculations() {
        let scale = ContinuousScale<CGFloat>(20, reversed: true, rangeLower: 0, rangeHigher: 20)
        XCTAssertEqual(scale.scale(0), 20)
        XCTAssertEqual(scale.scale(20), 0)
        XCTAssertEqual(scale.scale(5), 15)
        // verify invert
        XCTAssertEqual(scale.invert(15), 5)

        let forward = scale.range(reversed: false, lower: 0, higher: 20) // identity
        XCTAssertEqual(forward.scale(0), 0)
        XCTAssertEqual(forward.scale(20), 20)
        XCTAssertEqual(forward.scale(5), 5)
        // verify invert
        XCTAssertEqual(forward.invert(5), 5)
    }

    func testReversedTicks() {
        let reversed = ContinuousScale<CGFloat>(20, reversed: true, rangeLower: 0, rangeHigher: 20)
        let reverseTicks = reversed.ticks(rangeLower: 0, rangeHigher: 20)
        XCTAssertEqual(reverseTicks.count, 5)
        assertTick(reverseTicks[0], "0.0", 20)
        assertTick(reverseTicks[1], "5.0", 15)
        assertTick(reverseTicks[2], "10.0", 10)
        assertTick(reverseTicks[3], "15.0", 5)
        assertTick(reverseTicks[4], "20.0", 0)

        let forward = reversed.range(reversed: false, lower: 0, higher: 20) // identity
        let forwardTicks = forward.ticks(rangeLower: 0, rangeHigher: 20)
        XCTAssertEqual(forwardTicks.count, 5)
        assertTick(forwardTicks[0], "0.0", 0)
        assertTick(forwardTicks[1], "5.0", 5)
        assertTick(forwardTicks[2], "10.0", 10)
        assertTick(forwardTicks[3], "15.0", 15)
        assertTick(forwardTicks[4], "20.0", 20)
    }

    func testDomainCalculations() throws {
        let sampleData: [Double] = [59.5, 59.5, 59.0, 59.4, 58.3, 62.1, 60.8, 61.0, 62.4, 65.3,
                                    70.3, 82.2, 75.6, 75.7, 68.4, 56.3, 54.3, 54.9, 54.7, 56.5,
                                    62.6, 59.9, 62.2, 63.0, 58.5, 59.5, 59.4, 66.6, 64.9, 59.9, 60.4, 64.4,
                                    66.6, 67.8, 73.2, 72.1, 59.0, 59.2, 57.4, 56.8, 59.4, 61.2, 59.2, 63.1, 72.1,
                                    75.4, 65.5, 60.1, 55.0, 55.0, 54.3, 54.1, 54.5, 53.4, 49.6, 49.8,
                                    50.9, 52.5, 50.5, 51.3, 51.8, 52.2, 53.4, 53.2, 55.2, 56.3, 59.5, 57.2, 54.5,
                                    56.5, 57.9, 56.1, 55.6, 55.8, 57.4, 52.9, 52.2,
                                    52.2, 57.6, 57.6, 53.4, 57.2, 57.6, 53.6, 57.9, 57.6, 56.7, 56.3, 53.6,
                                    55.6, 50.4, 50.2, 48.2, 48.0, 51.3, 50.9, 52.3, 52.5, 45.1, 43.2, 44.6]
        let baseScale = ContinuousScale<CGFloat>()
        let updatedScale = baseScale.domain(sampleData, nice: true)
        XCTAssertEqual(updatedScale.domainLower, 0)
        XCTAssertEqual(updatedScale.domainHigher, 100)
    }
}
