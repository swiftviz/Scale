//
//  Histogram.swift
//

import Charts
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

struct Histogram<Value: Numeric & Hashable & Comparable> {
    typealias InternalDictType = OrderedDictionary<HistogramBinRange<Value>, Int>
    private var _storage: InternalDictType

    // Collection Conformance
//    var startIndex: HistogramBinRange<Value>?
//    var endIndex: HistogramBinRange<Value>?
//
//    subscript(position: HistogramBinRange<Value>) -> (HistogramBinRange<Value>, Int)? {
//        if let countValue = _storage[position] {
//            return (position, countValue)
//        }
//        return nil
//    }
//
//    func index(after i: HistogramBinRange<Value>) -> HistogramBinRange<Value>? {
//        if let indexPosition = _storage.keys.firstIndex(of: i) {
//            if indexPosition >= _storage.keys.endIndex {
//                return nil
//            } else {
//                return _storage.keys[indexPosition+1]
//            }
//        }
//        return nil
//    }

//
    /// A type representing the sequence's elements.

//    /// A type that represents a position in the collection.
//    ///
//    /// Valid indices consist of the position of every element and a
//    /// "past the end" position that's not valid for use as a subscript
//    /// argument.
//    public typealias Index = OrderedDictionary<HistogramBinRange<Value>, Value>.Index

//    /// A type that provides the collection's iteration interface and
//    /// encapsulates its iteration state.
//    ///
//    /// By default, a collection conforms to the `Sequence` protocol by
//    /// supplying `IndexingIterator` as its associated `Iterator`
//    /// type.
//    public typealias Iterator = OrderedDictionary<HistogramBinRange<Value>, Int>.Iterator

    // MARK: - Automatic (Scott's Rule) Initializers

