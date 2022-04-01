//
//  ConvertibleWithDouble.swift
//
//
//  Created by Joseph Heck on 3/31/22.
//

import Foundation

/// A type that can be consistently converted to and from a Double.
///
/// The protocol is used to constrain the types used within a scale and provide consistent casting for generic scale methods.
/// This library provides support for the types `Int`, `Float`, `CGFloat`, and `Double`.
public protocol ConvertibleWithDouble: Numeric, Comparable {
    /// Converts a value of the type into an instance of `Double`
    /// - Returns: A double value matching the value you provided.
    func toDouble() -> Double

    /// Converts the value from the current type into a Double.
    /// - Parameter value: A value of the current type
    /// - Returns: A value of the current type converted from `Double`, rounded down if necessary.
    static func fromDouble(_ value: Double) -> Self
}

extension Int: ConvertibleWithDouble {
    public func toDouble() -> Double {
        Double(self)
    }

    public static func fromDouble(_ x: Double) -> Int {
        Int(x.rounded(.down))
    }
}

extension Float: ConvertibleWithDouble {
    public func toDouble() -> Double {
        Double(self)
    }

    public static func fromDouble(_ x: Double) -> Float {
        Float(x)
    }
}

extension CGFloat: ConvertibleWithDouble {
    public func toDouble() -> Double {
        Double(self)
    }

    public static func fromDouble(_ x: Double) -> CGFloat {
        CGFloat(x)
    }
}

extension Double: ConvertibleWithDouble {
    public func toDouble() -> Double {
        self
    }

    public static func fromDouble(_ x: Double) -> Double {
        x
    }
}
