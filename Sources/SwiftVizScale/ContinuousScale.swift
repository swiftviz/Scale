//
//  ContinuousScale.swift
//

import Foundation

/// A continuous scale for transforming and mapping continuous input values within a domain to output values you provide.
public struct ContinuousScale<OutputType: BinaryFloatingPoint>: ReversibleScale, CustomStringConvertible {
    public typealias InputType = Double
    /// The lower bound of the input domain.
    public let domainLower: Double
    /// The upper bound of the input domain.
    public let domainHigher: Double

    /// The lower bound of the output range.
    public let rangeLower: OutputType?
    /// The upper bound of the output range.
    public let rangeHigher: OutputType?

    /// The type of continuous scale.
    public let scaleType: ContinuousScaleType

    /// A Boolean value that indicates if the mapping from domain to range is inverted.
    public let reversed: Bool

    /// A transformation value that indicates whether the output vales are constrained to the min and max of the output range.
    ///
    /// If `true`, values processed by the scale are constrained to the output range, and values processed backwards through the scale
    /// are constrained to the input domain.
    public var transformType: DomainDataTransform

    /// The number of ticks desired when creating the scale.
    ///
    /// This number may not match the number of ticks returned by
    /// ``SwiftVizScale/ContinuousScale/ticksFromValues(_:reversed:from:to:formatter:)-3u6d8`` or
    ///  ``SwiftVizScale/ContinuousScale/ticksFromValues(_:reversed:from:to:formatter:)-7mb58``.
    public let desiredTicks: Int

    /// Creates a new identity scale.
    /// - Parameters:
    ///   - scaleType: The type of continuous scale.
    ///   - transform: A transformation value that indicates whether the output vales are constrained to the min and max of the output range.
    ///   - desiredTicks: The desired number of ticks when visually representing the scale.
    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    ///   - rangeLower: The lower bound of the output range.
    ///   - rangeHigher: The upper bound of the output range.
    public init(type scaleType: ContinuousScaleType = .linear,
                transform: DomainDataTransform = .none,
                desiredTicks: Int = 10,
                reversed: Bool = false,
                rangeLower: OutputType? = nil,
                rangeHigher: OutputType? = nil)
    {
        self.init(lower: 0.0, higher: 1.0, type: scaleType, transform: transform, desiredTicks: desiredTicks, reversed: reversed, rangeLower: rangeLower, rangeHigher: rangeHigher)
    }

    /// Creates a new scale for the upper and lower bounds of the domain you provide.
    /// - Parameters:
    ///   - lower: The lower bound for the scale's domain.
    ///   - higher: The upper bound for the scale's domain.
    ///   - scaleType: The type of continuous scale.
    ///   - transform: A transformation value that indicates whether the output vales are constrained to the min and max of the output range.
    ///   - desiredTicks: The desired number of ticks when visually representing the scale.
    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    ///   - rangeLower: The lower bound of the output range.
    ///   - rangeHigher: The upper bound of the output range.
    public init<T: BinaryInteger>(lower: T = 0,
                                  higher: T = 1,
                                  type scaleType: ContinuousScaleType = .linear,
                                  transform: DomainDataTransform = .none,
                                  desiredTicks: Int = 10,
                                  reversed: Bool = false,
                                  rangeLower: OutputType? = nil,
                                  rangeHigher: OutputType? = nil)
    {
        self.init(lower: Double(lower), higher: Double(higher), type: scaleType, transform: transform, desiredTicks: desiredTicks, reversed: reversed, rangeLower: rangeLower, rangeHigher: rangeHigher)
    }

    /// Creates a new scale for the upper and lower bounds of the domain you provide.
    /// - Parameters:
    ///   - lower: The lower bound for the scale's domain.
    ///   - higher: The upper bound for the scale's domain.
    ///   - scaleType: The type of continuous scale.
    ///   - transform: A transformation value that indicates whether the output vales are constrained to the min and max of the output range.
    ///   - desiredTicks: The desired number of ticks when visually representing the scale.
    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    ///   - rangeLower: The lower bound of the output range.
    ///   - rangeHigher: The upper bound of the output range.
    public init<T: BinaryFloatingPoint>(lower: T = 0,
                                        higher: T = 1,
                                        type scaleType: ContinuousScaleType = .linear,
                                        transform: DomainDataTransform = .none,
                                        desiredTicks: Int = 10,
                                        reversed: Bool = false,
                                        rangeLower: OutputType? = nil,
                                        rangeHigher: OutputType? = nil)
    {
        self.init(lower: Double(lower), higher: Double(higher), type: scaleType, transform: transform, desiredTicks: desiredTicks, reversed: reversed, rangeLower: rangeLower, rangeHigher: rangeHigher)
    }

