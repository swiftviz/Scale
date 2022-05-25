//
//  PointScale.swift
//
//
//  Created by Joseph Heck on 4/1/22.
//

import Foundation

// - https://github.com/d3/d3-scale#point-scales
// - https://github.com/pshrmn/notes/blob/master/d3/scales.md#point-scales
// - https://observablehq.com/@d3/d3-scalepoint

/// A discrete scale that maps from a discrete value within a collection to a point within a continuous output _range_.
///
/// Point scales are useful for mapping discrete data from a collection to a collection of specific points.
/// If you are rendering a bar chart, consider using the ``BandScale`` instead.
public struct PointScale<CategoryType: Comparable, OutputType: ConvertibleWithDouble>: DiscreteScale {
    /// The lower value of the range into which the discrete values map.
    public let rangeLower: OutputType?
    /// The upper value of the range into which the discrete values map.
    public let rangeHigher: OutputType?
    /// A Boolean value that indicates the scaled values are returned as rounded values.
    public let round: Bool
    /// The amount of padding between bands.
    public let padding: OutputType

    /// An array of the types the scale maps into.
    public let domain: [CategoryType]

    /// The type of discrete scale.
    public let scaleType: DiscreteScaleType = .point
    /// A Boolean value that indicates if the mapping from domain to range is inverted.
    public let reversed: Bool

    /// Creates a new point scale.
    /// - Parameters:
    ///   - domain: An array of the types the scale maps into.
    ///   - padding: The amount of padding between the points.
    ///   - round: A Boolean value that indicates the scaled values are returned as rounded values.
    ///   - from: The lower value of the range into which the discrete values map.
    ///   - to: The upper value of the range into which the discrete values map.
    public init(_ domain: [CategoryType] = [],
                padding: OutputType = 0,
                round: Bool = false,
                reversed: Bool = false,
                from: OutputType? = nil,
                to: OutputType? = nil)
    {
        self.round = round
        self.padding = padding
        self.domain = domain
        self.reversed = reversed
        if let from = from, let to = to {
            precondition(from < to, "attempting to set an inverted or empty range: \(from) to \(to)")
            rangeLower = from
            rangeHigher = to
        } else {
            rangeLower = nil
            rangeHigher = nil
        }
    }

    // testing function only - verifies the scale is fully configured
    internal func fullyConfigured() -> Bool {
        rangeLower != nil && rangeHigher != nil && domain.count > 0
    }

    // MARK: - modifier functions

    /// Returns a new scale with the domain set to the values you provide.
    /// - Parameter domain: An array of the types the scale maps into.
    public func domain(_ domain: [CategoryType]) -> Self {
        type(of: self).init(domain, padding: padding, round: round, reversed: reversed, from: rangeLower, to: rangeHigher)
    }

    /// Returns a new scale with the rounding set to the value you provide.
    /// - Parameter newRound: A Boolean value that indicates the scaled values are returned as rounded values.
    public func round(_ newRound: Bool) -> Self {
        type(of: self).init(domain, padding: padding, round: newRound, reversed: reversed, from: rangeLower, to: rangeHigher)
    }

    /// Returns a new scale with the inner padding set to the value you provide.
    /// - Parameter newPaddingInner: The amount of padding between bands.
    public func padding(_ newPadding: OutputType) -> Self {
        type(of: self).init(domain, padding: newPadding, round: round, reversed: reversed, from: rangeLower, to: rangeHigher)
    }

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - lower: The lower value of the range into which the discrete values map.
    ///   - higher: The upper value of the range into which the discrete values map.
    public func range(reversed: Bool = false, lower: OutputType, higher: OutputType) -> Self {
        precondition(lower < higher, "attempting to set an inverted or empty range: \(lower) to \(higher)")
        return type(of: self).init(domain, padding: padding, round: round, reversed: reversed, from: lower, to: higher)
    }

    /// Returns a new scale with the range set to the range you provide.
    /// - Parameter range: The range of the values into which the discrete values map.
    public func range(reversed: Bool = false, _ range: ClosedRange<OutputType>) -> Self {
        precondition(range.lowerBound < range.upperBound, "attempting to set an inverted or empty range: \(range.lowerBound) to \(range.upperBound)")
        return type(of: self).init(domain, padding: padding, round: round, reversed: reversed, from: range.lowerBound, to: range.upperBound)
    }

    internal func step() -> Double? {
        guard let from = rangeLower, let to = rangeHigher else {
            return nil
        }
        if domain.isEmpty {
            return nil
        }

        let extent = to.toDouble() - from.toDouble()
        let extentWithoutOuterPadding = extent - (2 * padding.toDouble())
        if extentWithoutOuterPadding < 0 {
            return 0
        } else {
            let internalWidth = extentWithoutOuterPadding / Double(domain.count)
            return internalWidth
        }
    }

