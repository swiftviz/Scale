//
//  Histogram.swift
//

import Foundation
import OrderedCollections

// https://en.wikipedia.org/wiki/Histogram

// Choosing a "bin size" shows different features - smaller bins for higher density data is the gist of the
// desire. Picking the right size.. is something of an art.

// extension Sequence where Element: Hashable {
//    func histogram() -> [Element: Int] {
//        return self.reduce(into: [:]) { counts, elem in counts[elem, default: 0] += 1 }
//    }
// }

// Collection.bin -> Histogram(data: _)
// Collection.bin(stride: _) -> Histogram(data: self, stride: stride)

/// A histogram representing a distribution of numeric data.
public struct Histogram<Value: Numeric & Hashable & Comparable> {
    typealias InternalDictType = OrderedDictionary<HistogramBinRange<Value>, Int>
    private var _storage: InternalDictType

    /// The lowest value of the histogram's range.
    public var lowerBound: Value
    /// The highest value of the histogram's range.
    public var upperBound: Value
    /// A Boolean value that indicates of the histogram is empty.
    public var isEmpty: Bool

    // MARK: - Automatic (Scott's Rule) Initializers

    /// Automatically determine the bins from data.
    /// - Parameter data: The data to populate the histogram.
    public init(data: [Value]) where Value: BinaryInteger {
        _storage = [:]
        guard let stdDev = data.stdDev, let smallestValue = data.min(), let largestValue = data.max() else {
            lowerBound = 0
            upperBound = 0
            isEmpty = true
            return
        }
        isEmpty = false
        lowerBound = smallestValue
        upperBound = largestValue
        // As a default, use Scott's normal reference rule: 3.49 * stdDev / pow(n, 1/3) to select a uniform
        // bin size for the histogram, with the assumption that the distribution is roughly normal.
        let binSize = round(3.49 * stdDev / pow(Double(data.count), 1.0 / 3.0))
        let niceBinSize = Double.niceVersion(for: binSize, trendTowardsZero: true)

        // Create and initialize the keys for the bins with a count of 0
        var currentStep = smallestValue
        while currentStep < largestValue {
            let bin: HistogramBinRange<Value>
            if currentStep + Value(niceBinSize) > largestValue {
                bin = HistogramBinRange(lowerBound: currentStep, upperBound: largestValue, _final: true)
            } else {
                bin = HistogramBinRange(lowerBound: currentStep, upperBound: currentStep + Value(niceBinSize))
            }
            _storage[bin] = 0
            currentStep += Value(niceBinSize)
        }

        // Iterate through the data to insert everything into the histogram keyed by bin.
        populate(data)
    }

    /// Automatically determine the bins from data.
    /// - Parameter data: The data to populate the histogram.
    public init(data: [Value]) where Value: BinaryFloatingPoint {
        _storage = [:]
        guard let stdDev = data.stdDev, let smallestValue = data.min(), let largestValue = data.max() else {
            lowerBound = 0
            upperBound = 0
            isEmpty = true
            return
        }
        isEmpty = false
        lowerBound = smallestValue
        upperBound = largestValue

        // As a default, use Scott's normal reference rule: 3.49 * stdDev / pow(n, 1/3) to determine a uniform
        // bin size for the histogram.
        let binSize = 3.49 * stdDev / pow(Double(data.count), 1.0 / 3.0)
        let niceBinSize = Double.niceVersion(for: binSize, trendTowardsZero: true)

        // Create and initialize the keys for the bins with a count of 0
        var currentStep = smallestValue
        while currentStep < largestValue {
            let bin: HistogramBinRange<Value>
            if currentStep + Value(niceBinSize) > largestValue {
                bin = HistogramBinRange(lowerBound: currentStep, upperBound: largestValue, _final: true)
            } else {
                bin = HistogramBinRange(lowerBound: currentStep, upperBound: currentStep + Value(niceBinSize))
            }
            _storage[bin] = 0
            currentStep += Value(niceBinSize)
        }

        // Iterate through the data to insert everything into the histogram keyed by bin.
        populate(data)
    }

    // MARK: - Uniform Initializers