    private init(lower: Double,
                 higher: Double,
                 type scaleType: ContinuousScaleType,
                 transform: DomainDataTransform,
                 desiredTicks: Int,
                 reversed: Bool,
                 rangeLower: OutputType? = nil,
                 rangeHigher: OutputType? = nil)
    {
        self.scaleType = scaleType
        if case .log = scaleType {
            if lower == 0 {
                domainLower = Double.leastNonzeroMagnitude
            } else {
                domainLower = lower
            }
            precondition(lower >= 0, "attempting to set lower domain value at 0 or below on a log scale: \(lower)")
            precondition(higher >= 0, "attempting to set higher domain value at 0 or below on a log scale: \(higher)")
        } else {
            domainLower = lower
        }
        precondition(lower <= higher, "attempting to set an inverted domain: \(lower) to \(higher)")
        precondition(lower != higher, "attempting to set an empty domain: \(lower) to \(higher)")
        transformType = transform
        domainHigher = Double(higher)
        self.desiredTicks = desiredTicks
        if let rangeLower = rangeLower, let rangeHigher = rangeHigher {
            if rangeLower > rangeHigher {
                self.rangeLower = rangeHigher
                self.rangeHigher = rangeLower
            } else {
                self.rangeLower = rangeLower
                self.rangeHigher = rangeHigher
            }
        } else {
            self.rangeLower = nil
            self.rangeHigher = nil
        }
        self.reversed = reversed
    }

    // testing function
    internal func fullyConfigured() -> Bool {
        rangeLower != nil && rangeHigher != nil
    }

    /// Creates a new scale for the upper and lower bounds of the domain range you provide.
    /// - Parameters:
    ///   - range: A range that represents the scale's domain.
    ///   - scaleType: The type of continuous scale.
    ///   - transform: A transformation value that indicates whether the output vales are constrained to the min and max of the output range.
    ///   - desiredTicks: The desired number of ticks when visually representing the scale.
    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    ///   - rangeLower: The lower bound of the output range.
    ///   - rangeHigher: The upper bound of the output range.
    public init<T: BinaryFloatingPoint>(_ range: ClosedRange<T>,
                                        type scaleType: ContinuousScaleType = .linear,
                                        transform: DomainDataTransform = .none,
                                        desiredTicks: Int = 10,
                                        reversed: Bool = false,
                                        rangeLower: OutputType? = nil,
                                        rangeHigher: OutputType? = nil)
    {
        self.init(lower: Double(range.lowerBound), higher: Double(range.upperBound), type: scaleType, transform: transform, desiredTicks: desiredTicks, reversed: reversed, rangeLower: rangeLower, rangeHigher: rangeHigher)
    }

    /// Creates a new scale for the upper and lower bounds of the domain range you provide.
    /// - Parameters:
    ///   - range: A range that represents the scale's domain.
    ///   - scaleType: The type of continuous scale.
    ///   - transform: A transformation value that indicates whether the output vales are constrained to the min and max of the output range.
    ///   - desiredTicks: The desired number of ticks when visually representing the scale.
    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    ///   - rangeLower: The lower bound of the output range.
    ///   - rangeHigher: The upper bound of the output range.
    public init<T: BinaryInteger>(_ range: ClosedRange<T>,
                                  type scaleType: ContinuousScaleType = .linear,
                                  transform: DomainDataTransform = .none,
                                  desiredTicks: Int = 10,
                                  reversed: Bool = false,
                                  rangeLower: OutputType? = nil,
                                  rangeHigher: OutputType? = nil)
    {
        self.init(lower: Double(range.lowerBound), higher: Double(range.upperBound), type: scaleType, transform: transform, desiredTicks: desiredTicks, reversed: reversed, rangeLower: rangeLower, rangeHigher: rangeHigher)
    }

