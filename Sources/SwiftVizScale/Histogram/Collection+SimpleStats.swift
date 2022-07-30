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

extension Collection where Element: BinaryFloatingPoint {
    public var sum: Double {
        self.reduce(0.0) { $0 + Double($1) }
    }
    public var sumSquared: Double {
        self.reduce(0.0) { $0 + Double($1) * Double($1) }
    }
    public var avg: Double {
        guard self.count > 0 else { return 0 }
        return self.sum / Double(self.count)
    }
    public var stdDev: Double? {
        guard self.count > 1 else { return nil }
        let c = Double(self.count)
        let sum = self.sum
        let s2: Double = (c * sumSquared - sum * sum) / (c * (c - 1))
        return s2.squareRoot()
    }
}

extension Collection where Element: BinaryInteger {
    public var sum: Double {
        self.reduce(0.0) { $0 + Double($1) }
    }
    public var sumSquared: Double {
        self.reduce(0.0) { $0 + Double($1) * Double($1) }
    }
    public var avg: Double {
        guard self.count > 0 else { return 0 }
        return self.sum / Double(self.count)
    }
    public var stdDev: Double? {
        guard self.count > 1 else { return nil }
        let c = Double(self.count)
        let sum = self.sum
        let s2: Double = (c * sumSquared - sum * sum) / (c * (c - 1))
        return s2.squareRoot()
    }
}
