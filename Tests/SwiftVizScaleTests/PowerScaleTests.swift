//
//  PowerScaleTests.swift
//

@testable import SwiftVizScale
import XCTest

class PowerScaleTests: XCTestCase {
    func testPowerScale_scale_identity() throws {
        let pow = ContinuousScale<CGFloat>(from: 0, to: 100, type: .power(1))
        guard let result = pow.scale(2, from: 0, to: 100) else {
            XCTFail()
            return
        }
        XCTAssertEqual(result, 2.0, accuracy: 0.001)
    }

    func testPowerScale_scale_square() throws {
        let pow = ContinuousScale<CGFloat>(from: 0, to: 10, type: .power(2))
        guard let result = pow.scale(2, from: 0, to: 100) else {
            XCTFail()
            return
        }
        XCTAssertEqual(result, 4.0, accuracy: 0.001)
    }

    func testPowerScale_invert_identity() throws {
        let pow = ContinuousScale<CGFloat>(from: 0, to: 100, type: .power(1))
        guard let result = pow.invert(5, from: 0, to: 100) else {
            XCTFail()
            return
        }
        XCTAssertEqual(result, 5, accuracy: 0.001)
    }

    func testPowerScale_invert_square() throws {
        let pow = ContinuousScale<CGFloat>(from: 0, to: 10, type: .power(2))
        guard let result = pow.invert(16, from: 0, to: 100) else {
            XCTFail()
            return
        }
        XCTAssertEqual(result, 4, accuracy: 0.001)
    }

    func testReversedRangeModifiers() {
        var scale = ContinuousScale<CGFloat>(0 ... 100, type: .power(1)).range(0 ... 100)
        XCTAssertEqual(scale.reversed, false)
        scale = ContinuousScale(from: 0, to: 100, reversed: true, rangeLower: 0, rangeHigher: 100)
        XCTAssertEqual(scale.reversed, true)
        scale = scale.range(0 ... 40)
        XCTAssertEqual(scale.reversed, true)
        scale = scale.range(reversed: false, 0 ... 40)
        XCTAssertEqual(scale.reversed, false)
    }

    func testReversedCalculations() {
        let scale = ContinuousScale<CGFloat>(from: 0, to: 100, type: .power(1), reversed: true, rangeLower: 0, rangeHigher: 100)
        XCTAssertEqual(scale.scale(0), 100)
        XCTAssertEqual(scale.scale(100), 0)
        XCTAssertEqual(scale.scale(10), 90)
        // verify invert
        XCTAssertEqual(scale.invert(90)!, 10.0, accuracy: 0.001)

        let forward = scale.range(reversed: false, lower: 0, higher: 100) // log identity
        XCTAssertEqual(forward.scale(0), 0)
        XCTAssertEqual(forward.scale(100), 100)
        XCTAssertEqual(forward.scale(10)!, 10.0, accuracy: 0.001)
        // verify invert
        XCTAssertEqual(forward.invert(90)!, 90.0, accuracy: 0.001)
    }

    func testReversedTicks() {
        let reversed = ContinuousScale<CGFloat>(from: 0, to: 100, type: .power(1), reversed: true, rangeLower: 0, rangeHigher: 100)
        let reverseTicks = reversed.ticks(rangeLower: 0, rangeHigher: 20)
        XCTAssertEqual(reverseTicks.count, 6)
        assertTick(reverseTicks[0], "0.0", 20)
        assertTick(reverseTicks[1], "20.0", 16)
        assertTick(reverseTicks[2], "40.0", 12)
        assertTick(reverseTicks[3], "60.0", 8)
        assertTick(reverseTicks[4], "80.0", 4)
        assertTick(reverseTicks[5], "100.0", 0)

        let forward = reversed.range(reversed: false, lower: 0, higher: 20) // identity
        let forwardTicks = forward.ticks(rangeLower: 0, rangeHigher: 20)
        XCTAssertEqual(forwardTicks.count, 6)
        assertTick(forwardTicks[0], "0.0", 0)
        assertTick(forwardTicks[1], "20.0", 4)
        assertTick(forwardTicks[2], "40.0", 8)
        assertTick(forwardTicks[3], "60.0", 12)
        assertTick(forwardTicks[4], "80.0", 16)
        assertTick(forwardTicks[5], "100.0", 20)
    }
}
