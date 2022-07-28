//
//  HistogramBinRange.swift
//

import Foundation

/// The range of data that a single bin of a histogram represents.
///
/// All bins except the last for a particular chart represent an open range, meaning that the range doesn’t include the upper bound.
/// The last range of the last bin is closed, so that it does include the upper bound.
/// The system keeps track of the open or closed state of a particular range.
public struct HistogramBinRange<Bound> where Bound: Comparable {
    // rough clone ChartBinRange
    public let lowerBound: Bound
    public let upperBound: Bound
    internal let _final: Bool

    internal init(lowerBound: Bound, upperBound: Bound, _final: Bool = false) {
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        self._final = _final
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
            return element >= lowerBound && element <= upperBound
        } else {
            return element >= lowerBound && element < upperBound
        }
    }
}
