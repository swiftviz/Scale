//
//  PointScaleTests.swift
//
//
//  Created by Joseph Heck on 4/1/22.
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

        let updated = x.range(from: 0, to: 100)
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
        XCTAssertNil(initial.from)
        XCTAssertNil(initial.to)
        XCTAssertFalse(initial.fullyConfigured())

        let updated = initial.range(from: 0, to: 100)
        XCTAssertTrue(updated.fullyConfigured())
        XCTAssertEqual(updated.from, 0)
        XCTAssertEqual(updated.to, 100)
    }

    func testRangeModifierWithRange() throws {
        let initial = PointScale<String, CGFloat>(["1", "2"])
        XCTAssertNil(initial.from)
        XCTAssertNil(initial.to)
        XCTAssertFalse(initial.fullyConfigured())

        let updated = initial.range(CGFloat(0.0) ... CGFloat(100.0))
        XCTAssertTrue(updated.fullyConfigured())
        XCTAssertEqual(updated.from, 0)
        XCTAssertEqual(updated.to, 100)
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
        XCTAssertEqual(rangeLoc, 0)
    }

    func testScaleWithRangeUpdate() throws {
        let initial = PointScale<String, CGFloat>(["1", "2", "3"], from: 0, to: 100)
        XCTAssertTrue(initial.fullyConfigured())

        let rangeLoc = initial.scale("2", from: 0, to: 50)
        XCTAssertNotNil(rangeLoc)
        if let rangeLocDouble = rangeLoc?.toDouble() {
            XCTAssertEqual(rangeLocDouble, 16.666, accuracy: 0.001)
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

        let value = initial.invert(from: 15)
        XCTAssertNotNil(value)
        XCTAssertEqual(value, "1")
    }

    func testInvertWithoutRange() throws {
        let initial = PointScale<String, CGFloat>(["1", "2"])
        XCTAssertFalse(initial.fullyConfigured())

        let value = initial.invert(from: 25)
        XCTAssertNil(value)
    }

    func testInvertOutsideOfRange() throws {
        let initial = PointScale<String, CGFloat>(["1", "2"], from: 0, to: 100)
        XCTAssertTrue(initial.fullyConfigured())

        let value = initial.invert(from: -25)
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
            XCTAssertEqual(rangeLocDouble, 20, accuracy: 0.001)
        }

        let updated = initial.round(true)
        rangeLoc = updated.scale("1", from: 0, to: 50)
        XCTAssertNotNil(rangeLoc)
        if let rangeLocDouble = rangeLoc?.toDouble() {
            XCTAssertEqual(rangeLocDouble, 10.0, accuracy: 0.001)
        }
    }
}
