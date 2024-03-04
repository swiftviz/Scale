//
//  ScaleAssertions.swift
//

import SwiftVizScale
import XCTest

func assertTick(_ tick: Tick<CGFloat>, _ label: String, _ location: CGFloat, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(tick.rangeLocation, location, accuracy: 0.001, file: file, line: line)
    XCTAssertEqual(tick.label, label, file: file, line: line)
}

func assertBand(_ band: Band<String, CGFloat>?, _ label: String, low: CGFloat, high: CGFloat, file: StaticString = #file, line: UInt = #line) {
    XCTAssertNotNil(band, file: file, line: line)
    guard let band else {
        return
    }
    XCTAssertEqual(band.value, label, file: file, line: line)
    XCTAssertEqual(band.lower, low, file: file, line: line)
    XCTAssertEqual(band.higher, high, file: file, line: line)
}
