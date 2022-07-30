//
//  RandomAccessCollection+SimpleStats.swift
//

import Foundation

// for more advanced statistics, consider: https://swiftpackageindex.com/evgenyneu/SigmaSwiftStatistics

public extension Collection {
    func pairs() -> AnySequence<(Element, Element)> {
        AnySequence(zip(self, dropFirst()))
    }
}

public extension Collection where Element: BinaryFloatingPoint {
    var sum: Double {
        reduce(0.0) { $0 + Double($1) }
    }

    var sumSquared: Double {
        reduce(0.0) { $0 + Double($1) * Double($1) }
    }

    var avg: Double {
        guard count > 0 else { return 0 }
        return sum / Double(count)
    }

    var stdDev: Double? {
        guard count > 1 else { return nil }
        let c = Double(count)
        let sum = sum
        let s2: Double = (c * sumSquared - sum * sum) / (c * (c - 1))
        return s2.squareRoot()
    }
}

public extension Collection where Element: BinaryInteger {
    var sum: Double {
        reduce(0.0) { $0 + Double($1) }
    }

    var sumSquared: Double {
        reduce(0.0) { $0 + Double($1) * Double($1) }
    }

    var avg: Double {
        guard count > 0 else { return 0 }
        return sum / Double(count)
    }

    var stdDev: Double? {
        guard count > 1 else { return nil }
        let c = Double(count)
        let sum = sum
        let s2: Double = (c * sumSquared - sum * sum) / (c * (c - 1))
        return s2.squareRoot()
    }
}
