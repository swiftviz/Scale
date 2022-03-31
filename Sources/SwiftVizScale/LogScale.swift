//
//  LogScale.swift
//
//  Created by Joseph Heck on 3/3/20.

import Foundation
import Numerics
#if canImport(CoreGraphics)
    import CoreGraphics
#endif

/// A collection of logarithmic scales.
public enum LogScale {
    /// A logarithmic scale created with a continuous input domain that provides methods to convert values within that domain to an output range.
    public struct DoubleToFloatScale: TickScale {
        /// The type used for the scale's domain.
        public typealias InputType = Double
        /// The type used for the scale's range.
        public typealias OutputType = Float

        /// The lower bound of the input domain.
        public let domainLower: InputType
        /// The upper bound of the input domain.
        public let domainHigher: InputType
        /// The distance or length between the upper and lower bounds of the input domain.
        public let domainExtent: InputType

        /// A boolean value that indicates whether the output vales are constrained to the min and max of the output range.
        ///
        /// If `true`, values processed by the scale are constrained to the output range, and values processed backwards through the scale
        /// are constrained to the input domain.
        public var transformType: DomainDataTransform

        /// The number of ticks desired when creating the scale.
        ///
        /// This number may not match the number of ticks returned by ``TickScale/tickValues(_:from:to:)``
        public let desiredTicks: Int

        /// Creates a new logarithmic scale for the upper and lower bounds of the domain you provide.
        /// - Parameters:
        ///   - lower: The lower bound of the scale's domain.
        ///   - higher: The upper bound of the scale's domain.
        ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
        ///   - desiredTicks: The desired number of ticks when visually representing the scale.
        public init(from lower: InputType, to higher: InputType, transform: DomainDataTransform = .none, desiredTicks: Int = 10) {
            precondition(lower < higher)
            precondition(lower > 0.0)
            transformType = transform
            domainLower = lower
            domainHigher = higher
            domainExtent = higher - lower
            self.desiredTicks = desiredTicks
        }