    /// Creates a new scale for the domain of `0` to the value you provide.
    ///
    /// If the value you provide is less than `0`, the domain of the scale ranges from the value you provide to `0`.
    /// If the value you provide is greater than `0`, the domain of the scale ranges from `0` to the value you provide.
    /// - Parameters:
    ///   - single: The upper, or lower, bound for the domain.
    ///   - scaleType: The type of continuous scale.
    ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
    ///   - desiredTicks: The desired number of ticks when visually representing the scale.
    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    ///   - rangeLower: The lower bound of the output range.
    ///   - rangeHigher: The upper bound of the output range.
    public init<T: BinaryFloatingPoint>(_ single: T,
                                        type scaleType: ContinuousScaleType = .linear,
                                        transform: DomainDataTransform = .none,
                                        desiredTicks: Int = 10,
                                        reversed: Bool = false,
                                        rangeLower: OutputType? = nil,
                                        rangeHigher: OutputType? = nil)
    {
        if single > 0 {
            self.init(lower: 0, higher: Double(single), type: scaleType, transform: transform, desiredTicks: desiredTicks, reversed: reversed, rangeLower: rangeLower, rangeHigher: rangeHigher)
        } else {
            self.init(lower: Double(single), higher: 0, type: scaleType, transform: transform, desiredTicks: desiredTicks, reversed: reversed, rangeLower: rangeLower, rangeHigher: rangeHigher)
        }
    }

    /// Creates a new scale for the domain of `0` to the value you provide.
    ///
    /// If the value you provide is less than `0`, the domain of the scale ranges from the value you provide to `0`.
    /// If the value you provide is greater than `0`, the domain of the scale ranges from `0` to the value you provide.
    /// - Parameters:
    ///   - single: The upper, or lower, bound for the domain.
    ///   - scaleType: The type of continuous scale.
    ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
    ///   - desiredTicks: The desired number of ticks when visually representing the scale.
    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    ///   - rangeLower: The lower bound of the output range.
    ///   - rangeHigher: The upper bound of the output range.
    public init<T: BinaryInteger>(_ single: T,
                                  type scaleType: ContinuousScaleType = .linear,
                                  transform: DomainDataTransform = .none,
                                  desiredTicks: Int = 10,
                                  reversed: Bool = false,
                                  rangeLower: OutputType? = nil,
                                  rangeHigher: OutputType? = nil)
    {
        if single > 0 {
            self.init(lower: 0, higher: Double(single), type: scaleType, transform: transform, desiredTicks: desiredTicks, reversed: reversed, rangeLower: rangeLower, rangeHigher: rangeHigher)
        } else {
            self.init(lower: Double(single), higher: 0, type: scaleType, transform: transform, desiredTicks: desiredTicks, reversed: reversed, rangeLower: rangeLower, rangeHigher: rangeHigher)
        }
    }

    // MARK: - description

    public var description: String {
        "\(scaleType)(xform:\(transformType))[\(domainLower):\(domainHigher)]->[\(String(describing: rangeLower)):\(String(describing: rangeHigher))]"
    }

    /// Processes a value against the scale, potentially constraining or dropping the value.
    ///
    /// The value is transformed based on the scale's ``ContinuousScale/transformType`` setting.
    /// | ``ContinuousScale/transformType`` | transform effect |
    /// | ------------------------ | --------- |
    /// | ``DomainDataTransform/none`` | The method doesn't adjusted or drop the value. |
    /// | ``DomainDataTransform/drop`` | Values outside the scale's domain are dropped. |
    /// | ``DomainDataTransform/clamp`` | Values outside the scale's domain are adjusted to match the highest or lowest values of the domain. |
    ///
    /// - Parameters:
    ///   - value: The value to transform against the domain of the scale.
    /// - Returns: An updated value, or `nil` if the value was dropped.
    public func transformAgainstDomain(_ value: InputType) -> InputType? {
        switch transformType {
        case .none:
            return value
        case .drop:
            if value > domainHigher || value < domainLower {
                return nil
            }
            return value
        case .clamp:
            if value > domainHigher {
                return domainHigher
            } else if value < domainLower {
                return domainLower
            }
            return value
        }
    }

    /// Returns a Boolean value that indicates whether the value you provided is within the scale's domain.
    /// - Parameter value: The value to compare.
    /// - Returns: `true` if the value is between the lower and upper domain values.
    func domainContains(_ value: InputType) -> Bool {
        value >= domainLower && value <= domainHigher
    }

    // MARK: - modifier functions

