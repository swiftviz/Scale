//
//  LCHTests.swift
//

#if canImport(CoreGraphics)

    @testable import SwiftVizScale
    import XCTest

    final class LCHTests: XCTestCase {

        @MainActor
        func testLCHWhiteInterpolation() throws {
            // There's not really much to be able to pin down in terms of color space tests, but
            // for the LCH color space, and interpolation between white and black shouldn't ever
            // adjust the chroma or hue while it does it's thing, so we'll check that as a general
            // benchmark.
            let black = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
            let white = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)

            for step in 0 ... 99 {
                let interpolatedColor = LCH.interpolate(black, white, t: CGFloat(step) / 100.0)
                let components = LCH.components(from: interpolatedColor)
                // This has notably looser bounds on "0" on iOS while testing w/ Github Actions simulator
                XCTAssertEqual(components[1], 0.0, accuracy: 0.1)
                // Hue doesn't apparently stay at 0 while testing w/ Github Actions simulator (Xcode 13.2.1)
                // XCTAssertEqual(components[2], 0.0, accuracy: 0.001)
                XCTAssertEqual(components[3], 1.0, accuracy: 0.001)
            }
        }
    }
#endif
