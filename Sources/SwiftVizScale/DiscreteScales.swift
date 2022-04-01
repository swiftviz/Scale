//
//  BandScale.swift
//
//
//  Created by Joseph Heck on 4/1/22.
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

/// A type that maps values from a discrete _domain_ to a band within a continuous output _range_.
///
/// Band scales are useful for bar charts, calculating explicit bands with optional spacing to align with elements of a collection.
/// If you mapping discrete data into a scatter plot, consider using the ``PointScale`` instead.
public struct BandScale<CategoryType: Hashable, OutputType: ConvertibleWithDouble> {
    public let from: OutputType?
    public let to: OutputType?
    public let round: Bool
    public let paddingInner: OutputType
    public let paddingOuter: OutputType
    public let domain: [CategoryType]

    /// Creates a new band scale.
    /// - Parameters:
    ///   - domain: An array of the types the scale maps into.
    ///   - paddingInner: The amount of padding between bands.
    ///   - paddingOuter: The amount of padding outside of the bands.
    ///   - round: A Boolean value that indicates the scaled values are returned as rounded values.
    ///   - from: The lower value of the range into which the discrete values map.
    ///   - to: The upper value of the range into which the discrete values map.
    public init(_ domain: [CategoryType] = [], paddingInner: OutputType = 0, paddingOuter: OutputType = 0, round: Bool = false, from: OutputType? = nil, to: OutputType? = nil) {
        self.round = round
        self.paddingInner = paddingInner
        self.paddingOuter = paddingOuter
        self.domain = domain
        if let from = from, let to = to {
            precondition(from < to, "attempting to set an inverted or empty range: \(from) to \(to)")
            self.from = from
            self.to = to
        } else {
            self.from = nil
            self.to = nil
        }
    }

    // testing function only - verifies the scale is fully configured
    internal func fullyConfigured() -> Bool {
        from != nil && to != nil && domain.count > 0
    }

    // - MARK: Modifier style update functions

    // effectively 'modifier' functions that return a new version of a scale

    /// Returns a new scale with the domain set to the values you provide.
    /// - Parameter domain: An array of the types the scale maps into.
    public func domain(_ domain: [CategoryType]) -> Self {
        type(of: self).init(domain, paddingInner: paddingInner, paddingOuter: paddingOuter, round: round, from: from, to: to)
    }

    /// Returns a new scale with the rounding set to the value you provide.
    /// - Parameter newRound: A Boolean value that indicates the scaled values are returned as rounded values.
    public func round(_ newRound: Bool) -> Self {
        type(of: self).init(domain, paddingInner: paddingInner, paddingOuter: paddingOuter, round: newRound, from: from, to: to)
    }

    /// Returns a new scale with the inner padding set to the value you provide.
    /// - Parameter newPaddingInner: The amount of padding between bands.
    public func paddingInner(_ newPaddingInner: OutputType) -> Self {
        type(of: self).init(domain, paddingInner: newPaddingInner, paddingOuter: paddingOuter, round: round, from: from, to: to)
    }

    /// Returns a new scale with the outer padding set to the value you provide.
    /// - Parameter newPaddingOuter: The amount of padding outside of the bands.
    public func paddingOuter(_ newPaddingOuter: OutputType) -> Self {
        type(of: self).init(domain, paddingInner: paddingInner, paddingOuter: newPaddingOuter, round: round, from: from, to: to)
    }

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - from: The lower value of the range into which the discrete values map.
    ///   - to: The upper value of the range into which the discrete values map.
    public func range(from: OutputType, to: OutputType) -> Self {
        precondition(from < to, "attempting to set an inverted or empty range: \(from) to \(to)")
        return type(of: self).init(domain, paddingInner: paddingInner, paddingOuter: paddingOuter, round: round, from: from, to: to)
    }

    /// Returns a new scale with the range set to the range you provide.
    /// - Parameter range: The range of the values into which the discrete values map.
    public func range(_ range: ClosedRange<OutputType>) -> Self {
        precondition(range.lowerBound < range.upperBound, "attempting to set an inverted or empty range: \(range.lowerBound) to \(range.upperBound)")
        return type(of: self).init(domain, paddingInner: paddingInner, paddingOuter: paddingOuter, round: round, from: range.lowerBound, to: range.upperBound)
    }

    // attributes of the scale when fully configured

