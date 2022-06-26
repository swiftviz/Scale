//
//  SequentialScale.swift
//

import CoreGraphics
import Foundation

/// A type that maps values from a continuous input _domain_ to a color.
public struct SequentialScale<InputType: ConvertibleWithDouble>: CustomStringConvertible {
    /// The lower bound of the input domain.
    public let domainLower: InputType
    /// The upper bound of the input domain.
    public let domainHigher: InputType
    /// A Boolean value that indicates if the mapping from domain to range is inverted.
    public let reversed: Bool

    let interpolator: ArrayInterpolator

    /// Creates a new sequential scale that maps a _domain_ value to a color.
    /// - Parameters:
    ///   - lower: The lowest value expected for the scale.
    ///   - higher: The highest value expected for the scale.
    ///   - reversed: A Boolean value that indicates the color range is reversed.
    ///   - interpolator: The interpolator that provides the color range to map.
    public init(lower: InputType = 0,
                higher: InputType = 1,
                reversed: Bool = false,
                interpolator: ArrayInterpolator)
    {
        precondition(lower <= higher, "attempting to set an inverted domain: \(lower) to \(higher)")
        precondition(lower != higher, "attempting to set an empty domain: \(lower) to \(higher)")
        domainLower = lower
        domainHigher = higher
        self.reversed = reversed
        self.interpolator = interpolator
    }

    // MARK: - description

    public var description: String {
        "sequential[\(domainLower):\(domainHigher)]->\(type(of: interpolator)))"
    }

    // MARK: - scaling

    /// Converts a value comparing it to the input domain, transforming the value, and mapping it between the range values you provide.
    ///
    /// - Parameter inputValue: The value to be scaled.
    /// - Returns: A value within the bounds of the range values you provide, or `nil` if the value was dropped.
    public func scale(_ x: InputType) -> CGColor {
        let clampedX: InputType
        if x < domainLower {
            clampedX = domainLower
        } else if x > domainHigher {
            clampedX = domainHigher
        } else {
            clampedX = x
        }
        let t = normalize(clampedX.toDouble(), lower: domainLower.toDouble(), higher: domainHigher.toDouble())
        return interpolator.interpolate(t)
    }

    // MARK: - modifier functions

    /// Returns a new scale with the interpolator set to the instance you provide.
    /// - Parameter interpolator: An interpolator instance.
    /// - Returns: A copy of the scale with the domain values you provide.
    public func interpolator(_ interpolator: ArrayInterpolator) -> Self {
        Self(lower: domainLower, higher: domainHigher, reversed: reversed, interpolator: interpolator)
    }

    /// Returns a new scale with the domain set to the values you provide.
    /// - Parameters:
    ///   - lower: The lower bound for the scale's domain.
    ///   - higher: The upper bound for the scale's domain.
    /// - Returns: A copy of the scale with the domain values you provide.
    public func domain(lower: InputType, higher: InputType) -> Self {
        Self(lower: lower, higher: higher, reversed: reversed, interpolator: interpolator)
    }

    /// Returns a new scale with the domain set to the values you provide.
    /// - Parameters:
    ///   - range: The range to apply as the scale's domain
    /// - Returns: A copy of the scale with the domain values you provide.
    public func domain(_ range: ClosedRange<InputType>) -> Self {
        Self(lower: range.lowerBound, higher: range.upperBound, reversed: reversed, interpolator: interpolator)
    }

    /// Returns a new scale with the domain set to span the values you provide.
    /// - Parameter values: An array of input values.
    public func domain(_ values: [InputType]) -> Self {
        domain(values, nice: true)
    }

    /// Returns a new scale with the domain inferred from the list of values you provide.
    /// - Parameters:
    ///   - values: The list of values to use to determine the scale's domain.
    ///   - nice: A Boolean value that indicates whether to expand the domain to visually nice values.
    /// - Returns: A copy of the scale with the domain values you provide.
    public func domain(_ values: [InputType], nice: Bool) -> Self {
        guard let min = values.min(), let max = values.max() else {
            return self
        }
        if values.count == 1 || min == max {
            if nice {
                let bottom: Double = 0
                let top = Double.niceVersion(for: max.toDouble(), trendTowardsZero: false)
                return domain(lower: InputType.fromDouble(bottom), higher: InputType.fromDouble(top))
            } else {
                return domain(lower: 0, higher: max)
            }
        } else {
            if nice {
                let bottom = Double.niceMinimumValueForRange(min: min.toDouble(), max: max.toDouble())
                let top = Double.niceVersion(for: max.toDouble(), trendTowardsZero: false)
                return domain(lower: InputType.fromDouble(bottom), higher: InputType.fromDouble(top))
            } else {
                return domain(lower: min, higher: max)
            }
        }
    }
}
