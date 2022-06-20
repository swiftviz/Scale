//
//  ContinuousScaleType.swift
//

/// The type of continuous scale.
///
/// Exponential scales (``PowerScale``) require an additional value for the exponent of the scale.
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
            return "linear"
        case .log:
            return "log"
        case let .power(exp):
            return "power(\(exp))"
        case .radial:
            return "radial"
        }
    }

    var transform: (Double) -> Double {
        switch self {
        case .log:
            return { Double.log($0) }
        case .linear, .radial:
            return { $0 }
        case let .power(exp):
            return { Double.pow($0, exp) }
        }
    }

    var invertedTransform: (Double) -> Double {
        switch self {
        case .log:
            return { Double.pow(10, $0) }
        case .linear, .radial:
            return { $0 }
        case let .power(exp):
            return { Double.pow($0, 1.0 / exp) }
        }
    }
}