    /// Returns a new scale with the domain set to the values you provide.
    /// - Parameters:
    ///   - lower: The lower bound for the scale's domain.
    ///   - higher: The upper bound for the scale's domain.
    /// - Returns: A copy of the scale with the domain values you provide.
    public func domain<T: BinaryInteger>(lower: T, higher: T) -> Self {
        Self(lower: Double(lower), higher: Double(higher), type: scaleType, transform: transformType, desiredTicks: desiredTicks, reversed: reversed, rangeLower: rangeLower, rangeHigher: rangeHigher)
    }

    /// Returns a new scale with the domain set to the values you provide.
    /// - Parameters:
    ///   - lower: The lower bound for the scale's domain.
    ///   - higher: The upper bound for the scale's domain.
    /// - Returns: A copy of the scale with the domain values you provide.
    public func domain<T: BinaryFloatingPoint>(lower: T, higher: T) -> Self {
        Self(lower: Double(lower), higher: Double(higher), type: scaleType, transform: transformType, desiredTicks: desiredTicks, reversed: reversed, rangeLower: rangeLower, rangeHigher: rangeHigher)
    }

    /// Returns a new scale with the domain set to the values you provide.
    /// - Parameters:
    ///   - range: The range to apply as the scale's domain
    /// - Returns: A copy of the scale with the domain values you provide.
    public func domain<T: BinaryFloatingPoint>(_ range: ClosedRange<T>) -> Self {
        Self(lower: Double(range.lowerBound), higher: Double(range.upperBound), type: scaleType, transform: transformType, desiredTicks: desiredTicks, reversed: reversed, rangeLower: rangeLower, rangeHigher: rangeHigher)
    }

    /// Returns a new scale with the domain set to the values you provide.
    /// - Parameters:
    ///   - range: The range to apply as the scale's domain
    /// - Returns: A copy of the scale with the domain values you provide.
    public func domain<T: BinaryInteger>(_ range: ClosedRange<T>) -> Self {
        Self(lower: Double(range.lowerBound), higher: Double(range.upperBound), type: scaleType, transform: transformType, desiredTicks: desiredTicks, reversed: reversed, rangeLower: rangeLower, rangeHigher: rangeHigher)
    }

    /// Returns a new scale with the domain set to span the values you provide.
    /// - Parameter values: An array of input values.
    public func domain<T: BinaryInteger>(_ values: [T]) -> Self {
        let converted = values.map { Double($0) }
        return domain(converted, nice: true)
    }

    /// Returns a new scale with the domain set to span the values you provide.
    /// - Parameter values: An array of input values.
    public func domain<T: BinaryFloatingPoint>(_ values: [T]) -> Self {
        let converted = values.map { Double($0) }
        return domain(converted, nice: true)
    }

    /// Returns a new scale with the domain inferred from the list of values you provide.
    /// - Parameters:
    ///   - values: The list of values to use to determine the scale's domain.
    ///   - nice: A Boolean value that indicates whether to expand the domain to visually nice values.
    /// - Returns: A copy of the scale with the domain values you provide.
    public func domain<T: BinaryFloatingPoint>(_ values: [T], nice: Bool) -> Self {
        guard let min = values.min(), let max = values.max() else {
            return self
        }
        if values.count == 1 || min == max {
            if nice {
                let bottom: Double = 0
                let top = InputType.niceVersion(for: InputType(max), trendTowardsZero: false)
                return domain(lower: InputType(bottom), higher: InputType(top))
            } else {
                return domain(lower: 0, higher: max)
            }
        } else {
            if nice {
                let bottom = InputType.niceMinimumValueForRange(min: Double(min), max: Double(max))
                let top = InputType.niceVersion(for: Double(max), trendTowardsZero: false)
                return domain(lower: bottom, higher: top)
            } else {
                return domain(lower: min, higher: max)
            }
        }
    }

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    ///   - lower: The lower bound for the scale's range.
    ///   - higher: The upper bound for the scale's range.
    /// - Returns: A copy of the scale with the range values you provide.
    public func range(reversed: Bool, lower: OutputType, higher: OutputType) -> Self {
        Self(lower: domainLower, higher: domainHigher, type: scaleType, transform: transformType, desiredTicks: desiredTicks, reversed: reversed, rangeLower: lower, rangeHigher: higher)
    }

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - lower: The lower bound for the scale's range.
    ///   - higher: The upper bound for the scale's range.
    /// - Returns: A copy of the scale with the range values you provide.
    public func range(lower: OutputType, higher: OutputType) -> Self {
        Self(lower: domainLower, higher: domainHigher, type: scaleType, transform: transformType, desiredTicks: desiredTicks, reversed: reversed, rangeLower: lower, rangeHigher: higher)
    }

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    ///   - range: The range to apply as the scale's range.
    /// - Returns: A copy of the scale with the range values you provide.
    public func range(reversed: Bool, _ range: ClosedRange<OutputType>) -> Self {
        Self(lower: domainLower, higher: domainHigher, type: scaleType, transform: transformType, desiredTicks: desiredTicks, reversed: reversed, rangeLower: range.lowerBound, rangeHigher: range.upperBound)
    }

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - range: The range to apply as the scale's range.
    /// - Returns: A copy of the scale with the range values you provide.
    public func range(_ range: ClosedRange<OutputType>) -> Self {
        Self(lower: domainLower, higher: domainHigher, type: scaleType, transform: transformType, desiredTicks: desiredTicks, reversed: reversed, rangeLower: range.lowerBound, rangeHigher: range.upperBound)
    }

