//
//  ReversibleScale.swift
//

/// A type that maps values from an input _domain_ to an output _range_, or reversed from an output _range_ to a corresponding _domain_ value.
public protocol ReversibleScale: Scale {
    /// The type used for the scale's range.
    associatedtype RangeType: ConvertibleWithDouble

    /// Converts back from the output _range_ to a value within the input _domain_.
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
}