        /// Transforms the input value using a linear function to the resulting value into the range you provide.
        ///
        /// - Parameter domainValue: A value in the domain of the scale.
        /// - Parameter lower: The lower bound to the range to map to.
        /// - Parameter higher: The upper bound of the range to map to.
        /// - Returns: A value mapped to the range you provide.
        public func scale(_ domainValue: InputType, from lower: Float, to higher: Float) -> Float? {
            if let domainValue = transformAgainstDomain(domainValue) {
                let logDomainValue = log10(domainValue)
                let logDomainLower = log10(domainLower)
                let logDomainHigher = log10(domainHigher)
                let normalizedValueOnLogDomain = normalize(logDomainValue, lower: logDomainLower, higher: logDomainHigher)
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
        /// - Returns: A value linearly mapped from the range back into the domain.
        public func invert(_ rangeValue: Float, from lower: Float, to higher: Float) -> InputType? {
            let normalizedRangeValue = normalize(rangeValue, lower: lower, higher: higher)
            let logDomainLower = log10(domainLower)
            let logDomainHigher = log10(domainHigher)
            let linearInterpolatedValue = interpolate(Double(normalizedRangeValue), lower: logDomainLower, higher: logDomainHigher)
            let domainValue = pow(10, linearInterpolatedValue)
            return transformAgainstDomain(domainValue)
        }
    }

    #if canImport(CoreGraphics)
        /// A logarithmic scale created with a continuous input domain that provides methods to convert values within that domain to an output range.
        public struct DoubleToCGFloatScale: TickScale {
            /// The type used for the scale's domain.
            public typealias InputType = Double
            /// The type used for the scale's range.
            public typealias OutputType = CGFloat

            /// The lower bound of the input domain.
            public let domainLower: InputType
            /// The upper bound of the input domain.
            public let domainHigher: InputType
            /// The distance or length between the upper and lower bounds of the input domain.
            public let domainExtent: InputType

            /// A boolean value that indicates whether the output vales are constrained to the min and max of the output range.
            ///
            /// If `true`, values processed by the scale are constrained to the output range, and values processed backwards through the scale
            /// are constrained to the input domain.
            public var transformType: DomainDataTransform

            /// The number of ticks desired when creating the scale.
            ///
            /// This number may not match the number of ticks returned by ``TickScale/tickValues(_:from:to:)``
            public let desiredTicks: Int

            /// Creates a new logarithmic scale for the upper and lower bounds of the domain you provide.
            /// - Parameters:
            ///   - lower: The lower bound of the scale's domain.
            ///   - higher: The upper bound of the scale's domain.
            ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
            ///   - desiredTicks: The desired number of ticks when visually representing the scale.
            public init(from lower: InputType, to higher: InputType, transform: DomainDataTransform = .none, desiredTicks: Int = 10) {
                precondition(lower < higher)
                precondition(lower > 0.0)
                transformType = transform
                domainLower = lower
                domainHigher = higher
                domainExtent = higher - lower
                self.desiredTicks = desiredTicks
            }

            /// Transforms the input value using a linear function to the resulting value into the range you provide.
            ///
            /// - Parameter domainValue: A value in the domain of the scale.
            /// - Parameter lower: The lower bound to the range to map to.
            /// - Parameter higher: The upper bound of the range to map to.
            /// - Returns: A value mapped to the range you provide.
            public func scale(_ domainValue: InputType, from lower: OutputType, to higher: OutputType) -> OutputType? {
                if let domainValue = transformAgainstDomain(domainValue) {
                    let logDomainValue = log10(domainValue)
                    let logDomainLower = log10(domainLower)
                    let logDomainHigher = log10(domainHigher)
                    let normalizedValueOnLogDomain = normalize(logDomainValue, lower: logDomainLower, higher: logDomainHigher)
                    let valueMappedToRange = interpolate(normalizedValueOnLogDomain, lower: lower, higher: higher)
                    return CGFloat(valueMappedToRange)
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
                let normalizedRangeValue = normalize(rangeValue, lower: Double(lower), higher: Double(higher))
                let logDomainLower = log10(domainLower)
                let logDomainHigher = log10(domainHigher)
                let linearInterpolatedValue = interpolate(Double(normalizedRangeValue), lower: logDomainLower, higher: logDomainHigher)
                let domainValue = pow(10, linearInterpolatedValue)
                return transformAgainstDomain(domainValue)
            }
        }

    #endif

    public struct FloatToFloatScale: TickScale {
        /// The type used for the scale's domain.
        public typealias InputType = Float
        /// The type used for the scale's range.
        public typealias OutputType = Float

        /// The lower bound of the input domain.
        public let domainLower: InputType
        /// The upper bound of the input domain.
        public let domainHigher: InputType
        /// The distance or length between the upper and lower bounds of the input domain.
        public let domainExtent: InputType

        /// A boolean value that indicates whether the output vales are constrained to the min and max of the output range.
        ///
        /// If `true`, values processed by the scale are constrained to the output range, and values processed backwards through the scale
        /// are constrained to the input domain.
        public var transformType: DomainDataTransform

        /// The number of ticks desired when creating the scale.
        ///
        /// This number may not match the number of ticks returned by ``TickScale/tickValues(_:from:to:)``
        public let desiredTicks: Int

        /// Creates a new logarithmic scale for the upper and lower bounds of the domain you provide.
        /// - Parameters:
        ///   - lower: The lower bound of the scale's domain.
        ///   - higher: The upper bound of the scale's domain.
        ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
        ///   - desiredTicks: The desired number of ticks when visually representing the scale.
        public init(from lower: InputType, to higher: InputType, transform: DomainDataTransform = .none, desiredTicks: Int = 10) {
            precondition(lower < higher)
            precondition(lower > 0.0)
            transformType = transform
            domainLower = lower
            domainHigher = higher
            domainExtent = higher - lower
            self.desiredTicks = desiredTicks
        }

        /// Transforms the input value using a linear function to the resulting value into the range you provide.
        ///
        /// - Parameter domainValue: A value in the domain of the scale.
        /// - Parameter lower: The lower bound to the range to map to.
        /// - Parameter higher: The upper bound of the range to map to.
        /// - Returns: A value mapped to the range you provide.
        public func scale(_ domainValue: InputType, from lower: Float, to higher: Float) -> Float? {
            if let domainValue = transformAgainstDomain(domainValue) {
                let logDomainValue = log10(domainValue)
                let logDomainLower = log10(domainLower)
                let logDomainHigher = log10(domainHigher)
                let normalizedValueOnLogDomain = normalize(logDomainValue, lower: logDomainLower, higher: logDomainHigher)
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
        /// - Returns: A value linearly mapped from the range back into the domain.
        public func invert(_ rangeValue: Float, from lower: Float, to higher: Float) -> InputType? {
            let normalizedRangeValue = normalize(rangeValue, lower: lower, higher: higher)
            let logDomainLower = log10(domainLower)
            let logDomainHigher = log10(domainHigher)
            let linearInterpolatedValue = interpolate(Float(normalizedRangeValue), lower: logDomainLower, higher: logDomainHigher)
            let domainValue = pow(10, linearInterpolatedValue)
            return transformAgainstDomain(domainValue)
        }
    }

    public struct IntToFloatScale: TickScale {
        /// The type used for the scale's domain.
        public typealias InputType = Int
        /// The type used for the scale's range.
        public typealias OutputType = Float

        /// The lower bound of the input domain.
        public let domainLower: InputType
        /// The upper bound of the input domain.
        public let domainHigher: InputType
        /// The distance or length between the upper and lower bounds of the input domain.
        public let domainExtent: InputType

        /// A boolean value that indicates whether the output vales are constrained to the min and max of the output range.
        ///
        /// If `true`, values processed by the scale are constrained to the output range, and values processed backwards through the scale
        /// are constrained to the input domain.
        public var transformType: DomainDataTransform

        /// The number of ticks desired when creating the scale.
        ///
        /// This number may not match the number of ticks returned by ``TickScale/tickValues(_:from:to:)``
        public let desiredTicks: Int

        /// Creates a new logarithmic scale for the upper and lower bounds of the domain you provide.
        /// - Parameters:
        ///   - lower: The lower bound of the scale's domain.
        ///   - higher: The upper bound of the scale's domain.
        ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
        ///   - desiredTicks: The desired number of ticks when visually representing the scale.
        public init(from lower: InputType, to higher: InputType, transform: DomainDataTransform = .none, desiredTicks: Int = 10) {
            precondition(lower < higher)
            precondition(lower > 0)
            transformType = transform
            domainLower = lower
            domainHigher = higher
            domainExtent = higher - lower
            self.desiredTicks = desiredTicks
        }

        /// Transforms the input value using a linear function to the resulting value into the range you provide.
        ///
        /// - Parameter domainValue: A value in the domain of the scale.
        /// - Parameter lower: The lower bound to the range to map to.
        /// - Parameter higher: The upper bound of the range to map to.
        /// - Returns: A value mapped to the range you provide.
        public func scale(_ domainValue: InputType, from lower: Float, to higher: Float) -> Float? {
            if let domainValue = transformAgainstDomain(domainValue) {
                let logDomainValue = log10(Double(domainValue))
                let logDomainLower = log10(Double(domainLower))
                let logDomainHigher = log10(Double(domainHigher))
                let normalizedValueOnLogDomain = normalize(logDomainValue, lower: logDomainLower, higher: logDomainHigher)
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
        /// - Returns: A value linearly mapped from the range back into the domain.
        public func invert(_ rangeValue: Float, from lower: Float, to higher: Float) -> InputType? {
            let normalizedRangeValue = normalize(rangeValue, lower: lower, higher: higher)
            let logDomainLower = log10(Double(domainLower))
            let logDomainHigher = log10(Double(domainHigher))
            let linearInterpolatedValue = interpolate(Double(normalizedRangeValue), lower: logDomainLower, higher: logDomainHigher)
            let domainValue = pow(10, linearInterpolatedValue)
            return transformAgainstDomain(Int(domainValue))
        }
    }

    #if canImport(CoreGraphics)
        public struct IntToCGFloatScale: TickScale {
            /// The type used for the scale's domain.
            public typealias InputType = Int
            /// The type used for the scale's range.
            public typealias OutputType = CGFloat

            /// The lower bound of the input domain.
            public let domainLower: InputType
            /// The upper bound of the input domain.
            public let domainHigher: InputType
            /// The distance or length between the upper and lower bounds of the input domain.
            public let domainExtent: InputType

            /// A boolean value that indicates whether the output vales are constrained to the min and max of the output range.
            ///
            /// If `true`, values processed by the scale are constrained to the output range, and values processed backwards through the scale
            /// are constrained to the input domain.
            public var transformType: DomainDataTransform

            /// The number of ticks desired when creating the scale.
            ///
            /// This number may not match the number of ticks returned by ``TickScale/tickValues(_:from:to:)``
            public let desiredTicks: Int

            /// Creates a new logarithmic scale for the upper and lower bounds of the domain you provide.
            /// - Parameters:
            ///   - lower: The lower bound of the scale's domain.
            ///   - higher: The upper bound of the scale's domain.
            ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
            ///   - desiredTicks: The desired number of ticks when visually representing the scale.
            public init(from lower: InputType, to higher: InputType, transform: DomainDataTransform = .none, desiredTicks: Int = 10) {
                precondition(lower < higher)
                precondition(lower > 0)
                transformType = transform
                domainLower = lower
                domainHigher = higher
                domainExtent = higher - lower
                self.desiredTicks = desiredTicks
            }

            /// Transforms the input value using a linear function to the resulting value into the range you provide.
            ///
            /// - Parameter domainValue: A value in the domain of the scale.
            /// - Parameter lower: The lower bound to the range to map to.
            /// - Parameter higher: The upper bound of the range to map to.
            /// - Returns: A value mapped to the range you provide.
            public func scale(_ domainValue: InputType, from lower: OutputType, to higher: OutputType) -> OutputType? {
                if let domainValue = transformAgainstDomain(domainValue) {
                    let logDomainValue = log10(Double(domainValue))
                    let logDomainLower = log10(Double(domainLower))
                    let logDomainHigher = log10(Double(domainHigher))
                    let normalizedValueOnLogDomain = normalize(logDomainValue, lower: logDomainLower, higher: logDomainHigher)
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
            /// - Returns: A value linearly mapped from the range back into the domain.
            public func invert(_ rangeValue: OutputType, from lower: OutputType, to higher: OutputType) -> InputType? {
                let normalizedRangeValue = normalize(rangeValue, lower: Double(lower), higher: Double(higher))
                let logDomainLower = log10(Double(domainLower))
                let logDomainHigher = log10(Double(domainHigher))
                let linearInterpolatedValue = interpolate(Double(normalizedRangeValue), lower: logDomainLower, higher: logDomainHigher)
                let domainValue = pow(10, linearInterpolatedValue)
                return transformAgainstDomain(Int(domainValue))
            }
        }
    #endif
}