    /// Returns a new scale with the transform set to the value you provide.
    /// - Parameters:
    ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
    /// - Returns: A copy of the scale with the transform setting you provide.
    public func transform(_ transform: DomainDataTransform) -> Self {
        Self(lower: domainLower, higher: domainHigher, type: scaleType, transform: transform, desiredTicks: desiredTicks, reversed: reversed, rangeLower: rangeLower, rangeHigher: rangeHigher)
    }

    /// Returns a new scale with the type of scale set to the type you provide.
    /// - Parameter scaleType: The type of continuous scale.
    public func scaleType(_ scaleType: ContinuousScaleType) -> Self {
        Self(lower: domainLower, higher: domainHigher, type: scaleType, transform: transformType, desiredTicks: desiredTicks, reversed: reversed, rangeLower: rangeLower, rangeHigher: rangeHigher)
    }

    // MARK: - scale functions

    /// Transforms the input value to the resulting value into the range you provide.
    ///
    /// The input value is first verified against the domain settings for the scale based on the ``transformType`` set for the scale.
    /// The value is then transformed using a function based on the ``scaleType``, interpolated between ``domainLower`` and ``domainHigher``, then mapped to the range taking into account the scale's ``reversed`` setting.
    ///
    /// - Parameter domainValue: A value in the domain of the scale.
    /// - Returns: A value mapped to the range you provide.
    public func scale(_ domainValue: InputType) -> OutputType? {
        guard let domainValue = transformAgainstDomain(domainValue), let rangeLower = rangeLower, let rangeHigher = rangeHigher else {
            return nil
        }

        let transformedDomainValue = scaleType.transform(Double(domainValue))
        let transformedDomainLow = scaleType.transform(Double(domainLower))
        let transformedDomainHigh = scaleType.transform(Double(domainHigher))

        let normalizedDomainValue = normalize(transformedDomainValue, lower: transformedDomainLow, higher: transformedDomainHigh)

        let valueMappedToRange: Double
        if reversed {
            valueMappedToRange = interpolate(normalizedDomainValue, lower: Double(rangeHigher), higher: Double(rangeLower))
        } else {
            valueMappedToRange = interpolate(normalizedDomainValue, lower: Double(rangeLower), higher: Double(rangeHigher))
        }
        if case .radial = scaleType {
            return OutputType(valueMappedToRange * valueMappedToRange)
        }
        if valueMappedToRange.isNaN { return nil }
        return OutputType(valueMappedToRange)
    }

    /// Transforms the input value using a linear function to the resulting value into the range you provide.
    ///
    /// - Parameter domainValue: A value in the domain of the scale.
    /// - Parameter reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    /// - Parameter lower: The lower bound to the range to map to.
    /// - Parameter higher: The upper bound of the range to map to.
    /// - Returns: A value mapped to the range you provide.
    public func scale(_ domainValue: InputType, reversed: Bool, from lower: OutputType, to higher: OutputType) -> OutputType? {
        let reconfigScale = range(reversed: reversed, lower: lower, higher: higher)
        return reconfigScale.scale(domainValue)
    }

    /// Transforms the input value using a linear function to the resulting value into the range you provide.
    ///
    /// - Parameter domainValue: A value in the domain of the scale.
    /// - Parameter lower: The lower bound to the range to map to.
    /// - Parameter higher: The upper bound of the range to map to.
    /// - Returns: A value mapped to the range you provide.
    public func scale(_ domainValue: InputType, from lower: OutputType, to higher: OutputType) -> OutputType? {
        let reconfigScale = range(lower: lower, higher: higher)
        return reconfigScale.scale(domainValue)
    }

