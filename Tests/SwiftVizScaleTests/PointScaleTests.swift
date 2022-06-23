//
//  PointScaleTests.swift
//

@testable import SwiftVizScale
import XCTest

class PointScaleTests: XCTestCase {
    func testInitializers() throws {
        let x = PointScale<String, CGFloat>()
        XCTAssertNotNil(x)
        XCTAssertFalse(x.fullyConfigured())

        XCTAssertEqual(x.round, false)
        XCTAssertEqual(x.padding, 0)
        XCTAssertEqual(x.domain.count, 0)
    }

    func testPartialConfiguration() throws {
        let x = PointScale<String, CGFloat>(["1", "2"])
        XCTAssertNotNil(x)
        XCTAssertFalse(x.fullyConfigured())

        XCTAssertEqual(x.round, false)
        XCTAssertEqual(x.padding, 0)
        XCTAssertEqual(x.domain.count, 2)

        let updated = x.range(lower: 0, higher: 100)
        XCTAssertTrue(updated.fullyConfigured())
    }

    func testInitialFullConfig() throws {
        let x = PointScale<String, CGFloat>(["1", "2"], from: 0, to: 100)
        XCTAssertTrue(x.fullyConfigured())
    }

    func testDomainModifier() throws {
        let initial = PointScale<String, CGFloat>(["1", "2"], from: 0, to: 100)
        let updated = initial.domain(["1", "2", "3"])

        XCTAssertTrue(updated.fullyConfigured())
        XCTAssertEqual(updated.domain.count, 3)
    }

    func testRoundModifier() throws {
        let initial = PointScale<String, CGFloat>(["1", "2"], from: 0, to: 100)
        XCTAssertFalse(initial.round)
        let updated = initial.round(true)

        XCTAssertTrue(updated.fullyConfigured())
        XCTAssertTrue(updated.round)
    }

    func testPaddingModifier() throws {
        let initial = PointScale<String, CGFloat>(["1", "2"], from: 0, to: 100)
        XCTAssertEqual(initial.padding, 0)
        let updated = initial.padding(5)

        XCTAssertTrue(updated.fullyConfigured())
        XCTAssertEqual(updated.padding, 5)
    }

    func testRangeModifier() throws {
        let initial = PointScale<String, CGFloat>(["1", "2"])
        XCTAssertNil(initial.rangeLower)
        XCTAssertNil(initial.rangeHigher)
        XCTAssertFalse(initial.fullyConfigured())

        let updated = initial.range(lower: 0, higher: 100)
        XCTAssertTrue(updated.fullyConfigured())
        XCTAssertEqual(updated.rangeLower, 0)
        XCTAssertEqual(updated.rangeHigher, 100)
    }

    func testRangeModifierWithRange() throws {
        let initial = PointScale<String, CGFloat>(["1", "2"])
        XCTAssertNil(initial.rangeLower)
        XCTAssertNil(initial.rangeHigher)
        XCTAssertFalse(initial.fullyConfigured())

        let updated = initial.range(CGFloat(0.0) ... CGFloat(100.0))
        XCTAssertTrue(updated.fullyConfigured())
        XCTAssertEqual(updated.rangeLower, 0)
        XCTAssertEqual(updated.rangeHigher, 100)
    }

    func testStep() throws {
        let initial = PointScale<String, CGFloat>(["1", "2"], from: 0, to: 100)
        XCTAssertTrue(initial.fullyConfigured())

        let width = initial.step()
        XCTAssertNotNil(width)
        if let width = width {
            XCTAssertEqual(width, 50, accuracy: 0.001)
        }
        let updated = initial.padding(10)

        let updatedWidth = updated.step()
        XCTAssertNotNil(updatedWidth)
        if let updatedWidth = updatedWidth {
            XCTAssertEqual(updatedWidth, 40, accuracy: 0.001)
        }
    }

    func testScale() throws {
        let initial = PointScale<String, CGFloat>(["1", "2"], from: 0, to: 100)
        XCTAssertTrue(initial.fullyConfigured())

        let rangeLoc = initial.scale("1")
        XCTAssertNotNil(rangeLoc)
        XCTAssertEqual(rangeLoc, 25)
    }

    func testScaleWithRangeUpdate() throws {
        let initial = PointScale<String, CGFloat>(["1", "2", "3"], from: 0, to: 100)
        XCTAssertTrue(initial.fullyConfigured())

        let rangeLoc = initial.scale("2", from: 0, to: 50)
        XCTAssertNotNil(rangeLoc)
        if let rangeLocDouble = rangeLoc?.toDouble() {
            XCTAssertEqual(rangeLocDouble, 25, accuracy: 0.001)
        }
    }

