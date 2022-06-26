//
//  ArrayInterpolator.swift
//

import CoreGraphics

public struct ArrayInterpolator: Interpolator {
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

    public func interpolate(_ t: Double) -> CGColor {
        let (colorIndex, tBetweenIndicies) = Self.interpolateIntoSteps(t, colors.count - 1)
        return LCH.interpolate(colors[colorIndex], colors[colorIndex + 1], t: tBetweenIndicies)
    }

    public init(_ from: CGColor, _ to: CGColor) {
        colors = [from, to]
    }

    static let white = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
    static let black = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
    static let red = CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)
    static let blue = CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 1)
    static let green = CGColor(srgbRed: 0, green: 1, blue: 0, alpha: 1)

    public static let Grays = Self(white, black)
    public static let Blues = Self(white, blue)
    public static let Greens = Self(white, green)
    public static let Reds = Self(white, red)
}