    /// Converts a value comparing it to the input domain, transforming the value, and mapping it into values between `0` and to the upper bound you provide.
    ///
    /// This method is a convenience method that sets the lower value of the range is `0`.
    /// Before scaling the value, the scale may transform or drop the value based on the setting of ``ContinuousScale/transformType``.
    ///
    /// - Parameter domainValue: The value to be scaled.
    /// - Parameter reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    /// - Parameter to: The higher bounding value of the range to transform from.
    /// - Returns: a value within the bounds of the range values you provide, or `nil` if the value was dropped.
    public func scale(_ domainValue: InputType, to upper: OutputType, reversed: Bool) -> OutputType? {
        scale(domainValue, reversed: reversed, from: 0, to: upper)
    }

    /// Converts a value comparing it to the input domain, transforming the value, and mapping it into values between `0` and to the upper bound you provide.
    ///
    /// This method is a convenience method that sets the lower value of the range is `0`.
    /// Before scaling the value, the scale may transform or drop the value based on the setting of ``ContinuousScale/transformType``.
    ///
    /// - Parameter domainValue: The value to be scaled.
    /// - Parameter to: The higher bounding value of the range to transform from.
    /// - Returns: a value within the bounds of the range values you provide, or `nil` if the value was dropped.
    public func scale(_ domainValue: InputType, to upper: OutputType) -> OutputType? {
        scale(domainValue, from: 0, to: upper)
    }

    /// Transforms a value within the range into an associated domain value.
    /// - Parameters:
    ///   - rangeValue: A value in the range of the scale.
    /// - Returns: A value linearly mapped from the range back into the domain.
    public func invert(_ rangeValue: OutputType) -> InputType? {
        guard let rangeLower = rangeLower, let rangeHigher = rangeHigher else {
            return nil
        }
        // inverts the scale, taking a value in the output range and returning the relevant value from the input domain
        let normalizedRangeValue: Double
        if case .radial = scaleType {
            normalizedRangeValue = normalize(sqrt(Double(rangeValue)), lower: Double(rangeLower), higher: Double(rangeHigher))
        } else {
            normalizedRangeValue = normalize(Double(rangeValue), lower: Double(rangeLower), higher: Double(rangeHigher))
        }
        let transformedDomainLower = scaleType.transform(Double(domainLower))
        let transformedDomainHigher = scaleType.transform(Double(domainHigher))

        let linearInterpolatedValue: Double
        if reversed {
            linearInterpolatedValue = interpolate(normalizedRangeValue, lower: transformedDomainHigher, higher: transformedDomainLower)
        } else {
            linearInterpolatedValue = interpolate(normalizedRangeValue, lower: transformedDomainLower, higher: transformedDomainHigher)
        }
        let domainValue = scaleType.invertedTransform(linearInterpolatedValue)
        let castToInputType = InputType(domainValue)
        return transformAgainstDomain(castToInputType)
    }

    /// Transforms a value within the range into the associated domain value.
    /// - Parameters:
    ///   - rangeValue: A value in the range of the scale.
    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    ///   - lower: The lower bound to the range to map from.
    ///   - higher: The upper bound to the range to map from.
    /// - Returns: A value linearly mapped from the range back into the domain.
    public func invert(_ rangeValue: OutputType, reversed: Bool, from lower: OutputType, to higher: OutputType) -> InputType? {
        let reconfigScale = range(reversed: reversed, lower: lower, higher: higher)
        return reconfigScale.invert(rangeValue)
    }

    /// Transforms a value within the range into the associated domain value.
    /// - Parameters:
    ///   - rangeValue: A value in the range of the scale.
    ///   - lower: The lower bound to the range to map from.
    ///   - higher: The upper bound to the range to map from.
    /// - Returns: A value linearly mapped from the range back into the domain.
    public func invert(_ rangeValue: OutputType, from lower: OutputType, to higher: OutputType) -> InputType? {
        let reconfigScale = range(lower: lower, higher: higher)
        return reconfigScale.invert(rangeValue)
    }

