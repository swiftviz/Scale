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
    public let domainLower: InputType
    public let domainHigher: InputType
    public let domainExtent: InputType

    public let exponent: Double

    public let transformType: DomainDataTransform
    public let desiredTicks: Int

    /// Creates a new power scale for the upper and lower bounds of the domain you provide.
    /// - Parameters:
    ///   - lower: The lower bound of the scale's domain.
    ///   - higher: The upper bound of the scale's domain.
    ///   - exponent: The exponent for the power transforming, defaulting to `1`.
    ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
    ///   - desiredTicks: The desired number of ticks when visually representing the scale.
    public init(from lower: InputType, to higher: InputType, exponent: Double = 1, transform: DomainDataTransform = .none, desiredTicks: Int = 10) {
        precondition(lower < higher)
        transformType = transform
        domainLower = lower
        domainHigher = higher
        domainExtent = higher - lower
        self.exponent = exponent
        self.desiredTicks = desiredTicks
    }

    public init(_ range: ClosedRange<InputType>, exponent: Double = 1, transform: DomainDataTransform = .none, desiredTicks: Int = 10) {
        self.init(from: range.lowerBound, to: range.upperBound, exponent: exponent, transform: transform, desiredTicks: desiredTicks)
    }

    public init(_ single: InputType, exponent: Double = 1, transform: DomainDataTransform = .none, desiredTicks: Int = 10) {
        if single > 0 {
            self.init(from: 0, to: single, exponent: exponent, transform: transform, desiredTicks: desiredTicks)
        } else {
            self.init(from: single, to: 0, exponent: exponent, transform: transform, desiredTicks: desiredTicks)
        }
    }

    /// Transforms the input value using a power function and maps the resulting value into the range you provide.
    ///
    /// - Parameter domainValue: A value in the domain of the scale.
    /// - Parameter lower: The lower bound to the range to map to.
    /// - Parameter higher: The upper bound of the range to map to.
    /// - Returns: A value scaled by the power function, mapped to the range you provide.
    public func scale(_ domainValue: InputType, from lower: Float, to higher: Float) -> Float? {
        if let domainValue = transformAgainstDomain(domainValue) {
            let powDomainValue = pow(domainValue.toDouble(), exponent)
            let powDomainLower = pow(domainLower.toDouble(), exponent)
            let powDomainHigher = pow(domainHigher.toDouble(), exponent)
            let normalizedValueOnLogDomain = normalize(powDomainValue, lower: powDomainLower, higher: powDomainHigher)
            let valueMappedToRange = interpolate(Float(normalizedValueOnLogDomain), lower: lower, higher: higher)
            return valueMappedToRange
        }
        return nil
    }

    /// Transforms a value within the range into the associated domain value.
    /// - Parameters:
    ///   - rangeValue: A value in the range of the scale.
    ///   - lower: The lower bound to the range to map from.
    ///   - higher: The upper bound to the range to map from.
    /// - Returns: A value mapped from the range back into the domain using an inverse power transform.
    public func invert(_ rangeValue: Float, from lower: Float, to higher: Float) -> InputType? {
        let normalizedRangeValue = normalize(rangeValue, lower: lower, higher: higher)
        let powDomainLower = pow(domainLower.toDouble(), exponent)
        let powDomainHigher = pow(domainHigher.toDouble(), exponent)
        let linearInterpolatedValue = interpolate(Double(normalizedRangeValue), lower: powDomainLower, higher: powDomainHigher)
        let domainValue = pow(linearInterpolatedValue, 1.0 / exponent)
        let downcastDomainValue = InputType.fromDouble(domainValue)
        return transformAgainstDomain(downcastDomainValue)
    }
}
