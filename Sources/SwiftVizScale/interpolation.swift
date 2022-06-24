import Numerics

// MARK: - general functions used in various implementations of Scale

/// normalize(x, a ... b) takes a value x and normalizes it across the domain a...b
/// It returns the corresponding parameter within the range [0...1] if it was within the domain of the scale
/// If the value provided is outside of the domain of the scale, the resulting normalized value will be extrapolated
func normalize<T: Real>(_ x: T, lower: T, higher: T) -> T {
    precondition(lower < higher)
    let extent = higher - lower
    return (x - lower) / extent
}

/// interpolate(a, b)(t) takes a parameter t in [0,1] and
/// returns the corresponding range value t in [a,b].
func interpolate<T: Real>(_ t: T, lower: T, higher: T) -> T {
    // strict interpolation would require: precondition(t >= 0 && t <= 1)
    lower + (higher - lower) * t
}

/// A type that provides an interpolated result types between two corresponding instances.
public protocol Interpolator {
    /// The type that the interpolator accepts as instances, and returns as an interpolated result.
    associatedtype OutputType
    /// Provide an instance that is the interpolated value between two others.
    /// - Parameter t: A unit value between `0` and `1` that represents the distance between the two values.
    /// - Returns: An instance of a type that is the interpolated result based on the value you provide.
    func interpolate(_ t: Double) -> OutputType
}

import CoreGraphics
public struct Blues: Interpolator {
    public func interpolate(_ t: Double) -> CGColor {
        precondition(t >= 0 && t <= 1)
        return LCH.interpolate(CGColor.white,
                               CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 1),
                               t: t)
    }
}

// blue
// green
// gray
// orange
// purple
// red

// Color pallets for interpolation and presentation:
// https://github.com/d3/d3-scale-chromatic/blob/main/README.md

public struct ArrayInterpolator: Interpolator {
    var colors: [CGColor]

    func interpolateIntoSteps(_ t: Double, _ count: Int) -> (Int, Int, Double) {
        precondition(t >= 0 && t <= 1)
        precondition(count > 1)

        // take the unit value (t) between 0...1 and determine the lower index
        // value from the array that it should reference.
        let lowerIndex = max(0, min(count - 1, Int(floor(t * Double(count)))))
        // Calculate the step size for each index evenly dividing the space by the number
        // of elements.
        let step = 1.0 / Double(count - 1)
        // Calculate the unit-value for the two index steps
        let lowerIndexTValue = 0 + step * Double(lowerIndex)
        let upperIndexTValue = 0 + step * Double(lowerIndex + 1)
        // Determine a new unit-value that is the original 't' value interpolated between
        // the relevant steps.
        let tValueBetweenSteps = normalize(t, lower: lowerIndexTValue, higher: upperIndexTValue)
        return (lowerIndex, lowerIndex + 1, tValueBetweenSteps)
    }

    public func interpolate(_ t: Double) -> CGColor {
        let (index1, index2, tBetweenIndicies) = interpolateIntoSteps(t, colors.count)
        return LCH.interpolate(colors[index1], colors[index2], t: tBetweenIndicies)
    }

    public init(_ from: CGColor, _ to: CGColor) {
        colors = [from, to]
    }

    public static let Grays = Self(CGColor.white,
                                   CGColor.black)
    public static let Blues = Self(CGColor.white,
                                   CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 1))
    public static let Greens = Self(CGColor.white,
                                    CGColor(srgbRed: 0, green: 1, blue: 0, alpha: 1))
    public static let Reds = Self(CGColor.white,
                                  CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1))
}
