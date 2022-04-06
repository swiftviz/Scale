//
//  PowerScale.swift
//
//
//  Created by Joseph Heck on 3/10/22.
//

import Foundation
import Numerics

/// A power scale created with a continuous input domain that provides methods to convert values within that domain to an output range.
public struct PowerScale<InputType: ConvertibleWithDouble & NiceValue, OutputType: ConvertibleWithDouble>: TickScale {
    /// The lower bound of the input domain.
    public let domainLower: InputType
    /// The upper bound of the input domain.
    public let domainHigher: InputType
    /// The distance or length between the upper and lower bounds of the input domain.
    public let domainExtent: InputType

    /// The lower bound of the input domain.
    public let rangeLower: OutputType?
    /// The upper bound of the input domain.
    public let rangeHigher: OutputType?

    /// The type of continuous scale.
    public var scaleType: ContinuousScaleTypes {
        .power(exponent)
    }

    /// A transformation value that indicates whether the output vales are constrained to the min and max of the output range.
    ///
    /// If `true`, values processed by the scale are constrained to the output range, and values processed backwards through the scale
    /// are constrained to the input domain.
    public var transformType: DomainDataTransform

    /// The number of ticks desired when creating the scale.
    ///
    /// This number may not match the number of ticks returned by ``TickScale/tickValues(_:from:to:)``
    public let desiredTicks: Int

    /// The exponent value of the scale.
    public let exponent: Double

    /// Creates a new power scale for the upper and lower bounds of the domain you provide.
    /// - Parameters:
    ///   - lower: The lower bound for the scale's domain.
    ///   - higher: The upper bound for the scale's domain.
    ///   - exponent: The exponent for the power transforming, defaulting to `1`.
    ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
    ///   - desiredTicks: The desired number of ticks when visually representing the scale.
    public init(from lower: InputType = 0, to higher: InputType = 1, exponent: Double = 1, transform: DomainDataTransform = .none, desiredTicks: Int = 10, rangeLower: OutputType? = nil, rangeHigher: OutputType? = nil) {
        precondition(lower < higher, "attempting to set an inverted or empty domain: \(lower) to \(higher)")
        transformType = transform
        domainLower = lower
        domainHigher = higher
        domainExtent = higher - lower
        self.exponent = exponent
        self.desiredTicks = desiredTicks
        if let rangeLower = rangeLower, let rangeHigher = rangeHigher {
            precondition(lower < higher, "attempting to set an inverted or empty range: \(rangeLower) to \(rangeHigher)")
        }
        self.rangeLower = rangeLower
        self.rangeHigher = rangeHigher
    }

    /// Creates a new power scale for the upper and lower bounds of the domain range you provide.
    /// - Parameters:
    ///   - range: The range of the scale's domain.
    ///   - exponent: The exponent for the power transforming, defaulting to `1`.
    ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
    ///   - desiredTicks: The desired number of ticks when visually representing the scale.
    public init(_ range: ClosedRange<InputType>, exponent: Double = 1, transform: DomainDataTransform = .none, desiredTicks: Int = 10, rangeLower: OutputType? = nil, rangeHigher: OutputType? = nil) {
        self.init(from: range.lowerBound, to: range.upperBound, exponent: exponent, transform: transform, desiredTicks: desiredTicks, rangeLower: rangeLower, rangeHigher: rangeHigher)
    }

    /// Creates a new power scale for the domain of `0` to the value you provide.
    ///
    /// If the value you provide is less than `0`, the domain of the scale ranges from the value you provide to `0`.
    /// If the value you provide is greater than `0`, the domain of the scale ranges from `0` to the value you provide.
    /// - Parameters:
    ///   - single: The upper, or lower, bound for the domain.
    ///   - exponent: The exponent for the power transforming, defaulting to `1`.
    ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
    ///   - desiredTicks: The desired number of ticks when visually representing the scale.
    public init(_ single: InputType, exponent: Double = 1, transform: DomainDataTransform = .none, desiredTicks: Int = 10, rangeLower: OutputType? = nil, rangeHigher: OutputType? = nil) {
        if single > 0 {
            self.init(from: 0, to: single, exponent: exponent, transform: transform, desiredTicks: desiredTicks, rangeLower: rangeLower, rangeHigher: rangeHigher)
        } else {
            self.init(from: single, to: 0, exponent: exponent, transform: transform, desiredTicks: desiredTicks, rangeLower: rangeLower, rangeHigher: rangeHigher)
        }
    }

    // testing function
    internal func fullyConfigured() -> Bool {
        rangeLower != nil && rangeHigher != nil
    }

    // MARK: - modifier functions

    /// Returns a new scale with the domain set to the values you provide.
    /// - Parameters:
    ///   - lower: The lower bound for the scale's domain.
    ///   - higher: The upper bound for the scale's domain.
    /// - Returns: A copy of the scale with the domain values you provide.
    public func domain(lower: InputType, higher: InputType) -> Self {
        type(of: self).init(from: lower, to: higher, transform: transformType, desiredTicks: desiredTicks, rangeLower: rangeLower, rangeHigher: rangeHigher)
    }