    func testScaleInvalidValue() throws {
        let initial = PointScale<String, CGFloat>(["1", "2"], from: 0, to: 100)
        XCTAssertTrue(initial.fullyConfigured())
        XCTAssertNil(initial.scale("3"))
    }

    func testInvert() throws {
        let initial = PointScale<String, CGFloat>(["1", "2", "3"], from: 0, to: 100)
        XCTAssertTrue(initial.fullyConfigured())

        let value = initial.invert(15)
        XCTAssertNotNil(value)
        XCTAssertEqual(value, "1")
    }

    func testInvertWithoutRange() throws {
        let initial = PointScale<String, CGFloat>(["1", "2"])
        XCTAssertFalse(initial.fullyConfigured())

        let value = initial.invert(25)
        XCTAssertNil(value)
    }

    func testInvertOutsideOfRange() throws {
        let initial = PointScale<String, CGFloat>(["1", "2"], from: 0, to: 100)
        XCTAssertTrue(initial.fullyConfigured())

        let value = initial.invert(-25)
        XCTAssertNil(value)
    }

    func testScaleWithExcessivePadding() throws {
        let initial = PointScale<String, CGFloat>(["1", "2"], padding: 70)
        XCTAssertFalse(initial.fullyConfigured())
        XCTAssertNil(initial.scale("2", from: 0, to: 50))
    }

    func testScaleWithRound() throws {
        let initial = PointScale<String, CGFloat>(["1", "2", "3"], padding: 10)
        XCTAssertFalse(initial.fullyConfigured())
        var rangeLoc = initial.scale("2", from: 0, to: 50)
        XCTAssertNotNil(rangeLoc)
        if let rangeLocDouble = rangeLoc?.toDouble() {
            XCTAssertEqual(rangeLocDouble, 25, accuracy: 0.001)
        }

        let updated = initial.round(true)
        rangeLoc = updated.scale("1", from: 0, to: 50)
        XCTAssertNotNil(rangeLoc)
        if let rangeLocDouble = rangeLoc?.toDouble() {
            XCTAssertEqual(rangeLocDouble, 15.0, accuracy: 0.001)
        }
    }

    func testCustomStringConvertibleImplementation() throws {
        let scale = PointScale<String, CGFloat>(["1", "2", "3"], padding: 10)
        XCTAssertEqual("\(scale)", "point[\"1\", \"2\", \"3\"]->[nil:nil]")
    }

    func testReversedRangeModifiers() {
        var scale = PointScale<String, CGFloat>(["X", "Y", "Z"]).range(0 ... 30)
        XCTAssertEqual(scale.reversed, false)
        scale = PointScale<String, CGFloat>(["X", "Y", "Z"], reversed: true, from: 0, to: 30)
        XCTAssertEqual(scale.reversed, true)
        scale = scale.range(0 ... 40)
        XCTAssertEqual(scale.reversed, true)
        scale = scale.range(reversed: false, 0 ... 40)
        XCTAssertEqual(scale.reversed, false)
    }

    func testReversedCalculations() {
        let reversed = PointScale<String, CGFloat>(["X", "Y", "Z"], reversed: true, from: 0, to: 30)
        // print(reversed.scale("X"))
        XCTAssertEqual(reversed.scale("Z"), 5)
        XCTAssertEqual(reversed.scale("Y"), 15)
        XCTAssertEqual(reversed.scale("X"), 25)
        XCTAssertEqual(reversed.invert(15), "Y")

        let forward = reversed.range(reversed: false, lower: 0, higher: 30) // identity
        XCTAssertEqual(forward.scale("X"), 5)
        XCTAssertEqual(forward.scale("Y"), 15)
        XCTAssertEqual(forward.scale("Z"), 25)
        // verify invert
        XCTAssertEqual(forward.invert(5), "X")
    }

    func testReversedTicks() {
        let reversed = PointScale<String, CGFloat>(["X", "Y", "Z"], reversed: true, from: 0, to: 30)
        let reverseTicks = reversed.ticks(rangeLower: 0, rangeHigher: 30)
        XCTAssertEqual(reverseTicks.count, 3)
        print(reverseTicks)
        assertTick(reverseTicks[0], "X", 25)
        assertTick(reverseTicks[1], "Y", 15)
        assertTick(reverseTicks[2], "Z", 5)

        let forward = reversed.range(reversed: false, lower: 0, higher: 30) // identity
        let forwardTicks = forward.ticks(rangeLower: 0, rangeHigher: 30)
        XCTAssertEqual(forwardTicks.count, 3)
        assertTick(forwardTicks[0], "X", 5)
        assertTick(forwardTicks[1], "Y", 15)
        assertTick(forwardTicks[2], "Z", 25)
    }
}
