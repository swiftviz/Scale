//
//  ArrayInterpolator.swift
//

import CoreGraphics

///// A type that provides an interpolated result types between two corresponding instances.
// public protocol Interpolator {
//    /// The type that the interpolator accepts as instances, and returns as an interpolated result.
//    associatedtype OutputType
//    /// Provide an instance that is the interpolated value between two others.
//    /// - Parameter t: A unit value between `0` and `1` that represents the distance between the two values.
//    /// - Returns: An instance of a type that is the interpolated result based on the value you provide.
//    func interpolate(_ t: Double) -> OutputType
// }

/// An interpolator that maps a unit value into a color based on the position between the colors.
public struct ArrayInterpolator {
    // Color pallets for interpolation and presentation:
    // https://github.com/d3/d3-scale-chromatic/blob/main/README.md
    // https://bids.github.io/colormap/
    var colors: [CGColor]

    /// Returns an index and re-normalized interpolation value to be able to step-wise interpolate through an array of options.
    /// - Parameters:
    ///   - t: The unit value to interpolate into and between the array elements
    ///   - count: The number of elements in the array
    static func interpolateIntoSteps(_ t: Double, _ count: Int) -> (Int, Double) {
        precondition(t >= 0 && t <= 1)
        precondition(count > 1)
        // Calculate the step size for each index evenly dividing the space by the number
        // of elements.
        let step = 1.0 / Double(count - 1)
        // take the unit value (t) between 0...1 and determine the lower index
        // value from the array that it should reference.
        let lowerIndex: Int
        if t == 1.0 {
            lowerIndex = count - 2
        } else {
            lowerIndex = Int(floor(t / step))
        }
        // Calculate the unit-value for the two index steps
        let lowerIndexTValue = step * Double(lowerIndex)
        let upperIndexTValue = step * Double(lowerIndex + 1)
        // Determine a new unit-value that is the original 't' value interpolated between
        // the relevant steps.
        let tValueBetweenSteps = normalize(t, lower: lowerIndexTValue, higher: upperIndexTValue)
        return (lowerIndex, tValueBetweenSteps)
    }

    /// Returns the color mapped from the unit value you provide.
    /// - Parameter t: A unit value between `0` and  `1`.
    public func interpolate(_ t: Double) -> CGColor {
        let (colorIndex, tBetweenIndicies) = Self.interpolateIntoSteps(t, colors.count - 1)
        return LCH.interpolate(colors[colorIndex], colors[colorIndex + 1], t: tBetweenIndicies)
    }

    /// Creates a new color interpolator that maps between the two colors you provide.
    /// - Parameters:
    ///   - from: The color at the beginning.
    ///   - to: The color at the end.
    public init(_ from: CGColor, _ to: CGColor) {
        colors = [from, to]
    }

    /// Creates a new color interpolator that maps between the colors you provide.
    /// - Parameters:
    ///   - colors: The sequences of colors to map through.
    public init(_ colors: [CGColor]) {
        precondition(colors.count > 2, "ArrayInterpolator requires at least 2 colors.")
        self.colors = colors
    }

    public init(_ hexSequence: String) {
        precondition(hexSequence.count >= 12)
        let colors = CGColor.fromHexSequence(hexSequence)
        self.init(colors)
    }

    static let white = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
    static let black = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
    static let red = CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)
    static let blue = CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 1)
    static let green = CGColor(srgbRed: 0, green: 1, blue: 0, alpha: 1)

    // MARK: - Diverging Color Schemes, replicated from d3-scale-chromatic

    // https://github.com/d3/d3-scale-chromatic/blob/main/src/diverging/BrBG.js
    public static let BrBG = Self("5430058c510abf812ddfc27df6e8c3f5f5f5c7eae580cdc135978f01665e003c30")
    // https://github.com/d3/d3-scale-chromatic/blob/main/src/diverging/PRGn.js
    public static let PrGN = Self("40004b762a839970abc2a5cfe7d4e8f7f7f7d9f0d3a6dba05aae611b783700441b")
    // https://github.com/d3/d3-scale-chromatic/blob/main/src/diverging/PiYG.js
    public static let PiYG = Self("8e0152c51b7dde77aef1b6dafde0eff7f7f7e6f5d0b8e1867fbc414d9221276419")
    // https://github.com/d3/d3-scale-chromatic/blob/main/src/diverging/PuOr.js
    public static let PuOR = Self("2d004b5427888073acb2abd2d8daebf7f7f7fee0b6fdb863e08214b358067f3b08")
    // https://github.com/d3/d3-scale-chromatic/blob/main/src/diverging/RdBu.js
    public static let RdBu = Self("67001fb2182bd6604df4a582fddbc7f7f7f7d1e5f092c5de4393c32166ac053061")
    // https://github.com/d3/d3-scale-chromatic/blob/main/src/diverging/RdGy.js
    public static let RdGy = Self("67001fb2182bd6604df4a582fddbc7ffffffe0e0e0bababa8787874d4d4d1a1a1a")
    // https://github.com/d3/d3-scale-chromatic/blob/main/src/diverging/RdYlBu.js
    public static let RdYlBu = Self("a50026d73027f46d43fdae61fee090ffffbfe0f3f8abd9e974add14575b4313695")
    // https://github.com/d3/d3-scale-chromatic/blob/main/src/diverging/RdYlGn.js
    public static let RdYlGn = Self("a50026d73027f46d43fdae61fee08bffffbfd9ef8ba6d96a66bd631a9850006837")
    // https://github.com/d3/d3-scale-chromatic/blob/main/src/diverging/Spectral.js
    public static let Spectral = Self("9e0142d53e4ff46d43fdae61fee08bffffbfe6f598abdda466c2a53288bd5e4fa2")

    /// An interpolator that maps to various shades between white to black.
    public static let Grays = Self(white, black)
    /// An interpolator that maps to various shades between white to blue.
    public static let Blues = Self(white, blue)
    /// An interpolator that maps to various shades between white to green.
    public static let Greens = Self(white, green)
    /// An interpolator that maps to various shades between white and red.
    public static let Reds = Self(white, red)
}
