//
//  BandScale.swift
//

import Foundation

// =============================================================
//  BandScale.swift

// Inspired by D3's scale concept - maps input values (domain) to an output range (range)
// - https://github.com/d3/d3-scale
// - https://github.com/pshrmn/notes/blob/master/d3/scales.md

// - https://github.com/pshrmn/notes/blob/master/d3/scales.md#band-scales
// - https://github.com/d3/d3-scale#band-scales
// - https://observablehq.com/@d3/d3-scaleband

/// A discrete scale that maps from a discrete value within a collection to a band within a continuous output _range_.
///
/// Band scales are useful for bar charts, calculating explicit bands with optional spacing to align with elements of a collection.
/// If you mapping discrete data into a scatter plot, consider using the ``PointScale`` instead.
public struct BandScale<CategoryType: Comparable, OutputType: BinaryFloatingPoint>: DiscreteScale {
    /// The lower value of the range into which the discrete values map.
    public let rangeLower: OutputType?
    /// The upper value of the range into which the discrete values map.
    public let rangeHigher: OutputType?
    /// A Boolean value that indicates the scaled values are returned as rounded values.
    public let round: Bool
    /// The amount of padding between bands.
    public let paddingInner: OutputType
    /// The amount of padding outside of the bands.
    public let paddingOuter: OutputType
    /// An array of the types the scale maps into.
    public let domain: [CategoryType]

    /// The type of discrete scale.
    public let scaleType: DiscreteScaleType = .band
    /// A Boolean value that indicates if the mapping from domain to range is inverted.
    public let reversed: Bool

