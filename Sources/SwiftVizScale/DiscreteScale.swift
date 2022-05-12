//
//  DiscreteScale.swift
//  

import Foundation

/// The type of continuous scale.
///
/// Exponential scales (``PowerScale``) require an additional value for the exponent of the scale.
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

public protocol DiscreteScale: Scale, CustomStringConvertible {
    var scaleType: DiscreteScaleType { get }
     func ticks(rangeLower: RangeType, rangeHigher: RangeType) -> [Tick<RangeType>]
}

extension DiscreteScale {
    public func ticks(rangeLower: RangeType, rangeHigher: RangeType) -> [Tick<RangeType>] {
        return []
    }
}
