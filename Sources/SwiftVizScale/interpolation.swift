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
