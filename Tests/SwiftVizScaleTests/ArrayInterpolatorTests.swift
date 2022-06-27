//
//  ArrayInterpolatorTests.swift
//

@testable import SwiftVizScale
import XCTest

final class ArrayInterpolatorTests: XCTestCase {
    func testSweepInterpolateIntoSteps() throws {
        for count in 2 ... 10 {
            for tValue in 0 ... 10 {
                let (index, intermediateTValue) = ArrayInterpolator.interpolateIntoSteps(Double(tValue) / 10, count)
                XCTAssertTrue(index >= 0)
                XCTAssertTrue(index < count - 1)
                XCTAssertTrue((0.0 ... 1.0).contains(intermediateTValue))
            }
        }
    }

    func testHexValuesFromInterpolatorGuides() throws {
        XCTAssertEqual(ArrayInterpolator.white.toHex(), "FFFFFF")
        XCTAssertEqual(ArrayInterpolator.black.toHex(), "000000")
        XCTAssertEqual(ArrayInterpolator.red.toHex(), "FF0000")
        XCTAssertEqual(ArrayInterpolator.green.toHex(), "00FF00")
        XCTAssertEqual(ArrayInterpolator.blue.toHex(), "0000FF")
    }

    func testHexSequence() throws {
        let colors = CGColor.fromHexSequence("010101FFFFFF")
        XCTAssertEqual(colors.count, 2)
        XCTAssertEqual(colors[0].toHex(), "010101")
        XCTAssertEqual(colors[1].toHex(), "FFFFFF")
    }

    func testHexSequenceWithBrokenSequence() throws {
        let colors = CGColor.fromHexSequence("010101FFFFFFABCD")
        XCTAssertEqual(colors.count, 2)
        XCTAssertEqual(colors[0].toHex(), "010101")
        XCTAssertEqual(colors[1].toHex(), "FFFFFF")
    }

    func testHexSequenceWithInvalidSequence() throws {
        let colors = CGColor.fromHexSequence("010101FFFFFFgoodbye")
        XCTAssertEqual(colors.count, 2)
        XCTAssertEqual(colors[0].toHex(), "010101")
        XCTAssertEqual(colors[1].toHex(), "FFFFFF")
    }

    func testFiveStepInterpolationValues() throws {
        // Five colors added means there'll be four breaks:
        // 0, 0.25, 0.5, 0.75, and 1.0
        let expectedTValueResults = [
            0.0: (0, 0.0),
            0.1: (0, 0.4),
            0.2: (0, 0.8),
            0.3: (1, 0.2),
            0.4: (1, 0.6),
            0.5: (2, 0.0),
            0.6: (2, 0.4),
            0.7: (2, 0.8),
            0.8: (3, 0.2),
            0.9: (3, 0.6),
            1.0: (3, 1.0),
        ]
        for (tValue, resultSet) in expectedTValueResults {
            let (index, intermediateTValue) = ArrayInterpolator.interpolateIntoSteps(tValue, 5)
            print("index: \(index) t: \(intermediateTValue)")
            XCTAssertEqual(index, resultSet.0)
            XCTAssertEqual(intermediateTValue, resultSet.1, accuracy: 0.001)
        }
    }
}
