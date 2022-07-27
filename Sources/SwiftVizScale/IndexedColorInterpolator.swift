//
//  ColorInterpolator.swift
//

import CoreGraphics

public struct LCHColorInterpolator: ColorInterpolator {
    let startColor: CGColor
    let endColor: CGColor

    /// Creates a new color interpolator that maps between the two colors you provide.
    /// - Parameters:
    ///   - from: The color at the beginning.
    ///   - to: The color at the end.
    public init(_ from: CGColor, _ to: CGColor) {
        startColor = from
        endColor = to
    }

    /// Returns the color mapped from the unit value you provide.
    /// - Parameter t: A unit value between `0` and  `1`.
    public func interpolate(_ t: Double) -> CGColor {
        LCH.interpolate(startColor, endColor, t: t)
    }
}

/// An interpolator that maps a unit value into a color based on the position between the colors.
@available(watchOS 6.0, *)
public struct IndexedColorInterpolator: ColorInterpolator {
    // Color pallets for interpolation and presentation:
    // https://github.com/d3/d3-scale-chromatic/blob/main/README.md
    // https://bids.github.io/colormap/
    var colors: [CGColor]

    private static var lab = CGColorSpace(name: CGColorSpace.genericLab)!

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

    private static func color(from components: [CGFloat], using colorspace: CGColorSpace) -> CGColor {
        CGColor(colorSpace: colorspace, components: components)!
    }

    private static func components(from color: CGColor, for colorspace: CGColorSpace) -> [CGFloat] {
        let convertedColor = color.converted(to: colorspace, intent: .perceptual, options: nil)!
        let components = convertedColor.components!
        return components
    }

    internal static func interpolate(_ color1: CGColor, _ color2: CGColor, t: CGFloat, using colorspace: CGColorSpace) -> CGColor {
        precondition(t >= 0 && t <= 1)
        let components1 = components(from: color1, for: colorspace)
        let components2 = components(from: color2, for: colorspace)
        let newComponents = [
            components1[0] + (components2[0] - components1[0]) * t,
            components1[1] + (components2[1] - components1[1]) * t,
            components1[2] + (components2[2] - components1[2]) * t,
            components1[3] + (components2[3] - components1[3]) * t,
        ]
        return color(from: newComponents, using: colorspace)
    }

    /// Returns the color mapped from the unit value you provide.
    /// - Parameter t: A unit value between `0` and  `1`.
    public func interpolate(_ t: Double) -> CGColor {
        let (colorIndex, tBetweenIndices) = Self.interpolateIntoSteps(t, colors.count)
        // For the hex color sequences from D3 - we *don't* want to interpolate through LCH space,
        // but instead through regular LAB space. The colors were chosen with the direct LAB space in mind, not
        // the polar coordinate variation.
        return IndexedColorInterpolator.interpolate(colors[colorIndex], colors[colorIndex + 1], t: tBetweenIndices, using: Self.lab)
    }

    /// Creates a new color interpolator that maps between the colors you provide.
    /// - Parameters:
    ///   - colors: The sequences of colors to map through.
    public init(_ colors: [CGColor]) {
        precondition(colors.count >= 2, "ColorInterpolator requires at least 2 colors.")
        self.colors = colors
    }

    /// Creates a new color interpolator using sequences of 6 Hex Digits to represent a color.
    /// - Parameter hexSequence: The sequence to convert into the colors.
    public init(_ hexSequence: String) {
        precondition(hexSequence.count >= 12)
        let colors = CGColor.fromHexSequence(hexSequence)
        self.init(colors)
    }
}
