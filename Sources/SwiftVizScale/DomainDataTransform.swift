//
//  DomainDataTransform.swift
//

/// A value that represents how a scale handles data transformation that exceed the domain or range of the scale.
public enum DomainDataTransform {
    /// Data processed against a scale isn't influenced by the scale's domain.
    case none
    /// Data processed against a scale is dropped if the value is outside of the scale's domain.
    case drop
    /// Data processed against a scale is clamped to the upper and lower values of the scale's domain.
    case clamp

    var description: String {
        switch self {
        case .none:
            "none"
        case .drop:
            "drop"
        case .clamp:
            "clamp"
        }
    }
}