    /// Creates a new band scale.
    /// - Parameters:
    ///   - domain: An array of the types the scale maps into.
    ///   - paddingInner: The amount of padding between bands.
    ///   - paddingOuter: The amount of padding outside of the bands.
    ///   - round: A Boolean value that indicates the scaled values are returned as rounded values.
    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    ///   - from: The lower value of the range into which the discrete values map.
    ///   - to: The upper value of the range into which the discrete values map.
    public init(_ domain: [CategoryType] = [],
                paddingInner: OutputType = 0,
                paddingOuter: OutputType = 0,
                round: Bool = false,
                reversed: Bool = false,
                from: OutputType? = nil,
                to: OutputType? = nil)
    {
        self.round = round
        self.paddingInner = paddingInner
        self.paddingOuter = paddingOuter
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

    // - MARK: Modifier style update functions

    // effectively 'modifier' functions that return a new version of a scale

    /// Returns a new scale with the domain set to the values you provide.
    /// - Parameter domain: An array of the types the scale maps into.
    public func domain(_ domain: [CategoryType]) -> Self {
        type(of: self).init(domain, paddingInner: paddingInner, paddingOuter: paddingOuter, round: round, reversed: reversed, from: rangeLower, to: rangeHigher)
    }

    /// Returns a new scale with the rounding set to the value you provide.
    /// - Parameter newRound: A Boolean value that indicates the scaled values are returned as rounded values.
    public func round(_ newRound: Bool) -> Self {
        type(of: self).init(domain, paddingInner: paddingInner, paddingOuter: paddingOuter, round: newRound, reversed: reversed, from: rangeLower, to: rangeHigher)
    }

    /// Returns a new scale with the inner padding set to the value you provide.
    /// - Parameter newPaddingInner: The amount of padding between bands.
    public func paddingInner(_ newPaddingInner: OutputType) -> Self {
        type(of: self).init(domain, paddingInner: newPaddingInner, paddingOuter: paddingOuter, round: round, reversed: reversed, from: rangeLower, to: rangeHigher)
    }

    /// Returns a new scale with the outer padding set to the value you provide.
    /// - Parameter newPaddingOuter: The amount of padding outside of the bands.
    public func paddingOuter(_ newPaddingOuter: OutputType) -> Self {
        type(of: self).init(domain, paddingInner: paddingInner, paddingOuter: newPaddingOuter, round: round, reversed: reversed, from: rangeLower, to: rangeHigher)
    }

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    ///   - lower: The lower value of the range into which the discrete values map.
    ///   - higher: The upper value of the range into which the discrete values map.
    public func range(reversed: Bool, lower: OutputType, higher: OutputType) -> Self {
        precondition(lower < higher, "attempting to set an inverted or empty range: \(lower) to \(higher)")
        return type(of: self).init(domain, paddingInner: paddingInner, paddingOuter: paddingOuter, round: round, reversed: reversed, from: lower, to: higher)
    }

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - lower: The lower value of the range into which the discrete values map.
    ///   - higher: The upper value of the range into which the discrete values map.
    public func range(lower: OutputType, higher: OutputType) -> Self {
        precondition(lower < higher, "attempting to set an inverted or empty range: \(lower) to \(higher)")
        return type(of: self).init(domain, paddingInner: paddingInner, paddingOuter: paddingOuter, round: round, reversed: reversed, from: lower, to: higher)
    }

    /// Returns a new scale with the range set to the range you provide.
    /// - Parameter reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    /// - Parameter range: The range of the values into which the discrete values map.
    public func range(reversed: Bool, _ range: ClosedRange<OutputType>) -> Self {
        precondition(range.lowerBound < range.upperBound, "attempting to set an inverted or empty range: \(range.lowerBound) to \(range.upperBound)")
        return type(of: self).init(domain, paddingInner: paddingInner, paddingOuter: paddingOuter, round: round, reversed: reversed, from: range.lowerBound, to: range.upperBound)
    }

    /// Returns a new scale with the range set to the range you provide.
    /// - Parameter range: The range of the values into which the discrete values map.
    public func range(_ range: ClosedRange<OutputType>) -> Self {
        precondition(range.lowerBound < range.upperBound, "attempting to set an inverted or empty range: \(range.lowerBound) to \(range.upperBound)")
        return type(of: self).init(domain, paddingInner: paddingInner, paddingOuter: paddingOuter, round: round, reversed: reversed, from: range.lowerBound, to: range.upperBound)
    }

    // attributes of the scale when fully configured

    internal func width() -> Double? {
        guard let from = rangeLower, let to = rangeHigher else {
            return nil
        }
        if domain.isEmpty {
            return nil
        }
        let extent = Double(to) - Double(from)
        let extentWithoutOuterPadding = extent - (2 * Double(paddingOuter))
        let sumOfInternalPadding = Double(domain.count - 1) * Double(paddingInner)
//        #if DEBUG
//        assert(extentWithoutOuterPadding - sumOfInternalPadding > 0)
//        #endif
        if (extentWithoutOuterPadding - sumOfInternalPadding) < 0 {
            return 0
        } else {
            let internalWidth = (extentWithoutOuterPadding - sumOfInternalPadding) / Double(domain.count)
            if round {
                return internalWidth.rounded()
            }
            return internalWidth
        }
    }

    internal func step() -> Double? {
        guard let width = width() else {
            return nil
        }
        if round {
            return (width + Double(paddingInner)).rounded()
        }
        return width + Double(paddingInner)
    }

    /// Maps the discrete item into a band.
    /// - Parameter value: A discrete item from the list provided as the domain for the scale.
    /// - Returns: A band that wraps the category found in the domain with start and end values for the range of the band, or `nil` if the value isn't contained by the domain.
    public func scale(_ value: CategoryType) -> Band<CategoryType, OutputType>? {
        guard let step = step(), let width = width() else {
            return nil
        }
        if width <= 0 || !domain.contains(value) {
            // when there's more padding than available space for the categories
            // OR
            // the value to be scaled isn't within the domain
            return nil
        }
        let doublePosition: Double
        if reversed {
            doublePosition = Double(domain.reversed().firstIndex(of: value)!)
        } else {
            doublePosition = Double(domain.firstIndex(of: value)!)
        }
        let startLocation = Double(paddingOuter) + (doublePosition * step)
        let stopLocation = startLocation + width
        if round {
            return Band(lower: OutputType(startLocation.rounded()), higher: OutputType(stopLocation.rounded()), value: value)
        }
        return Band(lower: OutputType(startLocation), higher: OutputType(stopLocation), value: value)
    }

    /// Maps the discrete item into a band with the range values you provide..
    /// - Parameters:
    ///   - value: A discrete item from the list provided as the domain for the scale.
    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    ///   - from: The lower value of the range into which the discrete values map.
    ///   - to: The upper value of the range into which the discrete values map.
    /// - Returns: A band that wraps the category found in the domain with start and end values for the range of the band, or `nil` if the value isn't contained by the domain.
    public func scale(_ value: CategoryType, reversed: Bool, from: OutputType, to: OutputType) -> Band<CategoryType, OutputType>? {
        precondition(from < to, "attempting to set an inverted or empty range: \(from) to \(to)")
        let reconfiguredScale = type(of: self).init(domain, paddingInner: paddingInner, paddingOuter: paddingOuter, round: round, reversed: reversed, from: from, to: to)
        return reconfiguredScale.scale(value)
    }

    /// Maps the discrete item into a band with the range values you provide..
    /// - Parameters:
    ///   - value: A discrete item from the list provided as the domain for the scale.
    ///   - from: The lower value of the range into which the discrete values map.
    ///   - to: The upper value of the range into which the discrete values map.
    /// - Returns: A band that wraps the category found in the domain with start and end values for the range of the band, or `nil` if the value isn't contained by the domain.
    public func scale(_ value: CategoryType, from: OutputType, to: OutputType) -> Band<CategoryType, OutputType>? {
        precondition(from < to, "attempting to set an inverted or empty range: \(from) to \(to)")
        let reconfiguredScale = type(of: self).init(domain, paddingInner: paddingInner, paddingOuter: paddingOuter, round: round, reversed: reversed, from: from, to: to)
        return reconfiguredScale.scale(value)
    }

    /// Maps the value from the range back to the discrete value that it matches.
    /// - Parameter location: A value within the range of the scale.
    /// - Returns: The item that matches at that value, or nil if the point is within padding or outside the range of the scale.
    public func invert(_ location: OutputType) -> CategoryType? {
        guard let upperRange = rangeHigher, let lowerRange = rangeLower else {
            // insufficiently configured, dump and run
            return nil
        }
        if (location < paddingOuter) || (location > (upperRange - paddingOuter)) {
            // fast-fail for any location outside of bands
            return nil
        }
        if width() ?? 0 <= 0 {
            // double check and fast-fail if the combined padding for the domain is larger than the range provided
            return nil
        }
        // calculate the closest index
        let rangeExtentWithoutOuterPadding = Double(upperRange) - Double(lowerRange) - 2 * Double(paddingOuter)
        let indexedRangeValue: Double
        if reversed {
            indexedRangeValue = (Double(upperRange) - Double(paddingOuter) - Double(location)) / rangeExtentWithoutOuterPadding
        } else {
            indexedRangeValue = (Double(location) - Double(paddingOuter)) / rangeExtentWithoutOuterPadding
        }
        let rangeValueExpandedToCountDomain = indexedRangeValue * Double(domain.count - 1)

        let closestIndex = Int(rangeValueExpandedToCountDomain.rounded())
        if let band = scale(domain[closestIndex]) {
            // Get the band for the item at that index and check to see if `at` is within its bounds.
            if location >= band.lower, location <= band.higher {
                return band.value
            }
        }
        return nil
    }

    /// Maps a band back to the category it matches.
    /// - Parameter rangeValue: a band providing a pair of range values.
    /// - Returns: The category that matches the midpoint of the band values.
    public func invert(_ rangeValue: Band<CategoryType, OutputType>) -> CategoryType? {
        let middlePoint = (Double(rangeValue.higher) + Double(rangeValue.lower)) / 2.0
        return invert(OutputType(middlePoint))
    }

    /// Maps the value from the range values you provide back to the discrete value that it matches.
    /// - Parameters:
    ///   - location: A value within the range of the scale.
    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    ///   - from: The lower value of the range into which the discrete values map.
    ///   - to: The upper value of the range into which the discrete values map.
    /// - Returns: The item that matches at that value, or nil if the point is within padding or outside the range of the scale.
    public func invert(_ location: OutputType, reversed: Bool, from: OutputType, to: OutputType) -> CategoryType? {
        precondition(from < to, "attempting to set an inverted or empty range: \(from) to \(to)")
        let reconfiguredScale = type(of: self).init(domain, paddingInner: paddingInner, paddingOuter: paddingOuter, round: round, reversed: reversed, from: from, to: to)
        return reconfiguredScale.invert(location)
    }

    /// Maps the value from the range values you provide back to the discrete value that it matches.
    /// - Parameters:
    ///   - location: A value within the range of the scale.
    ///   - from: The lower value of the range into which the discrete values map.
    ///   - to: The upper value of the range into which the discrete values map.
    /// - Returns: The item that matches at that value, or nil if the point is within padding or outside the range of the scale.
    public func invert(_ location: OutputType, from: OutputType, to: OutputType) -> CategoryType? {
        precondition(from < to, "attempting to set an inverted or empty range: \(from) to \(to)")
        let reconfiguredScale = type(of: self).init(domain, paddingInner: paddingInner, paddingOuter: paddingOuter, round: round, reversed: reversed, from: from, to: to)
        return reconfiguredScale.invert(location)
    }
}

extension BandScale: CustomStringConvertible {
    /// The description of the scale.
    public var description: String {
        "\(scaleType)\(domain)->[\(String(describing: rangeLower)):\(String(describing: rangeHigher))]"
    }
}

public extension BandScale {
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
    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    ///   - rangeLower: the lower value for the range into which to position the ticks.
    ///   - rangeHigher: The higher value for the range into which to position the ticks.
    ///   - formatter: An optional formatter to convert the domain values into strings.
    func ticks(reversed: Bool, rangeLower lower: RangeType, rangeHigher higher: RangeType, formatter: Formatter? = nil) -> [Tick<RangeType>] {
        // NOTE(heckj): perf: for a larger number of ticks, it may be more efficient to assign the range to a temp scale and then iterate on that...
        let updatedScale = range(reversed: reversed, lower: lower, higher: higher)
        return domain.compactMap { tickValue in
            guard let tickRangeValue = updatedScale.scale(tickValue) else {
                return nil
            }
            return Tick(value: tickValue, location: tickRangeValue.middle, formatter: formatter)
        }
    }

    /// Returns an array of the locations within the output range to locate ticks for the scale.
    /// - Parameters:
    ///   - rangeLower: the lower value for the range into which to position the ticks.
    ///   - rangeHigher: The higher value for the range into which to position the ticks.
    ///   - formatter: An optional formatter to convert the domain values into strings.
    func ticks(rangeLower lower: RangeType, rangeHigher higher: RangeType, formatter: Formatter? = nil) -> [Tick<RangeType>] {
        ticks(reversed: reversed, rangeLower: lower, rangeHigher: higher, formatter: formatter)
    }
}

/// A type used to indicate the start and stop positions for a band associated with the provided value.
public struct Band<EnclosedType, RangeType: BinaryFloatingPoint> {
    public let lower: RangeType
    public let higher: RangeType
    public var middle: RangeType {
        RangeType((Double(higher) - Double(lower)) / 2.0 + Double(lower))
    }

    public let value: EnclosedType
}
