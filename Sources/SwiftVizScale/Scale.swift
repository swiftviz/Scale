//
//  Scale.swift
//
//
//  Created by Joseph Heck on 4/2/22.
//

/// A type that maps values from an input _domain_ to an output _range_.
public protocol Scale {
    /// The type used for the scale's domain.
    associatedtype InputType: Comparable
    /// The type used for the scale's range.
    associatedtype RangeType: ConvertibleWithDouble
    /// The type used for the scale's output.
    associatedtype OutputType

    /// Converts a value comparing it to the input domain, transforming the value, and mapping it between the range values you provide.
    ///
    /// Before scaling the value, the scale may transform or drop the value based on the setting of ``ContinuousScaleProtocol/transformType``.
    ///
    /// - Parameter inputValue: The value to be scaled.
    /// - Returns: A value within the bounds of the range values you provide, or `nil` if the value was dropped.
    func scale(_ domainValue: InputType) -> OutputType?

    /// Converts back from the output _range_ to a value within the input _domain_.
    ///
    /// The inverse of ``ContinuousScaleProtocol/scale(_:from:to:)``.
    /// After converting the data back to the domain range, the scale may transform or drop the value based on the setting of ``ContinuousScaleProtocol/transformType``.
    ///
    /// - Parameter rangeValue: The value to be scaled back from the range values to the domain.
    /// - Returns: A value within the bounds of the range values you provide, or `nil` if the value was dropped.
    func invert(_ rangeValue: OutputType) -> InputType?

    // MARK: - modifier functions

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    ///   - lower: The lower value of the range into which the discrete values map.
    ///   - higher: The upper value of the range into which the discrete values map.
    func range(reversed: Bool, lower: RangeType, higher: RangeType) -> Self

    /// Returns a new scale with the range set to the range you provide.
    /// - Parameter reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    /// - Parameter range: The range of the values into which the discrete values map.
    func range(reversed: Bool, _ range: ClosedRange<RangeType>) -> Self

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - from: The lower value of the range into which the discrete values map.
    ///   - to: The upper value of the range into which the discrete values map.
    func range(lower: RangeType, higher: RangeType) -> Self

    /// Returns a new scale with the range set to the range you provide.
    /// - Parameter range: The range of the values into which the discrete values map.
    func range(_ range: ClosedRange<RangeType>) -> Self

    /// Returns a new scale with the domain set to span the values you provide.
    /// - Parameter values: An array of input values.
    func domain(_ values: [InputType]) -> Self
}

// Quantize scale: Quantize scales use a discrete range and a
// continuous domain. Range mapping is done by dividing the domain
// evenly by the number of elements in the range. Because the range
// is discrete, the values do not have to be numbers.

// Quantile scale: Quantile scales are similar to quantize scales,
// but instead of evenly dividing the domain, they determine threshold
// values based on the domain that are used as the cutoffs between
// values in the range. Quantile scales take an array of values for a
// domain (not just a lower and upper limit) and maps range to be an
// even distribution over the input domain
