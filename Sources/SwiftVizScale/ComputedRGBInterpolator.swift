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
                b: @escaping (Double) -> Double)
    {
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

    private static func clampAndNormalize(_ t: Double) -> Double {
        max(0, min(255.0, t)) / 255.0
    }

    // Equation ported from
    // https://github.com/d3/d3-scale-chromatic/blob/main/src/sequential-multi/cividis.js
    // Copyright 2010-2021 Mike Bostock, used under License
    internal static let Cividis = ComputedRGBInterpolator { t in
        clampAndNormalize(-4.54 - t * (35.34 - t * (2381.73 - t * (6402.7 - t * (7024.72 - t * 2710.57)))))
    } g: { t in
        clampAndNormalize(32.49 + t * (170.73 + t * (52.82 - t * (131.46 - t * (176.58 - t * 67.37)))))
    } b: { t in
        clampAndNormalize(81.24 + t * (442.36 - t * (2482.43 - t * (6167.24 - t * (6614.94 - t * 2475.67)))))
    }

    // Equation ported from
    // https://github.com/d3/d3-scale-chromatic/blob/main/src/sequential-multi/turbo.js
    // Copyright 2010-2021 Mike Bostock, used under License

    internal static let Turbo = ComputedRGBInterpolator { t in
        clampAndNormalize(34.61 + t * (1172.33 - t * (10793.56 - t * (33300.12 - t * (38394.49 - t * 14825.05)))))
    } g: { t in
        clampAndNormalize(23.31 + t * (557.33 + t * (1225.33 - t * (3574.96 - t * (1073.77 + t * 707.56)))))
    } b: { t in
        clampAndNormalize(27.2 + t * (3211.1 - t * (15327.97 - t * (27814 - t * (22569.18 - t * 6838.66)))))
    }

    // Equation ported from
    // https://github.com/d3/d3-scale-chromatic/blob/main/src/sequential-multi/sinebow.js
    // Copyright 2010-2021 Mike Bostock, used under License

    internal static let Sinebow = ComputedRGBInterpolator { t in
        let tMod = (0.5 - t) * Double.pi
        return sin(tMod) * sin(tMod)
    } g: { t in
        let tMod = (0.5 - t) * Double.pi
        return sin(tMod + Double.pi / 3.0) * sin(tMod + Double.pi / 3.0)
    } b: { t in
        let tMod = (0.5 - t) * Double.pi
        return sin(tMod + 2 * Double.pi / 3.0) * sin(tMod + 2 * Double.pi / 3.0)
    }
}
