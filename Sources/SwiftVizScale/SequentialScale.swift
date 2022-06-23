//
//  SequentialScale.swift
//

import Foundation

/// A type that maps values from a continuous input _domain_ to an output _range_.
public struct SequentialScale<InputType: ConvertibleWithDouble, OutputType>: Scale, CustomStringConvertible {
    /// Converts a value comparing it to the input domain, transforming the value, and mapping it between the range values you provide.
    ///
    /// - Parameter inputValue: The value to be scaled.
    /// - Returns: A value within the bounds of the range values you provide, or `nil` if the value was dropped.
    public func scale(_: InputType) -> OutputType? {
        nil
    }

    // MARK: - modifier functions

    /// Returns a new scale with the domain set to the span of values you provide.
    /// - Parameter values: An array of input values.
    public func domain(_: [InputType]) -> Self {
        self
    }

    public var description: String {
        "A SEQUENTIAL SCALE"
    }
}
