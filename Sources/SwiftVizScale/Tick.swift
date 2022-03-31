//
//  Tick.swift
//
//
//  Created by Joseph Heck on 3/2/20.
//

import Foundation
import Numerics

/// A  visual representation of a point along an axis.
///
/// When created based on a range, a tick includes a location along a single direction
/// and a textual representation. It is meant to be created using a Scale, with some input domain
/// being mapped to visualization using the Scale's output range.
public struct Tick<InputType, OutputType: Numeric>: Identifiable where OutputType: Comparable {
    // this becomes a generic focused protocol - types implementing it will need to define the
    // protocol conformance in coordination with a generic type
    /// A unique identifier for the tick instance.
    public var id: UUID = .init()

    /// The value of the tick.
    public let value: InputType
    /// The location where the tick should be placed within a chart's range.
    public let rangeLocation: OutputType

    public let formatter: Formatter?

    public var label: String {
        guard let formatter = formatter else {
            return String("\(value)")
        }
        return formatter.string(for: value) ?? ""
    }

    /// Creates a new tick
    /// - Parameters:
    ///   - value: The value at the tick's location.
    ///   - location: The location of the tick within the range for a scale.
    public init(value: InputType, location: OutputType, formatter: Formatter? = nil) {
        self.value = value
        rangeLocation = location
        self.formatter = formatter
    }

    /// Creates a new tick.
    ///
    /// If the location value you provide is NaN, the initializer returns nil.
    /// - Parameters:
    ///   - value: The value at the tick's location.
    ///   - location: The location of the tick within the range for a scale.
    public init?(value: InputType, location: OutputType, formatter: Formatter? = nil) where OutputType: Real {
        self.value = value
        self.formatter = formatter
        if location.isNaN {
            return nil
        } else {
            rangeLocation = location
        }
    }
}