    /// Converts a value comparing it to the upper value of a range, mapping it to the input domain, and inverting scale's transform.
    ///
    /// This method is a convenience method that sets the lower value of the range is `0`.
    /// The inverse of ``ContinuousScale/scale(_:to:)``.
    /// After converting the data back to the domain range, the scale may transform or drop the value based on the setting of ``ContinuousScale/transformType``.
    ///
    /// - Parameter rangeValue: The value to be scaled back from the range values to the domain.
    /// - Parameter reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    /// - Parameter to: The higher bounding value of the range to transform from.
    /// - Returns: a value within the bounds of the range values you provide, or `nil` if the value was dropped.
    public func invert(_ rangeValue: OutputType, to upper: OutputType, reversed: Bool) -> InputType? {
        invert(rangeValue, reversed: reversed, from: 0, to: upper)
    }

    /// Converts a value comparing it to the upper value of a range, mapping it to the input domain, and inverting scale's transform.
    ///
    /// This method is a convenience method that sets the lower value of the range is `0`.
    /// The inverse of ``ContinuousScale/scale(_:to:)``.
    /// After converting the data back to the domain range, the scale may transform or drop the value based on the setting of ``ContinuousScale/transformType``.
    ///
    /// - Parameter rangeValue: The value to be scaled back from the range values to the domain.
    /// - Parameter to: The higher bounding value of the range to transform from.
    /// - Returns: a value within the bounds of the range values you provide, or `nil` if the value was dropped.
    public func invert(_ rangeValue: OutputType, to upper: OutputType) -> InputType? {
        invert(rangeValue, from: 0, to: upper)
    }

    // MARK: - tick methods

    /// Returns a list of strings that make up the tick values that are contained within the domain of the scale.
    /// - Parameters:
    ///   - inputValues: an array of values of the Scale's InputType
    ///   - formatter: An optional formatter to convert the domain values into strings.
    public func validTickValues(_ inputValues: [InputType], formatter: Formatter? = nil) -> [String] {
        inputValues.compactMap { value in
            if domainContains(value) {
                if let formatter = formatter {
                    return formatter.string(for: value) ?? ""
                } else {
                    return String("\(value)")
                }
            }
            return nil
        }
    }

    /// Returns a list of strings that make up the tick values that are contained within the domain of the scale.
    /// - Parameters:
    ///   - inputValues: an array of values of the Scale's InputType
    ///   - formatter: An optional formatter to convert the domain values into strings.
    public func validTickValues<T: BinaryInteger>(_ inputValues: [T], formatter: Formatter? = nil) -> [String] {
        let converted = inputValues.map { Double($0) }
        return validTickValues(converted, formatter: formatter)
    }

    /// Converts an array of values that matches the scale's input type to a list of ticks that are within the scale's domain.
    ///
    /// Used for manually specifying a series of ticks that you want to have displayed.
    ///
    /// Values presented for display that are *not* within the domain of the scale are dropped.
    /// Values that scale outside of the range you provide are adjusted based on the setting of ``ContinuousScale/transformType``.
    /// - Parameter inputValues: an array of values of the Scale's InputType
    /// - Parameter reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    /// - Parameter lower: The lower value of the range the scale maps to.
    /// - Parameter higher: The higher value of the range the scale maps to.
    /// - Parameter formatter: An optional formatter to convert the domain values into strings.
    /// - Returns: A list of tick values validated against the domain, and range based on the setting of ``ContinuousScale/transformType``
    public func ticksFromValues(_ inputValues: [InputType], reversed: Bool = false, from lower: OutputType, to higher: OutputType, formatter: Formatter? = nil) -> [Tick<OutputType>] {
        // NOTE(heckj): perf: for a larger number of ticks, it may be more efficient to assign the range to a temp scale and then iterate on that...
        inputValues.compactMap { inputValue in
            if domainContains(inputValue),
               let rangeValue = scale(inputValue, reversed: reversed, from: lower, to: higher)
            {
                switch transformType {
                case .none:
                    return Tick(value: inputValue, location: rangeValue, formatter: formatter)
                case .drop:
                    if rangeValue > higher || rangeValue < lower {
                        return nil
                    }
                    return Tick(value: inputValue, location: rangeValue, formatter: formatter)
                case .clamp:
                    if rangeValue > higher {
                        return Tick(value: inputValue, location: higher, formatter: formatter)
                    } else if rangeValue < lower {
                        return Tick(value: inputValue, location: lower, formatter: formatter)
                    }
                    return Tick(value: inputValue, location: rangeValue, formatter: formatter)
                }
            }
            return nil
        }
    }

