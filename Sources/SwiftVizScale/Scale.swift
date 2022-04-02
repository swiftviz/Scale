//
//  Scale.swift
//
//
//  Created by Joseph Heck on 4/2/22.
//

/// A type that maps values from an input _domain_ to an output _range_.
public protocol Scale {
    /// The type used for the scale's domain.
    associatedtype InputType
    /// The type used for the scale's range.
    associatedtype OutputType

    /// Converts a value comparing it to the input domain, transforming the value, and mapping it between the range values you provide.
    ///
    /// Before scaling the value, the scale may transform or drop the value based on the setting of ``ContinuousScale/transformType``.
    ///
    /// - Parameter inputValue: The value to be scaled.
    /// - Returns: A value within the bounds of the range values you provide, or `nil` if the value was dropped.
    func scale(_ domainValue: InputType) -> OutputType?

    /// Converts back from the output _range_ to a value within the input _domain_.
    ///
    /// The inverse of ``ContinuousScale/scale(_:from:to:)``.
    /// After converting the data back to the domain range, the scale may transform or drop the value based on the setting of ``ContinuousScale/transformType``.
    ///
    /// - Parameter rangeValue: The value to be scaled back from the range values to the domain.
    /// - Returns: A value within the bounds of the range values you provide, or `nil` if the value was dropped.
    func invert(_ rangeValue: OutputType) -> InputType?
}