    /// Automatically determine the bins from data, constrained by a minimum bin size
    /// - Parameters:
    ///   - data: The data to populate the histogram.
    ///   - minimumStride: The minimum bin size to group the counts.
    ///   - bounds: The minimum and maximum value that the histogram supports.
    ///   - desiredCount: An optional value of the number of bins to create. If `nil`, the number of bins is determined by the minimum stride you provide.
    public init(data: [Value], minimumStride: Value, bounds: ClosedRange<Value>? = nil, desiredCount: Int? = nil) where Value: BinaryFloatingPoint {
        _storage = [:]
        guard let smallestValue = data.min(), let largestValue = data.max() else {
            lowerBound = 0
            upperBound = 0
            isEmpty = true
            return
        }
        isEmpty = true
        if let setBounds = bounds {
            lowerBound = setBounds.lowerBound
            upperBound = setBounds.upperBound
        } else {
            lowerBound = smallestValue
            upperBound = largestValue
        }
        // start by breaking down the data into discrete chunks - building the keys based on information
        // density, explicit values, or fixed widths,

        // default to using the provided minimum as the stride length for the histogram bins
        var stride = minimumStride
        if let desiredCount = desiredCount {
            // if a desired number of bins was provided, and a stride value evenly dividing the
            // data's range into those values is larger than the minimum, use that larger stride.
            let maybeStride = (upperBound - lowerBound) / Value(desiredCount)
            if maybeStride >= minimumStride {
                stride = maybeStride
            }
        }

        // Create and initialize the keys for the bins with a count of 0
        var currentStep = lowerBound
        while currentStep < upperBound {
            let bin: HistogramBinRange<Value>
            if currentStep + stride > upperBound {
                bin = HistogramBinRange(lowerBound: currentStep, upperBound: upperBound, _final: true)
            } else {
                bin = HistogramBinRange(lowerBound: currentStep, upperBound: currentStep + stride)
            }
            _storage[bin] = 0
            currentStep += stride
        }

        // Iterate through the data to insert everything into the histogram keyed by bin.
        populate(data)
    }

    /// Automatically determine the bins from data, constrained by a minimum bin size
    /// - Parameters:
    ///   - data: The data to populate the histogram.
    ///   - minimumStride: The minimum bin size to group the counts.
    ///   - bounds: The minimum and maximum value that the histogram supports.
    ///   - desiredCount: An optional value of the number of bins to create. If `nil`, the number of bins is determined by the minimum stride you provide.
    public init(data: [Value], minimumStride: Value, bounds: ClosedRange<Value>? = nil, desiredCount: Int? = nil) where Value: BinaryInteger {
        _storage = [:]
        guard let smallestValue = data.min(), let largestValue = data.max() else {
            lowerBound = 0
            upperBound = 0
            isEmpty = true
            return
        }
        isEmpty = false
        if let setBounds = bounds {
            lowerBound = setBounds.lowerBound
            upperBound = setBounds.upperBound
        } else {
            lowerBound = smallestValue
            upperBound = largestValue
        }
        // start by breaking down the data into discrete chunks - building the keys based on information
        // density, explicit values, or fixed widths,

        // default to using the provided minimum as the stride length for the histogram bins
        var stride = minimumStride
        if let desiredCount = desiredCount {
            // if a desired number of bins was provided, and a stride value evenly dividing the
            // data's range into those values is larger than the minimum, use that larger stride.
            let maybeStride = round((Double(upperBound) - Double(lowerBound)) / Double(desiredCount))
            if maybeStride >= Double(minimumStride) {
                stride = Value(maybeStride)
            }
        }

        // Create and initialize the keys for the bins with a count of 0
        var currentStep = lowerBound
        while currentStep < upperBound {
            let bin: HistogramBinRange<Value>
            if currentStep + stride > upperBound {
                bin = HistogramBinRange(lowerBound: currentStep, upperBound: upperBound, _final: true)
            } else {
                bin = HistogramBinRange(lowerBound: currentStep, upperBound: currentStep + stride)
            }
            _storage[bin] = 0
            currentStep += stride
        }

        // Iterate through the data to insert everything into the histogram keyed by bin.
        populate(data)
    }

    // MARK: - Explicit Thresholds, Non-uniform bin-size Initializers

