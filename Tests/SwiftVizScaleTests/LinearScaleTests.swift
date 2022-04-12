//
//  LinearScaleTests.swift

@testable import SwiftVizScale
import XCTest

final class LinearScaleTests: XCTestCase {
    func testScaleExampleValues() {
        // this is coming out as -18.503, which is VERY wrong...
        // incoming value example: stddev    NSTimeInterval    0.00062460815272012726
        // range to process that within: 1 ... 367
        // resulting value SHOULD be between those - not negative!
        let incoming = TimeInterval(0.00062460815272012726)
        let outputRange = CGFloat(1) ... CGFloat(367)
        // domain appears to be 0..0 in my example where this is failing
        let scale = LinearScale<Double, CGFloat>(from: 0.003, to: 0.056)
        guard let result = scale.scale(incoming + 0.003, from: CGFloat(1.0), to: CGFloat(367.0)) else {
            XCTFail()
            return
        }
        XCTAssertTrue(outputRange.contains(result))
    }

    func testDoubleLinearScaleTicks() {
        let myScale = LinearScale<Double, Float>(from: 0.0, to: 1.0)
        XCTAssertEqual(myScale.transformType, .none)

        let testRange = Float(0) ... Float(100.0)
        let defaultTicks = myScale.ticks(rangeLower: testRange.lowerBound, rangeHigher: testRange.upperBound)
        XCTAssertEqual(defaultTicks.count, 6)
        for tick in defaultTicks {
            print(tick)
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(tick.value >= myScale.domainLower)
            XCTAssertTrue(tick.value <= myScale.domainHigher)
        }
    }

    func testArrayDomainModifier() {
        let myScale = LinearScale<Double, Float>(from: 0.0, to: 1.0)
        XCTAssertEqual(myScale.transformType, .none)

        let updated = myScale.domain([0.0, 10.0, 5.0])
        XCTAssertEqual(updated.domainLower, 0.0)
        XCTAssertEqual(updated.domainHigher, 10.0)
    }

    func testFloatLinearScaleTicks() {
        let myScale = LinearScale<Float, Float>(from: 0.0, to: 1.0)
        XCTAssertEqual(myScale.transformType, .none)

        let testRange = Float(0) ... Float(100.0)
        let defaultTicks = myScale.ticks(rangeLower: testRange.lowerBound, rangeHigher: testRange.upperBound)
        XCTAssertEqual(defaultTicks.count, 6)
        for tick in defaultTicks {
            print(tick)
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(tick.value >= myScale.domainLower)
            XCTAssertTrue(tick.value <= myScale.domainHigher)
        }
    }

    func testDoubleLinearScaleManualTicks() {
        let myScale = LinearScale<Double, Float>(from: 0.0, to: 10.0)
        XCTAssertEqual(myScale.transformType, .none)

        let testRange = Float(0) ... Float(100.0)
        let manualTicks = myScale.tickValues([0.1, 0.5], from: testRange.lowerBound, to: testRange.upperBound)

        XCTAssertEqual(manualTicks.count, 2)
        for tick in manualTicks {
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(tick.value >= myScale.domainLower)
            XCTAssertTrue(tick.value <= myScale.domainHigher)
        }
    }

    func testFloatLinearScaleManualTicks() {
        let myScale = LinearScale<Float, Float>(from: 0.0, to: 10.0)
        XCTAssertEqual(myScale.transformType, .none)

        let testRange = Float(0) ... Float(100.0)
        let manualTicks = myScale.tickValues([0.1, 0.5], from: testRange.lowerBound, to: testRange.upperBound)

        XCTAssertEqual(manualTicks.count, 2)
        for tick in manualTicks {
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(tick.value >= myScale.domainLower)
            XCTAssertTrue(tick.value <= myScale.domainHigher)
        }
    }

    func testDoubleLinearScaleClamp() {
        let scale = LinearScale<Double, Float>(from: 0.0, to: 10.0)
        let clampedScale = LinearScale<Double, Float>(from: 0.0, to: 10.0, transform: .clamp)
        let dropScale = LinearScale<Double, Float>(from: 0, to: 10, transform: .drop)
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
        let scale = LinearScale<Int, Float>(from: 0, to: 10)
        let clampedScale = LinearScale<Int, Float>(from: 0, to: 10, transform: .clamp)
        let dropScale = LinearScale<Int, Float>(from: 0, to: 10, transform: .drop)

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
        let scale = LinearScale<Double, Float>(from: 0.0, to: 10.0)
        let clampedScale = LinearScale<Double, Float>(from: 0.0, to: 10.0, transform: .clamp)
        let dropScale = LinearScale<Double, Float>(from: 0, to: 10, transform: .drop)
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
        let scale = LinearScale<Int, Float>(from: 0, to: 10)
        let clampedScale = LinearScale<Int, Float>(from: 0, to: 10, transform: .clamp)
        let dropScale = LinearScale<Int, Float>(from: 0, to: 10, transform: .drop)
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
        let scale = LinearScale<Double, Float>()
        XCTAssertEqual(0, scale.domainLower)
        XCTAssertEqual(1, scale.domainHigher)
        XCTAssertNil(scale.rangeLower)
        XCTAssertNil(scale.rangeHigher)

        let updated = scale.domain(lower: 10, higher: 100)
        XCTAssertEqual(10, updated.domainLower)
        XCTAssertEqual(100, updated.domainHigher)
    }

    func testLinearScaleDomain2Modifier() {
        let scale = LinearScale<Double, Float>()
        XCTAssertEqual(0, scale.domainLower)
        XCTAssertEqual(1, scale.domainHigher)
        XCTAssertNil(scale.rangeLower)
        XCTAssertNil(scale.rangeHigher)

        let updated = scale.domain(10 ... 100)
        XCTAssertEqual(10, updated.domainLower)
        XCTAssertEqual(100, updated.domainHigher)
    }

    func testLinearScaleRangeModifier() {
        let scale = LinearScale<Double, Float>()
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
        let scale = LinearScale<Double, Float>()
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
        let scale = LinearScale<Double, Float>()
        XCTAssertEqual(scale.transformType, DomainDataTransform.none)

        let updated = scale.transform(.clamp)
        XCTAssertEqual(updated.transformType, DomainDataTransform.clamp)
    }
    
    func testScaleDomainOfOneValue() {
        let scale = LinearScale<Double, CGFloat>()
        
        let updated = scale.domain([5.0])
        XCTAssertEqual(updated.domainLower, 5)
        XCTAssertEqual(updated.domainHigher, 5)
    }

    func testScaleDomainOfOneValueNiced() {
        let scale = LinearScale<Double, CGFloat>()
        
        let updated = scale.domain([5.0], nice: true)
        XCTAssertEqual(updated.domainLower, 5)
        XCTAssertEqual(updated.domainHigher, 5)
    }

}