    /// Automatically determine the bins from data.
    /// - Parameter data: <#data description#>
    init(data: [Value]) where Value: BinaryInteger {
        _storage = [:]
        guard let stdDev = data.stdDev, let smallestValue = data.min(), let largestValue = data.max() else {
            return
        }
        // As a default, use Scott's normal reference rule: 3.49 * stdDev / pow(n, 1/3) to determine a uniform
        // bin size for the histogram.
        let binSize = 3.49 * stdDev / pow(Double(data.count), 1.0 / 3.0)

        // Create and initialize the keys for the bins with a count of 0
        var currentStep = smallestValue
        while currentStep < largestValue {
            let bin: HistogramBinRange<Value>
            if currentStep + Value(binSize) > largestValue {
                bin = HistogramBinRange(lowerBound: currentStep, upperBound: largestValue, _final: true)
            } else {
                bin = HistogramBinRange(lowerBound: currentStep, upperBound: currentStep + Value(binSize))
            }
            _storage[bin] = 0
            currentStep += Value(binSize)
        }

        // Iterate through the data to insert everything into the histogram keyed by bin.
        for dataValue in data {
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
//        startIndex = _storage.keys.first
//        endIndex = _storage.keys.last
    }

    /// Automatically determine the bins from data.
    /// - Parameter data: <#data description#>
    init(data: [Value]) where Value: BinaryFloatingPoint {
        _storage = [:]
        guard let stdDev = data.stdDev, let smallestValue = data.min(), let largestValue = data.max() else {
            return
        }
        // As a default, use Scott's normal reference rule: 3.49 * stdDev / pow(n, 1/3) to determine a uniform
        // bin size for the histogram.
        let binSize = 3.49 * stdDev / pow(Double(data.count), 1.0 / 3.0)

        // Create and initialize the keys for the bins with a count of 0
        var currentStep = smallestValue
        while currentStep < largestValue {
            let bin: HistogramBinRange<Value>
            if currentStep + Value(binSize) > largestValue {
                bin = HistogramBinRange(lowerBound: currentStep, upperBound: largestValue, _final: true)
            } else {
                bin = HistogramBinRange(lowerBound: currentStep, upperBound: currentStep + Value(binSize))
            }
            _storage[bin] = 0
            currentStep += Value(binSize)
        }

        // Iterate through the data to insert everything into the histogram keyed by bin.
        for dataValue in data {
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
//        startIndex = _storage.keys.first
//        endIndex = _storage.keys.last
    }

    // MARK: - Uniform Initializers

    /// Automatically determine the bins from data, constrained by a minimum bin size
    /// - Parameters:
    ///   - data: <#data description#>
    ///   - desiredCount: <#desiredCount description#>
    ///   - minimumStride: <#minimumStride description#>
    init(data: [Value], desiredCount: Int?, minimumStride: Value) where Value: BinaryFloatingPoint {
        _storage = [:]
        guard let smallestValue = data.min(), let largestValue = data.max() else {
            return
        }
        // start by breaking down the data into discrete chunks - building the keys based on information
        // density, explicit values, or fixed widths,

        // default to using the provided minimum as the stride length for the histogram bins
        var stride = minimumStride
        if let desiredCount {
            // if a desired number of bins was provided, and a stride value evenly dividing the
            // data's range into those values is larger than the minimum, use that larger stride.
            let maybeStride = (largestValue - smallestValue) / Value(desiredCount)
            if maybeStride >= minimumStride {
                stride = maybeStride
            }
        }

        // Create and initialize the keys for the bins with a count of 0
        var currentStep = smallestValue
        while currentStep < largestValue {
            let bin: HistogramBinRange<Value>
            if currentStep + stride > largestValue {
                bin = HistogramBinRange(lowerBound: currentStep, upperBound: largestValue, _final: true)
            } else {
                bin = HistogramBinRange(lowerBound: currentStep, upperBound: currentStep + stride)
            }
            _storage[bin] = 0
            currentStep += stride
        }

        // Iterate through the data to insert everything into the histogram keyed by bin.
        for dataValue in data {
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
//        startIndex = _storage.keys.first
//        endIndex = _storage.keys.last
    }

    /// Automatically determine the bins from data, constrained by a minimum bin size
    /// - Parameters:
    ///   - data: <#data description#>
    ///   - desiredCount: <#desiredCount description#>
    ///   - minimumStride: <#minimumStride description#>
    init(data: [Value], desiredCount: Int?, minimumStride: Value) where Value: BinaryInteger {
        _storage = [:]
        guard let smallestValue = data.min(), let largestValue = data.max() else {
            return
        }
        // start by breaking down the data into discrete chunks - building the keys based on information
        // density, explicit values, or fixed widths,

        // default to using the provided minimum as the stride length for the histogram bins
        var stride = minimumStride
        if let desiredCount {
            // if a desired number of bins was provided, and a stride value evenly dividing the
            // data's range into those values is larger than the minimum, use that larger stride.
            let maybeStride = (largestValue - smallestValue) / Value(desiredCount)
            if maybeStride >= minimumStride {
                stride = maybeStride
            }
        }

        // Create and initialize the keys for the bins with a count of 0
        var currentStep = smallestValue
        while currentStep < largestValue {
            let bin: HistogramBinRange<Value>
            if currentStep + stride > largestValue {
                bin = HistogramBinRange(lowerBound: currentStep, upperBound: largestValue, _final: true)
            } else {
                bin = HistogramBinRange(lowerBound: currentStep, upperBound: currentStep + stride)
            }
            _storage[bin] = 0
            currentStep += stride
        }

        // Iterate through the data to insert everything into the histogram keyed by bin.
        for dataValue in data {
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
//        startIndex = _storage.keys.first
//        endIndex = _storage.keys.last
    }

    // MARK: - Explicit Thresholds, Non-uniform bin-size Initializers

    /// Explicitly build a histogram with N-1 threshold bins, with the explicit thresholds you provide.
    /// - Parameter data: <#data description#>
    init(data: [Value], thresholds: [Value]) {
        _storage = [:]
        guard let lastThreshold = thresholds.last, data.count > 1, thresholds.count > 1 else {
            return
        }

        // Create and initialize the keys for the bins with a count of 0
        for (lower, higher) in thresholds.pairs() {
            let bin: HistogramBinRange<Value>
            if higher == lastThreshold {
                bin = HistogramBinRange(lowerBound: lower, upperBound: higher, _final: true)
            } else {
                bin = HistogramBinRange(lowerBound: lower, upperBound: higher)
            }
            _storage[bin] = 0
        }

        // Iterate through the data to insert everything into the histogram keyed by bin.
        for dataValue in data {
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
//        startIndex = _storage.keys.first
//        endIndex = _storage.keys.last
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
        @inlinable
        public mutating func next() -> Element? {
            guard _position < _base._storage.count else { return nil }
            let key = _base._storage.keys[_position]
            guard let valueAtKey = _base._storage[key] else { return nil }
            let result = (key, valueAtKey)
            _position += 1
            return result
        }
    }

    func makeIterator() -> HistogramIterator {
        HistogramIterator(_base: self)
    }
}

// https://www.swiftbysundell.com/articles/creating-custom-collections-in-swift/
// OrderedDictionary *doesn't* conform to Collection itself, so we'd have to really screw with this...
//
//    public typealias Index = HistogramBinRange<Value>
//    extension Histogram: Collection {
//        // Required nested types, that tell Swift what our collection contains
//        typealias Index = Histogram.InternalDictType.Index
//        typealias Element = Histogram.InternalDictType.Element
//
//        // The upper and lower bounds of the collection, used in iterations
//        var startIndex: Index { return _storage.startIndex }
//        var endIndex: Index { return _storage.endIndex }
//
//        // Required subscript, based on a dictionary index
//        subscript(index: Index) -> Histogram.InternalDictType.Iterator.Element {
//            get { return _storage[index] }
//        }
//
//        // Method that returns the next index when iterating
//        func index(after i: Index) -> Index {
//            return _storage.index(after: i)
//        }
//    }
