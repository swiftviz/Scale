//
//  ContinuousScaleType.swift
//

import Foundation

/// The type of continuous scale.
public enum ContinuousScaleType: Equatable {
    /// A linear continuous scale.
    case linear
    /// A logarithmic continuous scale.
    case log
    /// An exponential continuous scale.
    case power(Double)
    /// A linear continuous scale that squares the result.
    case radial

    var description: String {
        switch self {
        case .linear:
            "linear"
        case .log:
            "log"
        case let .power(exp):
            "power(\(exp))"
        case .radial:
            "radial"
        }
    }

    var transform: (Double) -> Double {
        switch self {
        case .log:
            { log10($0) }
        case .linear, .radial:
            { $0 }
        case let .power(exp):
            { pow($0, exp) }
        }
    }

    var invertedTransform: (Double) -> Double {
        switch self {
        case .log:
            { pow(10, $0) }
        case .linear, .radial:
            { $0 }
        case let .power(exp):
            { pow($0, 1.0 / exp) }
        }
    }
}