    internal func width() -> Double? {
        guard let from = from, let to = to else {
            return nil
        }
        if domain.isEmpty {
            return nil
        }
        let extent = to.toDouble() - from.toDouble()
        let extentWithoutOuterPadding = extent - (2 * paddingOuter.toDouble())
        let sumOfInternalPadding = Double(domain.count - 1) * paddingInner.toDouble()
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
            return (width + paddingInner.toDouble()).rounded()
        }
        return width + paddingInner.toDouble()
    }

    /// Maps the discrete item into a band.
    /// - Parameter value: A discrete item from the list provided as the domain for the scale.
    /// - Returns: A band that wraps the category found in the domain with start and end values for the range of the band, or `nil` if the value isn't contained by the domain.
    public func scale(_ value: CategoryType) -> Band<CategoryType, OutputType>? {
        if let x = domain.firstIndex(of: value), let step = step(), let width = width() {
            if width <= 0 {
                // when there's more padding than available space for the categories
                return nil
            }
            let doublePosition = Double(x) // 1
            let startLocation = paddingOuter.toDouble() + (doublePosition * step)
            let stopLocation = startLocation + width
            if round {
                return Band(lower: OutputType.fromDouble(startLocation.rounded()), higher: OutputType.fromDouble(stopLocation.rounded()), value: value)
            }
            return Band(lower: OutputType.fromDouble(startLocation), higher: OutputType.fromDouble(stopLocation), value: value)
        }
        return nil
    }

    /// Maps the discrete item into a band with the range values you provide..
    /// - Parameters:
    ///   - value: A discrete item from the list provided as the domain for the scale.
    ///   - from: The lower value of the range into which the discrete values map.
    ///   - to: The upper value of the range into which the discrete values map.
    /// - Returns: A band that wraps the category found in the domain with start and end values for the range of the band, or `nil` if the value isn't contained by the domain.
    public func scale(_ value: CategoryType, from: OutputType, to: OutputType) -> Band<CategoryType, OutputType>? {
        precondition(from < to, "attempting to set an inverted or empty range: \(from) to \(to)")
        let reconfiguredScale = type(of: self).init(domain, paddingInner: paddingInner, paddingOuter: paddingOuter, round: round, from: from, to: to)
        return reconfiguredScale.scale(value)
    }

    /// Maps the value from the range back to the discrete value that it matches.
    /// - Parameter location: A value within the range of the scale.
    /// - Returns: The item that matches at that value, or nil if the point is within padding or outside the range of the scale.
    public func invert(at location: OutputType) -> CategoryType? {
        guard let upperRange = to, let lowerRange = from else {
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
        let rangeExtentWithoutOuterPadding = upperRange.toDouble() - lowerRange.toDouble() - 2 * paddingOuter.toDouble()
        let unitRangeValue = (location.toDouble() - paddingOuter.toDouble()) / rangeExtentWithoutOuterPadding
        let rangeValueExpandedToCountDomain = unitRangeValue * Double(domain.count - 1)

        let closestIndex = Int(rangeValueExpandedToCountDomain.rounded())
        if let band = scale(domain[closestIndex]) {
            // Get the band for the item at that index and check to see if `at` is within its bounds.
            if location >= band.lower, location <= band.higher {
                return band.value
            }
        }
        return nil
    }

    /// Maps the value from the range values you provide back to the discrete value that it matches.
    /// - Parameters:
    ///   - at: A value within the range of the scale.
    ///   - from: The lower value of the range into which the discrete values map.
    ///   - to: The upper value of the range into which the discrete values map.
    /// - Returns: The item that matches at that value, or nil if the point is within padding or outside the range of the scale.
    public func invert(at: OutputType, from: OutputType, to: OutputType) -> CategoryType? {
        precondition(from < to, "attempting to set an inverted or empty range: \(from) to \(to)")
        let reconfiguredScale = type(of: self).init(domain, paddingInner: paddingInner, paddingOuter: paddingOuter, round: round, from: from, to: to)
        return reconfiguredScale.invert(at: at)
    }
}

/// A type used to indicate the start and stop positions for a band associated with the provided value.
public struct Band<EnclosedType, RangeType> {
    public let lower: RangeType
    public let higher: RangeType
    public let value: EnclosedType
}

// - https://github.com/d3/d3-scale#point-scales
// - https://github.com/pshrmn/notes/blob/master/d3/scales.md#point-scales
// - https://observablehq.com/@d3/d3-scalepoint

/// A type that maps values from a discrete _domain_ to a point within a continuous output _range_.
///
/// Point scales are useful for mapping discrete data from a collection to a collection of specific points.
/// If you are rendering a bar chart, consider using the ``BandScale`` instead.
public protocol PointScale {
    /// The type used for the scale's domain.
    associatedtype InputType: Collection
    /// The type used for the scale's range.
    associatedtype OutputType: ConvertibleWithDouble

    var round: Bool { get }
    var padding: OutputType { get }
    // effectively 'modifier' functions that return a new version of a scale
    func round(_: Bool) -> Self
    func padding(_: OutputType) -> Self

    var range: ClosedRange<OutputType>? { get }
    func range(from: OutputType, to: OutputType) -> Self //  -> something with step and width?

    func step() -> OutputType?
    func step(from: OutputType, to: OutputType) -> OutputType
    // return a step
    // configure with a `paddingOuter` (no `paddingInner`)
    // configure with `round` (rounds range value to nearest integer)

    func scale(_: InputType.Element, from: OutputType, to: OutputType) -> OutputType
    func scale(_: InputType.Element) -> OutputType?
    func invert(from: OutputType) -> InputType.Element?
}
