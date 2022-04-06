//
//  BandScaleTests.swift
//
//
//  Created by Joseph Heck on 4/1/22.
//

@testable import SwiftVizScale
import XCTest

class BandScaleTests: XCTestCase {
    func testInitializers() throws {
        let x = BandScale<String, CGFloat>()
        XCTAssertNotNil(x)
        XCTAssertFalse(x.fullyConfigured())

        XCTAssertEqual(x.round, false)
        XCTAssertEqual(x.paddingOuter, 0)
        XCTAssertEqual(x.paddingInner, 0)
        XCTAssertEqual(x.domain.count, 0)
    }

    func testPartialConfiguration() throws {
        let x = BandScale<String, CGFloat>(["1", "2"])
        XCTAssertNotNil(x)
        XCTAssertFalse(x.fullyConfigured())

        XCTAssertEqual(x.round, false)
        XCTAssertEqual(x.paddingOuter, 0)
        XCTAssertEqual(x.paddingInner, 0)
        XCTAssertEqual(x.domain.count, 2)

        let updated = x.range(lower: 0, higher: 100)
        XCTAssertTrue(updated.fullyConfigured())
    }

    func testInitialFullConfig() throws {
        let x = BandScale<String, CGFloat>(["1", "2"], from: 0, to: 100)
        XCTAssertTrue(x.fullyConfigured())
    }

    func testDomainModifier() throws {
        let initial = BandScale<String, CGFloat>(["1", "2"], from: 0, to: 100)
        let updated = initial.domain(["1", "2", "3"])

        XCTAssertTrue(updated.fullyConfigured())
        XCTAssertEqual(updated.domain.count, 3)
    }

    func testRoundModifier() throws {
        let initial = BandScale<String, CGFloat>(["1", "2"], from: 0, to: 100)
        XCTAssertFalse(initial.round)
        let updated = initial.round(true)

        XCTAssertTrue(updated.fullyConfigured())
        XCTAssertTrue(updated.round)
    }

    func testInnerPaddingModifier() throws {
        let initial = BandScale<String, CGFloat>(["1", "2"], from: 0, to: 100)
        XCTAssertEqual(initial.paddingInner, 0)
        let updated = initial.paddingInner(5)

        XCTAssertTrue(updated.fullyConfigured())
        XCTAssertEqual(updated.paddingInner, 5)
    }

    func testOuterPaddingModifier() throws {
        let initial = BandScale<String, CGFloat>(["1", "2"], from: 0, to: 100)
        XCTAssertEqual(initial.paddingOuter, 0)
        let updated = initial.paddingOuter(5)

        XCTAssertTrue(updated.fullyConfigured())
        XCTAssertEqual(updated.paddingOuter, 5)
    }

    func testRangeModifier() throws {
        let initial = BandScale<String, CGFloat>(["1", "2"])
        XCTAssertNil(initial.rangeLower)
        XCTAssertNil(initial.rangeHigher)
        XCTAssertFalse(initial.fullyConfigured())

        let updated = initial.range(lower: 0, higher: 100)
        XCTAssertTrue(updated.fullyConfigured())
        XCTAssertEqual(updated.rangeLower, 0)
        XCTAssertEqual(updated.rangeHigher, 100)
    }

    func testRangeModifierWithRange() throws {
        let initial = BandScale<String, CGFloat>(["1", "2"])
        XCTAssertNil(initial.rangeLower)
        XCTAssertNil(initial.rangeHigher)
        XCTAssertFalse(initial.fullyConfigured())

        let updated = initial.range(CGFloat(0.0) ... CGFloat(100.0))
        XCTAssertTrue(updated.fullyConfigured())
        XCTAssertEqual(updated.rangeLower, 0)
        XCTAssertEqual(updated.rangeHigher, 100)
    }

    func testWidth() throws {
        let initial = BandScale<String, CGFloat>(["1", "2"], from: 0, to: 100)
        XCTAssertTrue(initial.fullyConfigured())

        let width = initial.width()
        XCTAssertNotNil(width)
        if let width = width {
            XCTAssertEqual(width, 50, accuracy: 0.001)
        }
        let updated = initial.paddingOuter(10)

        let updatedWidth = updated.width()
        XCTAssertNotNil(updatedWidth)
        if let updatedWidth = updatedWidth {
            XCTAssertEqual(updatedWidth, 40, accuracy: 0.001)
        }
    }

