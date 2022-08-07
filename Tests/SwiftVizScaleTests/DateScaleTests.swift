//
//  DateScaleTests.swift
//  

import XCTest
@testable import SwiftVizScale

final class DateScaleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testScaleDescription() {
        let now = Date()
        let myScale = DateScale<CGFloat>(lower: now, higher: now.addingTimeInterval(500))

        XCTAssertEqual(String(describing: myScale), "linear(xform:none)[1.0:50.0]->[nil:nil]")

        let clampedScale = ContinuousScale<CGFloat>(1.0 ... 50.0).transform(.clamp)
        XCTAssertEqual(String(describing: clampedScale), "linear(xform:clamp)[1.0:50.0]->[nil:nil]")

        let secondScale = ContinuousScale<CGFloat>(1 ... 100, type: .log).range(lower: 0, higher: 300)
        XCTAssertEqual(String(describing: secondScale), "log(xform:none)[1.0:100.0]->[Optional(0.0):Optional(300.0)]")
    }

}
