import Foundation
import Numerics

/// A linear scale for transforming and mapping continuous input values within a domain to output values you provide.
public struct LinearScale<InputType: ConvertibleWithDouble & NiceValue, OutputType: ConvertibleWithDouble>: TickScale {
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
    public var defaultDomain: Bool

    /// The number of ticks desired when creating the scale.
    ///
    /// This number may not match the number of ticks returned by ``TickScale/tickValues(_:from:to:)``
    public let desiredTicks: Int

    /// Creates a new linear scale for the upper and lower bounds of the domain you provide.
    /// - Parameters:
    ///   - lower: The lower bound for the scale's domain.
    ///   - higher: The upper bound for the scale's domain.
    ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
    ///   - desiredTicks: The desired number of ticks when visually representing the scale.
    public init(from lower: InputType, to higher: InputType, transform: DomainDataTransform = .none, desiredTicks: Int = 10) {
        precondition(lower < higher)
        transformType = transform
        domainLower = lower
        domainHigher = higher
        domainExtent = higher - lower
        self.desiredTicks = desiredTicks
        defaultDomain = false
    }

    /// Creates a new linear scale with a default domain.
    ///
    /// The default domain for the scale is `0.0...1.0`.
    /// Use this method to create a placeholder scale that you can refine to a fully configured scale with an updated domain using ``withDomain(lower:higher:)``.
    /// - Parameters:
    ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
    ///   - desiredTicks: The desired number of ticks when visually representing the scale.
    public init(exponent _: Double = 1, transform: DomainDataTransform = .none, desiredTicks: Int = 10) {
        self.init(from: 0, to: 1, transform: transform, desiredTicks: desiredTicks)
        defaultDomain = true
    }

    /// Creates a new linear scale for the upper and lower bounds of the domain range you provide.
    /// - Parameters:
    ///   - range: A range that represents the scale's domain.
    ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
    ///   - desiredTicks: The desired number of ticks when visually representing the scale.
    public init(_ range: ClosedRange<InputType>, transform: DomainDataTransform = .none, desiredTicks: Int = 10) {
        self.init(from: range.lowerBound, to: range.upperBound, transform: transform, desiredTicks: desiredTicks)
    }

    /// Creates a new power scale for the domain of `0` to the value you provide.
    ///
    /// If the value you provide is less than `0`, the domain of the scale ranges from the value you provide to `0`.
    /// If the value you provide is greater than `0`, the domain of the scale ranges from `0` to the value you provide.
    /// - Parameters:
    ///   - single: The upper, or lower, bound for the domain.
    ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
    ///   - desiredTicks: The desired number of ticks when visually representing the scale.
    public init(_ single: InputType, transform: DomainDataTransform = .none, desiredTicks: Int = 10) {
        if single > 0 {
            self.init(from: 0, to: single, transform: transform, desiredTicks: desiredTicks)
        } else {
            self.init(from: single, to: 0, transform: transform, desiredTicks: desiredTicks)
        }
    }

    /// Returns a new scale with the domain set to the values you provide.
    /// - Parameters:
    ///   - lower: The lower bound for the scale's domain.
    ///   - higher: The upper bound for the scale's domain.
    /// - Returns: A replica of the scale, preserving ``transformType`` while applying new domain values.
    public func withDomain(lower: InputType, higher: InputType) -> LinearScale<InputType, OutputType> {
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
            let normalizedInput = normalize(domainValue.toDouble(), lower: domainLower.toDouble(), higher: domainHigher.toDouble())
            let result: Double = interpolate(normalizedInput, lower: lower.toDouble(), higher: higher.toDouble())
            return OutputType.fromDouble(result)
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
        // inverts the scale, taking a value in the output range and returning the relevant value from the input domain
        let normalizedRangeValue = normalize(rangeValue.toDouble(), lower: lower.toDouble(), higher: higher.toDouble())
        let mappedToDomain = interpolate(normalizedRangeValue, lower: domainLower.toDouble(), higher: domainHigher.toDouble())
        let castToInputType = InputType.fromDouble(mappedToDomain)
        return transformAgainstDomain(castToInputType)
    }
}

//    // MARK: - Factory (convenience) Methods

//    /// Creates a linear scale for dates that maps values between the lower and upper bounds you provide.
//    /// - Parameters:
//    ///   - low: The lower bounds of the domain.
//    ///   - high: The upper bounds of the domain.
//    public static func create(_ low: Date, _ high: Date) -> LinearScale.DoubleToFloatScale {
//        LinearScale.DoubleToFloatScale(from: low.timeIntervalSince1970, to: high.timeIntervalSince1970)
//    }
//
//    /// Creates a linear scale for dates that maps values within the range you provide.
//    /// - Parameter range: The range of the domain.
//    public static func create(_ range: ClosedRange<Date>) -> LinearScale.DoubleToFloatScale {
//        LinearScale.DoubleToFloatScale(from: range.lowerBound.timeIntervalSince1970, to: range.upperBound.timeIntervalSince1970)
//    }