    func testStep() throws {
        let initial = BandScale<String, CGFloat>(["1", "2"], from: 0, to: 100)
        XCTAssertTrue(initial.fullyConfigured())

        let width = initial.width()
        XCTAssertNotNil(width)
        if let width = width {
            XCTAssertEqual(initial.step(), width + initial.paddingInner)
        }
    }

    func testScale() throws {
        let initial = BandScale<String, CGFloat>(["1", "2"], from: 0, to: 100)
        XCTAssertTrue(initial.fullyConfigured())

        let band = initial.scale("1")
        XCTAssertNotNil(band)
        XCTAssertEqual(band?.value, "1")
        XCTAssertEqual(band?.lower, 0)
        XCTAssertEqual(band?.higher, 50)
    }

    func testScaleWithRangeUpdate() throws {
        let initial = BandScale<String, CGFloat>(["1", "2"], from: 0, to: 100)
        XCTAssertTrue(initial.fullyConfigured())

        let band = initial.scale("2", from: 0, to: 50)
        XCTAssertNotNil(band)
        XCTAssertEqual(band?.value, "2")
        XCTAssertEqual(band?.lower, 25)
        XCTAssertEqual(band?.higher, 50)
    }

    func testScaleInvalidValue() throws {
        let initial = BandScale<String, CGFloat>(["1", "2"], from: 0, to: 100)
        XCTAssertTrue(initial.fullyConfigured())

        XCTAssertNil(initial.scale("3"))
    }

    func testInvert() throws {
        let initial = BandScale<String, CGFloat>(["1", "2"], from: 0, to: 100)
        XCTAssertTrue(initial.fullyConfigured())

        let value = initial.invert(25)
        XCTAssertNotNil(value)
        XCTAssertEqual(value, "1")
    }

    func testInvertWithoutRange() throws {
        let initial = BandScale<String, CGFloat>(["1", "2"])
        XCTAssertFalse(initial.fullyConfigured())

        let value = initial.invert(25)
        XCTAssertNil(value)
    }

    func testInvertOutsideOfRange() throws {
        let initial = BandScale<String, CGFloat>(["1", "2"], from: 0, to: 100)
        XCTAssertTrue(initial.fullyConfigured())

        let value = initial.invert(-25)
        XCTAssertNil(value)
    }

    func testInvertMatchingPadding() throws {
        let initial = BandScale<String, CGFloat>(["1", "2"], paddingInner: 10, paddingOuter: 10)
        XCTAssertFalse(initial.fullyConfigured())

        XCTAssertNil(initial.invert(5, from: 0, to: 100))

        XCTAssertNil(initial.invert(25, from: 0, to: 50))
    }

    func testScaleWithExcessivePadding() throws {
        let initial = BandScale<String, CGFloat>(["1", "2", "3", "4", "5", "6", "7"], paddingInner: 10, paddingOuter: 10)
        XCTAssertFalse(initial.fullyConfigured())
        XCTAssertNil(initial.scale("2", from: 0, to: 50))
    }

    func testScaleWithRound() throws {
        let initial = BandScale<String, CGFloat>(["1", "2", "3"], paddingInner: 10, paddingOuter: 10)
        XCTAssertFalse(initial.fullyConfigured())
        var band = initial.scale("2", from: 0, to: 50)
        XCTAssertNotNil(band)
        XCTAssertEqual(band!.higher, 26.666, accuracy: 0.001)
        XCTAssertEqual(band!.lower, 23.333, accuracy: 0.001)

        let updated = initial.round(true)
        band = updated.scale("2", from: 0, to: 50)
        XCTAssertNotNil(band)
        XCTAssertEqual(band!.higher, 26.0, accuracy: 0.001)
        XCTAssertEqual(band!.lower, 23.0, accuracy: 0.001)
    }
}
