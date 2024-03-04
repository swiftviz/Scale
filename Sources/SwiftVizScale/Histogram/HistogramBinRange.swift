//
//  HistogramBinRange.swift
//

import Foundation

/// The range of data that a single bin of a histogram represents.
///
/// The bins are expected to be used either independently as an ordered collection, or as the keys for an ordered dictionary.
/// Within the collection, all bins except the last for a particular chart represent an open range.
/// As an open range, the bin doesn’t include the threshold of the upper bound within it.
/// The last bin of the collection is a closed range to include the final upper bound.
public struct HistogramBinRange<Bound: Hashable & Comparable> {
    /// The lower bound of the bin range.
    public let lowerBound: Bound
    /// The upper bound of the bin range.
    public let upperBound: Bound
    let _final: Bool

    init(lowerBound: Bound, upperBound: Bound, _final: Bool = false) {
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        self._final = _final
    }
}

extension HistogramBinRange: Hashable {}

extension HistogramBinRange: Comparable {
    public static func < (lhs: HistogramBinRange<Bound>, rhs: HistogramBinRange<Bound>) -> Bool {
        lhs.lowerBound < rhs.lowerBound
    }
}

extension HistogramBinRange: RangeExpression {
    /// Returns the range of indices described by this range expression within the given collection.
    /// - Parameter collection: The collection to evaluate this range expression in relation to.
    /// - Returns: A range suitable for slicing collection. The returned range is not guaranteed to be inside the bounds of collection. Callers should apply the same preconditions to the return value as they would to a range provided directly by the user.
    @inlinable
    public func relative<C>(to collection: C) -> Range<Bound> where C: Collection, Bound == C.Index {
        Range(uncheckedBounds: (
            lower: lowerBound,
            upper: collection.index(after: upperBound)
        ))
    }

    /// Returns a Boolean value indicating whether the given element is contained within the range expression.
    /// - Parameter element: The element to check for containment.
    /// - Returns: `true` if element is contained in the range expression; otherwise, `false`.
    public func contains(_ element: Bound) -> Bool {
        if _final {
            element >= lowerBound && element <= upperBound
        } else {
            element >= lowerBound && element < upperBound
        }
    }
}

extension HistogramBinRange: CustomStringConvertible {
    /// The description of the bin.
    public var description: String {
        if _final {
            String(describing: lowerBound ... upperBound)
        } else {
            String(describing: lowerBound ..< upperBound)
        }
    }
}
