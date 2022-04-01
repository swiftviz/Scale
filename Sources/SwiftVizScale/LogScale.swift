//
//  LogScale.swift
//
//  Created by Joseph Heck on 3/3/20.

import Foundation
import Numerics

/// A logarithmic scale created with a continuous input domain that provides methods to convert values within that domain to an output range.
public struct LogScale<InputType: ConvertibleWithDouble & NiceValue, OutputType: ConvertibleWithDouble>: TickScale {
    /// The lower bound of the input domain.
    public let domainLower: InputType
    /// The upper bound of the input domain.
    public let domainHigher: InputType
    /// The distance or length between the upper and lower bounds of the input domain.
    public let domainExtent: InputType

    /// A transformation value that indicates whether the output vales are constrained to the min and max of the output range.
    ///
    /// If `true`, values processed by the scale are constrained to the output range, and values processed backwards through the scale
    /// are constrained to the input domain.
    public var transformType: DomainDataTransform

    /// A Boolean value that indicates the scale was configured without an explicit domain.
    ///
    /// Use ``withDomain(lower:higher:)`` to create a new scale with an explicit domain while keeping the same ``transformType``.
    public let defaultDomain: Bool

    /// The number of ticks desired when creating the scale.
    ///
    /// This number may not match the number of ticks returned by ``TickScale/tickValues(_:from:to:)``
    public let desiredTicks: Int

    /// Creates a new logarithmic scale for the upper and lower bounds of the domain you provide.
    /// - Parameters:
    ///   - lower: The lower bound for the scale's domain.
    ///   - higher: The upper bound for the scale's domain.
    ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
    ///   - desiredTicks: The desired number of ticks when visually representing the scale.
    public init(from lower: InputType, to higher: InputType, transform: DomainDataTransform = .none, desiredTicks: Int = 10) {
        precondition(lower < higher)
        precondition(lower.toDouble() > 0.0)
        transformType = transform
        domainLower = lower
        domainHigher = higher
        domainExtent = higher - lower
        self.desiredTicks = desiredTicks
        defaultDomain = false
    }

    /// Creates a new logarithmic scale for the upper and lower bounds of the domain range you provide.
    /// - Parameters:
    ///   - range: The range of the scale's domain.
    ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
    ///   - desiredTicks: The desired number of ticks when visually representing the scale.
    public init(_ range: ClosedRange<InputType>, transform: DomainDataTransform = .none, desiredTicks: Int = 10) {
        self.init(from: range.lowerBound, to: range.upperBound, transform: transform, desiredTicks: desiredTicks)
    }

    /// Returns a new scale with the domain set to the values you provide.
    /// - Parameters:
    ///   - lower: The lower bound for the scale's domain.
    ///   - higher: The upper bound for the scale's domain.
    /// - Returns: A replica of the scale, preserving ``transformType`` while applying new domain values.
    public func withDomain(lower: InputType, higher: InputType) -> LogScale<InputType, OutputType> {
        type(of: self).init(from: lower, to: higher, transform: transformType, desiredTicks: desiredTicks)
    }

    /// Transforms the input value using a linear function to the resulting value into the range you provide.
    ///
    /// - Parameter domainValue: A value in the domain of the scale.
    /// - Parameter lower: The lower bound to the range to map to.
    /// - Parameter higher: The upper bound of the range to map to.
    /// - Returns: A value mapped to the range you provide.
    public func scale(_ domainValue: InputType, from lower: OutputType, to higher: OutputType) -> OutputType? {
        if let domainValue = transformAgainstDomain(domainValue) {
            let logDomainValue = log10(domainValue.toDouble())
            let logDomainLower = log10(domainLower.toDouble())
            let logDomainHigher = log10(domainHigher.toDouble())
            let normalizedValueOnLogDomain = normalize(logDomainValue, lower: logDomainLower, higher: logDomainHigher)
            let valueMappedToRange = interpolate(normalizedValueOnLogDomain, lower: lower.toDouble(), higher: higher.toDouble())
            return OutputType.fromDouble(valueMappedToRange)
        }
        return nil
    }

    /// Transforms a value within the range into the associated domain value.
    /// - Parameters:
    ///   - rangeValue: A value in the range of the scale.
    ///   - lower: The lower bound to the range to map from.
    ///   - higher: The upper bound to the range to map from.
    /// - Returns: A value linearly mapped from the range back into the domain.
    public func invert(_ rangeValue: OutputType, from lower: OutputType, to higher: OutputType) -> InputType? {
        let normalizedRangeValue = normalize(rangeValue.toDouble(), lower: lower.toDouble(), higher: higher.toDouble())
        let logDomainLower = log10(domainLower.toDouble())
        let logDomainHigher = log10(domainHigher.toDouble())
        let linearInterpolatedValue = interpolate(Double(normalizedRangeValue), lower: logDomainLower, higher: logDomainHigher)
        let domainValue = pow(10, linearInterpolatedValue)
        let downcastDomainValue = InputType.fromDouble(domainValue)
        return transformAgainstDomain(downcastDomainValue)
    }
}