    /// Converts an array of values that matches the scale's input type to a list of ticks that are within the scale's domain.
    ///
    /// Used for manually specifying a series of ticks that you want to have displayed.
    ///
    /// Values presented for display that are *not* within the domain of the scale are dropped.
    /// Values that scale outside of the range you provide are adjusted based on the setting of ``ContinuousScale/transformType``.
    /// - Parameter inputValues: an array of values of the Scale's InputType
    /// - Parameter reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    /// - Parameter lower: The lower value of the range the scale maps to.
    /// - Parameter higher: The higher value of the range the scale maps to.
    /// - Parameter formatter: An optional formatter to convert the domain values into strings.
    /// - Returns: A list of tick values validated against the domain, and range based on the setting of ``ContinuousScale/transformType``
    public func ticksFromValues<T: BinaryInteger>(_ inputValues: [T], reversed: Bool = false, from lower: OutputType, to higher: OutputType, formatter: Formatter? = nil) -> [Tick<OutputType>] {
        let converted = inputValues.map { Double($0) }
        return ticksFromValues(converted, reversed: reversed, from: lower, to: higher, formatter: formatter)
    }

    /// Returns an array of the locations within the output range to locate ticks for the scale.
    /// - Parameters:
    ///   - rangeLower: the lower value for the range into which to position the ticks.
    ///   - rangeHigher: The higher value for the range into which to position the ticks.
    ///   - formatter: An optional formatter to convert the domain values into strings.
    public func ticks(rangeLower: OutputType, rangeHigher: OutputType, formatter: Formatter? = nil) -> [Tick<OutputType>] {
        let tickValues: [InputType]
        if scaleType == .log {
            tickValues = InputType.logRangeOfNiceValues(min: domainLower, max: domainHigher)
        } else {
            tickValues = InputType.rangeOfNiceValues(min: domainLower, max: domainHigher, ofSize: desiredTicks)
        }
        // NOTE(heckj): perf: for a larger number of ticks, it may be more efficient to assign the range to a temp scale and then iterate on that...
        return tickValues.compactMap { tickValue -> Tick<OutputType>? in
            // we only want tick values that are within the domain that's been specified on the scale.
            if InputType(tickValue) > domainHigher || InputType(tickValue) < domainLower {
                return nil
            }
            if let tickRangeLocation = scale(InputType(tickValue), reversed: reversed, from: rangeLower, to: rangeHigher) {
                return Tick(value: tickValue, location: tickRangeLocation, formatter: formatter)
            }
            return nil
        }
    }

    /// Returns an array of the locations within the output range to locate ticks for the scale.
    /// - Parameters:
    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    ///   - rangeLower: the lower value for the range into which to position the ticks.
    ///   - rangeHigher: The higher value for the range into which to position the ticks.
    ///   - formatter: An optional formatter to convert the domain values into strings.
    public func ticks(reversed: Bool, rangeLower: OutputType, rangeHigher: OutputType, formatter: Formatter? = nil) -> [Tick<OutputType>] {
        let tickValues: [InputType]
        if scaleType == .log {
            tickValues = InputType.logRangeOfNiceValues(min: domainLower, max: domainHigher)
        } else {
            tickValues = InputType.rangeOfNiceValues(min: domainLower, max: domainHigher, ofSize: desiredTicks)
        }
        // NOTE(heckj): perf: for a larger number of ticks, it may be more efficient to assign the range to a temp scale and then iterate on that...
        return tickValues.compactMap { tickValue in
            if let tickRangeLocation = scale(InputType(tickValue), reversed: reversed, from: rangeLower, to: rangeHigher) {
                return Tick(value: tickValue, location: tickRangeLocation, formatter: formatter)
            }
            return nil
        }
    }

    /// Returns an array of the strings that make up the ticks for the scale.
    /// - Parameter formatter: An optional formatter to convert the domain values into strings.
    public func defaultTickValues(formatter: Formatter? = nil) -> [String] {
        let tickValues: [InputType]
        if scaleType == .log {
            tickValues = InputType.logRangeOfNiceValues(min: domainLower, max: domainHigher)
        } else {
            tickValues = InputType.rangeOfNiceValues(min: domainLower, max: domainHigher, ofSize: desiredTicks)
        }
        return tickValues.map { intValue in
            if let formatter = formatter {
                return formatter.string(for: intValue) ?? ""
            } else {
                return String("\(intValue)")
            }
        }
    }
}
