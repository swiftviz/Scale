//
//  Histogram.swift
//

import Foundation
import OrderedCollections
import Charts

struct Histogram<Value: Numeric & Hashable & Comparable> {
    let _storage: OrderedDictionary<HistogramBinRange<Value>, Int> = [:]
}
// init <T: BinaryInteger>, init <T: BinaryFloatingPoint>

// conform to "Sequence", where each index returns a HistogramBinRange
// various initializers:
// from NumberBins in Charts:
//
// Explicit thresholds:
// init(thresholds: [Value])
//   Creates N-1 bins with the given N thresholds.
//
// Uniform over a range:
// init(size: Value, range: ClosedRange<Value>)
//   Creates uniform bins covering the given range.
//
// Infer from data, or range of values:
// init(range: ClosedRange<Value>, desiredCount: Int, minimumStride: Value)
//   Automatically determine the bins from a range of data.
// init(data: [Value], desiredCount: Int?, minimumStride: Value)
//   Automatically determine the bins from data.

// returns pairs of values from an array, dropping the first value?
//public extension Collection {
//    func pairs() -> AnySequence<(Element, Element)> {
//        AnySequence(zip(self, dropFirst()))
//    }
//}

//public extension Sequence where Element: Hashable, Element: Comparable {
//  generate a histogram from any Sequence type
//    /// Create a histogram from the sequence of values, incrementing the count for every equivalent value.
//    /// - Returns: A dictionary of the elements of the sequence and the number of those elements.
//    func histogram() -> Histogram<Element> {
//        Histogram(reduce(into: [:]) { counts, elem in counts[elem, default: 0] += 1 })
//    }
//}

// Using data from a histogram:
// treat akin to a dictionary
// request the index of the bin, or iterate through them
//  - min for bin values, max for bin values
//  - value returned is a count (Int, UInt)? for the bin
// [] -> returns the range
// index(for: val) -> returns the counts

// None of the NumberBin/Date bin appear to return the counts - so it's not a data structure you can directly use per se
