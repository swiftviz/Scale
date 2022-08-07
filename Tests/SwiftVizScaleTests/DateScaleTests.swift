//
//  DateScaleTests.swift
//

@testable import SwiftVizScale
import XCTest

final class DateScaleTests: XCTestCase {
    let now = ISO8601DateFormatter().date(from: "2022-08-07T10:41:00+0000")!

    func testScaleDescription() throws {
        let myScale = DateScale<CGFloat>(lower: now, higher: now.addingTimeInterval(500))

        XCTAssertEqual(String(describing: myScale), "linear(xform:none)[2022-08-07 10:41:00 +0000:2022-08-07 10:49:20 +0000]->[nil:nil]")

        let clampedScale = myScale.transform(.clamp)
        XCTAssertEqual(String(describing: clampedScale), "linear(xform:clamp)[2022-08-07 10:41:00 +0000:2022-08-07 10:49:20 +0000]->[nil:nil]")
    }

    func testProps() throws {
        let myScale = DateScale<CGFloat>(lower: now, higher: now.addingTimeInterval(500))
        XCTAssertEqual(myScale.desiredTicks, 10)
    }

    func testDateConversionAssumptions() throws {
        XCTAssertEqual(now.timeIntervalSinceReferenceDate, 681_561_660.0)
    }

    func testDomainModifiers() throws {
        let myScale = DateScale<CGFloat>(lower: now, higher: now.addingTimeInterval(500))
        let updated = myScale.domain(lower: now.addingTimeInterval(-500), higher: now)
        XCTAssertEqual(updated.domainLower, now.addingTimeInterval(-500))
        XCTAssertEqual(updated.domainHigher, now)

        let dateSet = [now, now.addingTimeInterval(-600), now.addingTimeInterval(600)]
        let setUpdated = updated.domain(dateSet)
        XCTAssertEqual(setUpdated.domainLower, now.addingTimeInterval(-600))
        XCTAssertEqual(setUpdated.domainHigher, now.addingTimeInterval(600))
    }

    func testTransformModifier() throws {
        let myScale = DateScale<CGFloat>(lower: now, higher: now.addingTimeInterval(500))
        XCTAssertEqual(myScale.transformType, .none)
        let updated = myScale.transform(.clamp)
        XCTAssertEqual(updated.transformType, .clamp)
    }

    func testScaleTypeModifier() throws {
        let myScale = DateScale<CGFloat>(lower: now, higher: now.addingTimeInterval(500))
        XCTAssertEqual(myScale.scaleType, .linear)
        let updated = myScale.scaleType(.log)
        XCTAssertEqual(updated.scaleType, .log)
    }

    func testRangeModifier() throws {
        let myScale = DateScale<CGFloat>(lower: now, higher: now.addingTimeInterval(500))
        XCTAssertNil(myScale.rangeLower)
        XCTAssertNil(myScale.rangeHigher)
        XCTAssertEqual(myScale.reversed, false)
        var updated = myScale.range(lower: 0, higher: 100)
        XCTAssertEqual(updated.rangeLower, 0)
        XCTAssertEqual(updated.rangeHigher, 100)
        XCTAssertEqual(myScale.reversed, false)
        updated = updated.range(reversed: true, lower: 0, higher: 100)
        XCTAssertEqual(updated.rangeLower, 0)
        XCTAssertEqual(updated.rangeHigher, 100)
        XCTAssertEqual(updated.reversed, true)

        updated = updated.range(reversed: false, 50 ... 200)
        XCTAssertEqual(updated.rangeLower, 50)
        XCTAssertEqual(updated.rangeHigher, 200)
        XCTAssertEqual(updated.reversed, false)

        updated = updated.range(100 ... 250)
        XCTAssertEqual(updated.rangeLower, 100)
        XCTAssertEqual(updated.rangeHigher, 250)
        XCTAssertEqual(updated.reversed, false)
    }

    func testScalingOutput() throws {
        let myScale = DateScale<CGFloat>(lower: now, higher: now.addingTimeInterval(600)).range(0 ... 100)
        XCTAssertEqual(myScale.scale(now.addingTimeInterval(300)), 50)
    }

    func testInvertOutput() throws {
        let myScale = DateScale<CGFloat>(lower: now, higher: now.addingTimeInterval(600)).range(0 ... 100).transform(.drop)
        XCTAssertEqual(myScale.invert(25), now.addingTimeInterval(150))

        XCTAssertNil(myScale.invert(250))
    }
}
