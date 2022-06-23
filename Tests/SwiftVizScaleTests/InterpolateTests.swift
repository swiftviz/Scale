//
//  InterpolateTests.swift
//

@testable import SwiftVizScale
import XCTest

final class InterpolateTests: XCTestCase {
    func testInterpolateMid() {
        let resultValue = interpolate(0.5, lower: 100.0, higher: 200.0)
        XCTAssertEqual(resultValue, 150.0, accuracy: 0.1)
    }

    func testInterpolateBelow() {
        let resultValue = interpolate(-0.5, lower: 100.0, higher: 200.0)
        XCTAssertEqual(resultValue, 50.0, accuracy: 0.1)
    }

    func testInterpolateLower() {
        let resultValue = interpolate(0.0, lower: 100.0, higher: 200.0)
        XCTAssertEqual(resultValue, 100.0, accuracy: 0.1)
    }

    func testInterpolateUpper() {
        let resultValue = interpolate(1.0, lower: 100.0, higher: 200.0)
        XCTAssertEqual(resultValue, 200.0, accuracy: 0.1)
    }

    func testInterpolateAbove() {
        let resultValue = interpolate(1.5, lower: 100.0, higher: 200.0)
        XCTAssertEqual(resultValue, 250.0, accuracy: 0.1)
    }

    func testInterpolateNearZero() {
        let resultValue = normalize(0.001, lower: 0.0, higher: 100.0)

        XCTAssertFalse(resultValue.isNaN)
        XCTAssertEqual(resultValue, 0.0, accuracy: 0.01)
    }

    func testRedInterpolationResults() throws {
        let red = CGColor(red: 1, green: 0, blue: 0, alpha: 0)
        let components = LCH.components(from: red, for: CGColorSpace(name: CGColorSpace.genericXYZ)!)
        print("components: \(components)")
        // generic RGB: [1.0, 0.0, 0.0002487376914359629, 0.0]
        // sRGB: [1.0, 0.14910027384757996, 0.0, 0.0]
        // extendedSRGB: [1.0110152959823608, 0.14910027384757996, -0.022766731679439545, 0.0]
        // extendedLinearSRGB: [1.025241732597351, 0.019400756806135178, -0.0017621309962123632, 0.0]
        // generic lab: [56.27880096435547, 77.81539916992188, 72.43891906738281, 0.0]
        // generic XYZ: [0.45425543189048767, 0.241912841796875, 0.014888899400830269, 0.0]
    }
}
