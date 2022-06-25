//
//  ArrayInterpolatorTests.swift
//

@testable import SwiftVizScale
import XCTest

final class ArrayInterpolatorTests: XCTestCase {
    func testSweepInterpolateIntoSteps() throws {
        for count in 2 ... 10 {
            for tValue in 0 ... 10 {
                let (index, index2, intermediateTValue) = ArrayInterpolator.interpolateIntoSteps(Double(tValue) / 10, count)
                XCTAssertTrue(index >= 0)
                XCTAssertTrue(index < count - 1)
                XCTAssertEqual(index2, index + 1)
                XCTAssertTrue((0.0 ... 1.0).contains(intermediateTValue))
            }
        }
    }
}
