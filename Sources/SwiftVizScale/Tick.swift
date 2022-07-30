//
//  Tick.swift
//

import Foundation

/// A  visual representation of a point along an axis.
///
/// When created based on a range, a tick includes a location along a single direction
/// and a textual representation. It is meant to be created using a Scale, with some input domain
/// being mapped to visualization using the Scale's output range.
public struct Tick<OutputType: BinaryFloatingPoint> {
    /// The location where the tick should be placed within a chart's range.
    public let rangeLocation: OutputType

    /// The string value for the tick.
    public let label: String

    // Testing interface to make it "easier" to reverse the value into a numeric type
    var value: Double? {
        Double(label)
    }

    /// Creates a new tick.
    ///
    /// If the location value you provide is NaN, the initializer returns nil.
    /// - Parameters:
    ///   - value: The value at the tick's location.
    ///   - location: The location of the tick within the range for a scale.
    public init?<T>(value: T, location: OutputType, formatter: Formatter? = nil) where OutputType: BinaryFloatingPoint {
        if location.isNaN {
            return nil
        } else {
            rangeLocation = location
        }
        if let formatter = formatter {
            label = formatter.string(for: value) ?? ""
        } else {
            label = String("\(value)")
        }
    }
}
