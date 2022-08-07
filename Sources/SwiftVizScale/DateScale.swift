//
//  DateScale.swift
//

import Foundation

public struct DateScale<OutputType: BinaryFloatingPoint>: ReversibleScale, CustomStringConvertible {
    public typealias InputType = Date

    /// The lower bound of the input domain.
    public let domainLower: Date
    /// The upper bound of the input domain.
    public let domainHigher: Date

    /// The lower bound of the output range.
    public var rangeLower: OutputType? {
        _doubleScale.rangeLower
    }

    /// The upper bound of the output range.
    public var rangeHigher: OutputType? {
        _doubleScale.rangeHigher
    }

    /// The type of continuous scale.
    public var scaleType: ContinuousScaleType {
        _doubleScale.scaleType
    }

    /// A Boolean value that indicates if the mapping from domain to range is inverted.
    public var reversed: Bool {
        _doubleScale.reversed
    }

    /// A transformation value that indicates whether the output vales are constrained to the min and max of the output range.
    ///
    /// If `true`, values processed by the scale are constrained to the output range, and values processed backwards through the scale
    /// are constrained to the input domain.
    public var transformType: DomainDataTransform {
        _doubleScale.transformType
    }

    /// The number of ticks desired when presenting results using the scale.
    public var desiredTicks: Int {
        _doubleScale.desiredTicks
    }

    private let _doubleScale: ContinuousScale<OutputType>

    /// Creates a new scale for the upper and lower bounds of the domain you provide.
    /// - Parameters:
    ///   - lower: The lower bound for the scale's domain.
    ///   - higher: The upper bound for the scale's domain.
    public init(lower: Date, higher: Date) {
        self.init(lower: lower, higher: higher, scale: ContinuousScale<OutputType>(lower: lower.timeIntervalSinceReferenceDate, higher: higher.timeIntervalSinceReferenceDate))
    }

    private init(lower: Date,
                 higher: Date,
                 scale: ContinuousScale<OutputType>)
    {
        precondition(lower < higher)
        domainLower = lower
        domainHigher = higher
        _doubleScale = scale
    }

    // MARK: - description

    /// A description of the scale.
    public var description: String {
        "\(scaleType)(xform:\(transformType))[\(domainLower):\(domainHigher)]->[\(String(describing: rangeLower)):\(String(describing: rangeHigher))]"
    }

    // MARK: - modifier functions

    /// Returns a new scale with the domain set to the values you provide.
    /// - Parameters:
    ///   - lower: The lower bound for the scale's domain.
    ///   - higher: The upper bound for the scale's domain.
    /// - Returns: A copy of the scale with the domain values you provide.
    public func domain(lower: Date, higher: Date) -> Self {
        precondition(lower < higher)
        return Self(lower: lower, higher: higher, scale: _doubleScale.domain(lower: lower.timeIntervalSinceReferenceDate, higher: higher.timeIntervalSinceReferenceDate))
    }

    /// Returns a new scale with the domain set to the values you provide.
    /// - Parameters:
    ///   - values: An array of dates that defines the range of input values.
    /// - Returns: A copy of the scale with the domain values you provide.
    public func domain(_ values: [Date]) -> Self {
        domain(values, nice: true)
    }

    /// Returns a new scale with the domain set to span the values you provide.
    /// - Parameter nice: A Boolean value that indicates whether to expand the domain to visually nice values.
    /// - Parameter values: An array of dates.
    public func domain(_ values: [Date], nice _: Bool = true) -> Self {
        precondition(values.count > 1)
        let sortedValues = values.sorted()
        guard let min = sortedValues.min(), let max = sortedValues.max() else {
            return self
        }
        precondition(min < max)
//        if nice {
//            let bottom = Date.niceMinimumValueForRange(min: min, max: max)
//            let top = Date.niceVersion(for: max, trendTowardsZero: false)
//            return domain(lower: bottom, higher: top)
//        } else {
//            return domain(lower: min, higher: max)
//        }
        return domain(lower: min, higher: max)
    }

    /// Returns a new scale with the transform set to the value you provide.
    /// - Parameters:
    ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
    /// - Returns: A copy of the scale with the transform setting you provide.
    public func transform(_ transform: DomainDataTransform) -> Self {
        Self(lower: domainLower, higher: domainHigher, scale: _doubleScale.transform(transform))
    }

    /// Returns a new scale with the type of scale set to the type you provide.
    /// - Parameter scaleType: The type of continuous scale.
    public func scaleType(_ scaleType: ContinuousScaleType) -> Self {
        Self(lower: domainLower, higher: domainHigher, scale: _doubleScale.scaleType(scaleType))
    }

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    ///   - lower: The lower bound for the scale's range.
    ///   - higher: The upper bound for the scale's range.
    /// - Returns: A copy of the scale with the range values you provide.
    public func range(reversed: Bool, lower: OutputType, higher: OutputType) -> Self {
        Self(lower: domainLower, higher: domainHigher, scale: _doubleScale.range(reversed: reversed, lower: lower, higher: higher))
    }

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - lower: The lower bound for the scale's range.
    ///   - higher: The upper bound for the scale's range.
    /// - Returns: A copy of the scale with the range values you provide.
    public func range(lower: OutputType, higher: OutputType) -> Self {
        Self(lower: domainLower, higher: domainHigher, scale: _doubleScale.range(lower: lower, higher: higher))
    }

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    ///   - range: The range to apply as the scale's range.
    /// - Returns: A copy of the scale with the range values you provide.
    public func range(reversed: Bool, _ range: ClosedRange<OutputType>) -> Self {
        Self(lower: domainLower, higher: domainHigher, scale: _doubleScale.range(reversed: reversed, lower: range.lowerBound, higher: range.upperBound))
    }

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - range: The range to apply as the scale's range.
    /// - Returns: A copy of the scale with the range values you provide.
    public func range(_ range: ClosedRange<OutputType>) -> Self {
        Self(lower: domainLower, higher: domainHigher, scale: _doubleScale.range(lower: range.lowerBound, higher: range.upperBound))
    }

    // MARK: - scale functions

    /// Transforms the input value to the resulting value into the range you provide.
    ///
    /// The input value is first verified against the domain settings for the scale based on the ``transformType`` set for the scale.
    /// The value is then transformed using a function based on the ``scaleType``, interpolated between ``domainLower`` and ``domainHigher``, then mapped to the range taking into account the scale's ``reversed`` setting.
    ///
    /// - Parameter domainValue: A value in the domain of the scale.
    /// - Returns: A value mapped to the range you provide.
    public func scale(_ domainValue: Date) -> OutputType? {
        _doubleScale.scale(domainValue.timeIntervalSinceReferenceDate)
    }

    // MARK: - reversible scale functions

    /// Transforms a value within the range into an associated domain value.
    /// - Parameters:
    ///   - rangeValue: A value in the range of the scale.
    ///   - lower: The lower bound to the range to map from.
    ///   - higher: The upper bound to the range to map from.
    /// - Returns: A value linearly mapped from the range back into the domain.
    public func invert(_ rangeValue: OutputType) -> Date? {
        guard let doubleAtDate = _doubleScale.invert(rangeValue) else {
            return nil
        }
        return Date(timeIntervalSinceReferenceDate: doubleAtDate)
    }
}