    /// Returns a new scale with the domain set to the values you provide.
    /// - Parameters:
    ///   - range: The range to apply as the scale's domain
    /// - Returns: A copy of the scale with the domain values you provide.
    public func domain(_ range: ClosedRange<InputType>) -> Self {
        type(of: self).init(from: range.lowerBound, to: range.upperBound, transform: transformType, desiredTicks: desiredTicks, rangeLower: rangeLower, rangeHigher: rangeHigher)
    }

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - lower: The lower bound for the scale's range.
    ///   - higher: The upper bound for the scale's range.
    /// - Returns: A copy of the scale with the range values you provide.
    public func range(lower: OutputType, higher: OutputType) -> Self {
        type(of: self).init(from: domainLower, to: domainHigher, transform: transformType, desiredTicks: desiredTicks, rangeLower: lower, rangeHigher: higher)
    }

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - range: The range to apply as the scale's range.
    /// - Returns: A copy of the scale with the range values you provide.
    public func range(_ range: ClosedRange<OutputType>) -> Self {
        type(of: self).init(from: domainLower, to: domainHigher, transform: transformType, desiredTicks: desiredTicks, rangeLower: range.lowerBound, rangeHigher: range.upperBound)
    }

    /// Returns a new scale with the transform set to the value you provide.
    /// - Parameters:
    ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
    /// - Returns: A copy of the scale with the transform setting you provide.
    public func transform(_ transform: DomainDataTransform) -> Self {
        type(of: self).init(from: domainLower, to: domainHigher, transform: transform, desiredTicks: desiredTicks, rangeLower: rangeLower, rangeHigher: rangeHigher)
    }

    // MARK: - scale functions

    /// Transforms the input value using a power function and maps the resulting value into the range you provide.
    ///
    /// - Parameter domainValue: A value in the domain of the scale.
    /// - Returns: A value scaled by the power function, mapped to the range you provide.
    public func scale(_ domainValue: InputType) -> OutputType? {
        guard let domainValue = transformAgainstDomain(domainValue), let rangeLower = rangeLower, let rangeHigher = rangeHigher else {
            return nil
        }
        let powDomainValue = pow(domainValue.toDouble(), exponent)
        let powDomainLower = pow(domainLower.toDouble(), exponent)
        let powDomainHigher = pow(domainHigher.toDouble(), exponent)
        let normalizedValueOnPowDomain = normalize(powDomainValue, lower: powDomainLower, higher: powDomainHigher)
        let valueMappedToRange = interpolate(normalizedValueOnPowDomain, lower: rangeLower.toDouble(), higher: rangeHigher.toDouble())
        return OutputType.fromDouble(valueMappedToRange)
    }

    /// Transforms the input value using a power function and maps the resulting value into the range you provide.
    ///
    /// - Parameter domainValue: A value in the domain of the scale.
    /// - Parameter lower: The lower bound to the range to map to.
    /// - Parameter higher: The upper bound of the range to map to.
    /// - Returns: A value scaled by the power function, mapped to the range you provide.
    public func scale(_ domainValue: InputType, from lower: OutputType, to higher: OutputType) -> OutputType? {
        let reconfiguredScale = range(lower: lower, higher: higher)
        return reconfiguredScale.scale(domainValue)
    }

    /// Transforms a value within the range into the associated domain value.
    /// - Parameters:
    ///   - rangeValue: A value in the range of the scale.
    ///   - lower: The lower bound to the range to map from.
    ///   - higher: The upper bound to the range to map from.
    /// - Returns: A value mapped from the range back into the domain using an inverse power transform.
    public func invert(_ rangeValue: OutputType) -> InputType? {
        guard let rangeLower = rangeLower, let rangeHigher = rangeHigher else {
            return nil
        }
        let normalizedRangeValue = normalize(rangeValue.toDouble(), lower: rangeLower.toDouble(), higher: rangeHigher.toDouble())
        let powDomainLower = pow(domainLower.toDouble(), exponent)
        let powDomainHigher = pow(domainHigher.toDouble(), exponent)
        let linearInterpolatedValue = interpolate(Double(normalizedRangeValue), lower: powDomainLower, higher: powDomainHigher)
        let domainValue = pow(linearInterpolatedValue, 1.0 / exponent)
        let downcastDomainValue = InputType.fromDouble(domainValue)
        return transformAgainstDomain(downcastDomainValue)
    }

    /// Transforms a value within the range into the associated domain value.
    /// - Parameters:
    ///   - rangeValue: A value in the range of the scale.
    ///   - lower: The lower bound to the range to map from.
    ///   - higher: The upper bound to the range to map from.
    /// - Returns: A value mapped from the range back into the domain using an inverse power transform.
    public func invert(_ rangeValue: OutputType, from lower: OutputType, to higher: OutputType) -> InputType? {
        let reconfiguredScale = range(lower: lower, higher: higher)
        return reconfiguredScale.invert(rangeValue)
    }
}
