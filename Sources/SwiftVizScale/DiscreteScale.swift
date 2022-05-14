//
//  DiscreteScale.swift
//

import Foundation

/// The type of discrete scale.
public enum DiscreteScaleType: Equatable {
    /// A discrete scale that returns a point for the scaled value.
    case point
    /// A discrete scale that returns a band for the scaled value.
    case band

    var description: String {
        switch self {
        case .point:
            return "point"
        case .band:
            return "band"
        }
    }
}

/// A type that maps discrete values of an input _domain_ to an output _range_.
public protocol DiscreteScale: Scale, CustomStringConvertible {
    var scaleType: DiscreteScaleType { get }
    /// The lower value of the range into which the discrete values map.
    var rangeLower: RangeType? { get }
    /// The upper value of the range into which the discrete values map.
    var rangeHigher: RangeType? { get }

    /// An array of the types the scale maps into.
    var domain: [InputType] { get }

    /// Returns an array of the strings that make up the ticks for the scale.
    /// - Parameter formatter: An optional formatter to convert the domain values into strings.
    func defaultTickValues(formatter: Formatter?) -> [String]

    /// Returns an array of the locations within the output range to locate ticks for the scale.
    /// - Parameters:
    ///   - rangeLower: the lower value for the range into which to position the ticks.
    ///   - rangeHigher: The higher value for the range into which to position the ticks.
    ///   - formatter: An optional formatter to convert the domain values into strings.
    func ticks(rangeLower: RangeType, rangeHigher: RangeType, formatter: Formatter?) -> [Tick<RangeType>]
}
