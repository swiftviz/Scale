//
//  DiscreteScaleTests.swift
//

@testable import SwiftVizScale
import XCTest

class DiscreteScaleTests: XCTestCase {
    func testEmptyScale() throws {
        let scale = BandScale<String, CGFloat>()
        let ticks = scale.ticks(rangeLower: 0, rangeHigher: 10)
        XCTAssertEqual(ticks.count, 0)
    }

    func testTicksOnPointScaleWithDomain() throws {
        let scale = PointScale<String, CGFloat>(["1", "2", "3"])
        let ticks = scale.ticks(rangeLower: 0, rangeHigher: 10)
        XCTAssertEqual(ticks.count, 3)
    }

    func testTicksOnBandScaleWithDomain() throws {
        let scale = BandScale<String, CGFloat>(["1", "2", "3"])
        let ticks = scale.ticks(rangeLower: 0, rangeHigher: 10)
        XCTAssertEqual(ticks.count, 3)
    }
}