    /// Maps the discrete item into a range location.
    /// - Parameter value: A discrete item from the list provided as the domain for the scale.
    /// - Parameter from: The lower value of the range into which the discrete values map.
    /// - Parameter to: The upper value of the range into which the discrete values map.
    /// - Returns: A location along the range that indicates a point that matches with the value you provided, or `nil` if the value isn't contained by the domain.
    public func scale(_ value: CategoryType, reversed: Bool = false, from: OutputType, to: OutputType) -> OutputType? {
        precondition(from < to, "attempting to set an inverted or empty range: \(from) to \(to)")
        let reconfiguredScale = type(of: self).init(domain, padding: padding, round: round, reversed: reversed, from: from, to: to)
        return reconfiguredScale.scale(value)
    }

    /// Maps the discrete item into a range location.
    /// - Parameter value: A discrete item from the list provided as the domain for the scale.
    /// - Returns: A location along the range that indicates a point that matches with the value you provided, or `nil` if the value isn't contained by the domain.
    public func scale(_ value: CategoryType) -> OutputType? {
        guard let index = domain.firstIndex(of: value), let step = step() else {
            return nil
        }
        if step <= 0 {
            // when there's more padding than available space for the categories
            return nil
        }
        let doublePosition = Double(index) // 1
        let location = padding.toDouble() + (doublePosition * step)
        if round {
            return OutputType.fromDouble(location.rounded())
        }
        return OutputType.fromDouble(location)
    }

    /// Maps the value from the range back to the discrete value that it matches.
    /// - Parameters:
    ///   - location: A value within the range of the scale.
    ///   - from: The lower value of the range into which the discrete values map.
    ///   - to: The upper value of the range into which the discrete values map.
    /// - Returns: The item that matches at that value, or nil if the point is within padding or outside the range of the scale.
    public func invert(_ location: OutputType, reversed: Bool = false, from: OutputType, to: OutputType) -> CategoryType? {
        precondition(from < to, "attempting to set an inverted or empty range: \(from) to \(to)")
        let reconfiguredScale = type(of: self).init(domain, padding: padding, round: round, reversed: reversed, from: from, to: to)
        return reconfiguredScale.invert(location)
    }

    /// Maps the value from the range back to the discrete value that it matches.
    /// - Parameter location: A value within the range of the scale.
    /// - Returns: The item that matches at that value, or nil if the point is within padding or outside the range of the scale.
    public func invert(_ location: OutputType) -> CategoryType? {
        guard let upperRange = rangeHigher, let lowerRange = rangeLower else {
            // insufficiently configured, dump and run
            return nil
        }
        if (location < lowerRange) || (location > upperRange) {
            // fast-fail for any location outside of the range
            return nil
        }
        if step() ?? 0 <= 0 {
            // double check and fast-fail if the combined padding for the domain is larger than the range provided
            return nil
        }
        // calculate the closest index
        let rangeExtentWithoutPadding = upperRange.toDouble() - lowerRange.toDouble() - 2 * padding.toDouble()
        let unitRangeValue = (location.toDouble() - padding.toDouble()) / rangeExtentWithoutPadding
        let rangeValueExpandedToCountDomain = unitRangeValue * Double(domain.count - 1)
        let closestIndex = Int(rangeValueExpandedToCountDomain.rounded())
        return domain[closestIndex]
    }
}

extension PointScale: CustomStringConvertible {
    /// The description of the scale.
    public var description: String {
        "\(scaleType)\(domain)->[\(String(describing: rangeLower)):\(String(describing: rangeHigher))]"
    }
}

public extension PointScale {
    /// Returns an array of the strings that make up the ticks for the scale.
    /// - Parameter formatter: An optional formatter to convert the domain values into strings.
    func defaultTickValues(formatter: Formatter? = nil) -> [String] {
        domain.map { value in
            if let formatter = formatter {
                return formatter.string(for: value) ?? ""
            } else {
                return String("\(value)")
            }
        }
    }

    /// Returns an array of the locations within the output range to locate ticks for the scale.
    /// - Parameters:
    ///   - rangeLower: the lower value for the range into which to position the ticks.
    ///   - rangeHigher: The higher value for the range into which to position the ticks.
    ///   - formatter: An optional formatter to convert the domain values into strings.
    func ticks(reversed: Bool = false, rangeLower lower: RangeType, rangeHigher higher: RangeType, formatter: Formatter? = nil) -> [Tick<RangeType>] {
        // NOTE(heckj): perf: for a larger number of ticks, it may be more efficient to assign the range to a temp scale and then iterate on that...
        let updatedScale = range(reversed: reversed, lower: lower, higher: higher)
        return domain.compactMap { tickValue in
            guard let tickRangeValue = updatedScale.scale(tickValue) else {
                return nil
            }
            return Tick(value: tickValue, location: tickRangeValue, formatter: formatter)
        }
    }
}
