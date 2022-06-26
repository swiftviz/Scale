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
    var colors: [CGColor]

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

    static let white = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
    static let black = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
    static let red = CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)
    static let blue = CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 1)
    static let green = CGColor(srgbRed: 0, green: 1, blue: 0, alpha: 1)

    /// An interpolator that maps to various shades between white to black.
    public static let Grays = Self(white, black)
    /// An interpolator that maps to various shades between white to blue.
    public static let Blues = Self(white, blue)
    /// An interpolator that maps to various shades between white to green.
    public static let Greens = Self(white, green)
    /// An interpolator that maps to various shades between white and red.
    public static let Reds = Self(white, red)
}
