//
//  ConvertibleWithDouble.swift
//
//
//  Created by Joseph Heck on 3/31/22.
//

import Foundation

// defines explicitly how we're casting from one comparable, numeric type to another...
// and which types are ultimately supported for scaling
public protocol ConvertibleWithDouble: Numeric, Comparable {
    func toDouble() -> Double
    static func fromDouble(_: Double) -> Self
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
