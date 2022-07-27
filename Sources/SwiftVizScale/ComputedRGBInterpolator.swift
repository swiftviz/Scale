//
//  ComputedRGBInterpolator.swift
//  

import CoreGraphics

@available(watchOS 6.0, *)
public struct ComputedRGBInterpolator: ColorInterpolator {
    let rClosure: (Double) -> Double
    let gClosure: (Double) -> Double
    let bClosure: (Double) -> Double

    /// Creates a new color interpolator that maps between the two colors you provide.
    /// - Parameters:
    ///   - from: The color at the beginning.
    ///   - to: The color at the end.
    public init(r: @escaping (Double) -> Double,
                g: @escaping (Double) -> Double,
                b: @escaping (Double) -> Double) {
        rClosure = r
        gClosure = g
        bClosure = b
    }

    /// Returns the color mapped from the unit value you provide.
    /// - Parameter t: A unit value between `0` and  `1`.
    public func interpolate(_ t: Double) -> CGColor {
        let red: CGFloat = rClosure(t)
        let green: CGFloat = gClosure(t)
        let blue: CGFloat = bClosure(t)
        return CGColor(srgbRed: red, green: green, blue: blue, alpha: 1.0)
    }
}
