//
//  PowerScale.swift
//
//
//  Created by Joseph Heck on 3/10/22.
//

import Foundation
import Numerics
#if canImport(CoreGraphics)
    import CoreGraphics
#endif

/// A collection of power scales.
public enum PowerScale {
    /// A power scale created with a continuous input domain that provides methods to convert values within that domain to an output range.
    public struct DoubleToFloatScale: TickScale {
        public typealias InputType = Double
        public typealias OutputType = Float

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

        /// Transforms the input value using a power function and maps the resulting value into the range you provide.
        ///
        /// - Parameter domainValue: A value in the domain of the scale.
        /// - Parameter lower: The lower bound to the range to map to.
        /// - Parameter higher: The upper bound of the range to map to.
        /// - Returns: A value scaled by the power function, mapped to the range you provide.
        public func scale(_ domainValue: InputType, from lower: Float, to higher: Float) -> Float? {
            if let domainValue = transformAgainstDomain(domainValue) {
                let powDomainValue = pow(domainValue, exponent)
                let powDomainLower = pow(domainLower, exponent)
                let powDomainHigher = pow(domainHigher, exponent)
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
            let powDomainLower = pow(domainLower, exponent)
            let powDomainHigher = pow(domainHigher, exponent)
            let linearInterpolatedValue = interpolate(Double(normalizedRangeValue), lower: powDomainLower, higher: powDomainHigher)
            let domainValue = pow(linearInterpolatedValue, 1.0 / exponent)
            return transformAgainstDomain(domainValue)
        }
    }

    #if canImport(CoreGraphics)
        /// A power scale created with a continuous input domain that provides methods to convert values within that domain to an output range.
        public struct DoubleToCGFloatScale: TickScale {
            public typealias InputType = Double
            public typealias OutputType = CGFloat

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

            /// Transforms the input value using a power function and maps the resulting value into the range you provide.
            ///
            /// - Parameter domainValue: A value in the domain of the scale.
            /// - Parameter lower: The lower bound to the range to map to.
            /// - Parameter higher: The upper bound of the range to map to.
            /// - Returns: A value scaled by the power function, mapped to the range you provide.
            public func scale(_ domainValue: InputType, from lower: OutputType, to higher: OutputType) -> OutputType? {
                if let domainValue = transformAgainstDomain(domainValue) {
                    let powDomainValue = pow(domainValue, exponent)
                    let powDomainLower = pow(domainLower, exponent)
                    let powDomainHigher = pow(domainHigher, exponent)
                    let normalizedValueOnLogDomain = normalize(powDomainValue, lower: powDomainLower, higher: powDomainHigher)
                    let valueMappedToRange = interpolate(normalizedValueOnLogDomain, lower: lower, higher: higher)
                    return OutputType(valueMappedToRange)
                }
                return nil
            }

            /// Transforms a value within the range into the associated domain value.
            /// - Parameters:
            ///   - rangeValue: A value in the range of the scale.
            ///   - lower: The lower bound to the range to map from.
            ///   - higher: The upper bound to the range to map from.
            /// - Returns: A value mapped from the range back into the domain using an inverse power transform.
            public func invert(_ rangeValue: OutputType, from lower: OutputType, to higher: OutputType) -> InputType? {
                let normalizedRangeValue = normalize(Double(rangeValue), lower: Double(lower), higher: Double(higher))
                let powDomainLower = pow(domainLower, exponent)
                let powDomainHigher = pow(domainHigher, exponent)
                let linearInterpolatedValue = interpolate(Double(normalizedRangeValue), lower: powDomainLower, higher: powDomainHigher)
                let domainValue = pow(linearInterpolatedValue, 1.0 / exponent)
                return transformAgainstDomain(domainValue)
            }
        }#endif

    // MARK: - Factory (convenience) Methods

    // Double

    /// Creates a power scale that maps values between the lower and upper bounds you provide.
    /// - Parameters:
    ///   - low: The lower bounds of the domain.
    ///   - high: The upper bounds of the domain.
    ///   - exponent: The exponent for the power transform.
    public static func create(_ low: Double, _ high: Double, exponent: Double) -> PowerScale.DoubleToFloatScale {
        PowerScale.DoubleToFloatScale(from: low, to: high, exponent: exponent)
    }

    /// Creates a power scale that maps values within the range you provide.
    /// - Parameter range: The range of the domain.
    /// - Parameter exponent: The exponent for the power transform.
    public static func create(_ range: ClosedRange<Double>, exponent: Double) -> PowerScale.DoubleToFloatScale {
        PowerScale.DoubleToFloatScale(from: range.lowerBound, to: range.upperBound, exponent: exponent)
    }

    /// Creates a power scale that maps values from 0 to the upper bound you provide.
    /// - Parameter high: The upper bounds of the domain.
    /// - Parameter exponent: The exponent for the power transform.
    public static func create(_ high: Double, exponent: Double) -> PowerScale.DoubleToFloatScale {
        PowerScale.DoubleToFloatScale(from: 0, to: high, exponent: exponent)
    }
}