    /// Explicitly build a histogram with the explicit thresholds you provide.
    ///
    /// Use this initializer to create a histogram with non-uniform bin sizes.
    /// The number of bins created is one less than the number of thresholds you provide.
    ///
    /// - Parameters:
    ///   - data: The data to populate the histogram.
    ///   - thresholds: The values to use as the thresholds for the bins.
    public init(data: [Value], thresholds: [Value]) {
        _storage = [:]
        let sortedThresholds = thresholds.sorted()
        guard let firstThreshold = sortedThresholds.first, let lastThreshold = sortedThresholds.last, data.count > 1, sortedThresholds.count > 1 else {
            lowerBound = 0
            upperBound = 0
            isEmpty = true
            return
        }
        isEmpty = false
        lowerBound = firstThreshold
        upperBound = lastThreshold

        // Create and initialize the keys for the bins with a count of 0
        for (lower, higher) in sortedThresholds.pairs() {
            let bin: HistogramBinRange<Value>
            if higher == lastThreshold {
                bin = HistogramBinRange(lowerBound: lower, upperBound: higher, _final: true)
            } else {
                bin = HistogramBinRange(lowerBound: lower, upperBound: higher)
            }
            _storage[bin] = 0
        }

        populate(data)
    }

    private mutating func populate(_ data: [Value]) {
        // Iterate through the data to insert everything into the histogram keyed by bin.
        for dataValue in data {
            if dataValue < lowerBound || dataValue > upperBound {
                break
            }
            // This could be improved (perf wise) by potentially doing a binary search
            // over keys, assuming OrderedDictionary.keys returns that nicely ordered
            // collection.
            if let key = _storage.keys.first(where: { bin in
                bin.contains(dataValue)
            }) {
                if let count = _storage[key] {
                    _storage[key] = count + 1
                } else {
                    _storage[key] = 1
                }
            }
        }
    }
}

extension Histogram: Sequence {
    // Sequence Conformance
    public typealias Element = (HistogramBinRange<Value>, Int)
    public typealias Iterator = HistogramIterator

    /// The type that allows iteration over an ordered dictionary's elements.
    @frozen
    public struct HistogramIterator: IteratorProtocol {
        @usableFromInline
        internal let _base: Histogram<Value>

        @usableFromInline
        internal var _position: Int

        @inlinable
        @inline(__always)
        internal init(_base: Histogram<Value>) {
            self._base = _base
            _position = 0
        }

        /// Advances to the next element and returns it, or nil if no next
        /// element exists.
        ///
        /// - Complexity: O(1)
        public mutating func next() -> Element? {
            guard _position < _base._storage.count else { return nil }
            let key = _base._storage.keys[_position]
            guard let valueAtKey = _base._storage[key] else { return nil }
            let result = (key, valueAtKey)
            _position += 1
            return result
        }
    }

    public func makeIterator() -> HistogramIterator {
        HistogramIterator(_base: self)
    }
}

extension Histogram: CustomStringConvertible {
    public var description: String {
        var strings: [String] = []
        for (binrange, bincount) in self {
            strings.append("\(binrange): \(bincount)")
        }
        return "[\(strings.joined(separator: ", "))]"
    }
}

// https://www.swiftbysundell.com/articles/creating-custom-collections-in-swift/
// OrderedDictionary *doesn't* conform to Collection itself, so we'd have to really screw with this...
//
// For Histogram to use HistogramBinRange as an index value, it would need to have an instance
// of that type that was specifically a placeholder in order to return it for startIndex and endIndex
// in the scenario where the collection was empty.
// If we used Int as the index, we'd have to return an Int, and would need an alternate path to get
// at the HistogramBinRange element.
// That said, I suspect it's likely just fine that we support Sequence for iterating through
// the values. I don't think we need random-access like collection.
//
//    // Required nested types, that tell Swift what our collection contains
//    public typealias Index = HistogramBinRange<Value>
//    //public typealias Element = (HistogramBinRange<Value>, Int)
//
//    var startIndex: Index {
//        guard let firstKey = _storage.keys.first else { return nil }
//        return firstKey
//    }
//    var endIndex: Index {
//        guard let lastKey = _storage.keys.last else { return nil }
//        return lastKey
//    }
//
//    subscript(index: Index) -> Histogram.Element {
//        get {
//            guard let valueAtKey = _storage[index] else { return nil }
//            let result = (index, valueAtKey)
//            return result
//        }
//    }
//
//    // Method that returns the next index when iterating
//    func index(after i: Index) -> HistogramBinRange<Value> {
//        guard let indexedKeyPostion = _storage.keys.firstIndex(of: i),
//              indexedKeyPostion < _storage.keys.endIndex else { return nil }
//        let nextIndex = indexedKeyPostion + 1
//        return _storage.keys[nextIndex]
//    }
// }
