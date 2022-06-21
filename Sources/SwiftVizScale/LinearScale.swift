// import Foundation
// import Numerics
//
///// A linear scale for transforming and mapping continuous input values within a domain to output values you provide.
// public struct LinearScale<InputType: ConvertibleWithDouble & NiceValue, OutputType: ConvertibleWithDouble>: ContinuousScaleProtocol {
//    /// The lower bound of the input domain.
//    public let domainLower: InputType
//    /// The upper bound of the input domain.
//    public let domainHigher: InputType
//    /// The distance or length between the upper and lower bounds of the input domain.
//    public let domainExtent: InputType
//
//    /// The lower bound of the input domain.
//    public let rangeLower: OutputType?
//    /// The upper bound of the input domain.
//    public let rangeHigher: OutputType?
//
//    /// The type of continuous scale.
//    public let scaleType: ContinuousScaleType = .linear
//
//    /// A Boolean value that indicates if the mapping from domain to range is inverted.
//    public let reversed: Bool
//
//    /// A transformation value that indicates whether the output vales are constrained to the min and max of the output range.
//    ///
//    /// If `true`, values processed by the scale are constrained to the output range, and values processed backwards through the scale
//    /// are constrained to the input domain.
//    public var transformType: DomainDataTransform
//
//    /// The number of ticks desired when creating the scale.
//    ///
//    /// This number may not match the number of ticks returned by ``ContinuousScale/ticksFromValues(_:reversed:from:to:formatter:)``
//    public let desiredTicks: Int
//
//    /// Creates a new linear scale for the upper and lower bounds of the domain you provide.
//    /// - Parameters:
//    ///   - lower: The lower bound for the scale's domain.
//    ///   - higher: The upper bound for the scale's domain.
//    ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
//    ///   - desiredTicks: The desired number of ticks when visually representing the scale.
//    public init(from lower: InputType = 0,
//                to higher: InputType = 1,
//                transform: DomainDataTransform = .none,
//                desiredTicks: Int = 10,
//                reversed: Bool = false,
//                rangeLower: OutputType? = nil,
//                rangeHigher: OutputType? = nil)
//    {
//        precondition(lower <= higher, "attempting to set an inverted domain: \(lower) to \(higher)")
//        precondition(lower != higher, "attempting to set an empty domain: \(lower) to \(higher)")
//        transformType = transform
//        domainLower = lower
//        domainHigher = higher
//        domainExtent = higher - lower
//        self.desiredTicks = desiredTicks
//        if let rangeLower = rangeLower, let rangeHigher = rangeHigher {
//            precondition(rangeLower < rangeHigher, "attempting to set an inverted or empty range: \(rangeLower) to \(rangeHigher)")
//        }
//        self.rangeLower = rangeLower
//        self.rangeHigher = rangeHigher
//        self.reversed = reversed
//    }
//
//    // testing function
//    internal func fullyConfigured() -> Bool {
//        rangeLower != nil && rangeHigher != nil
//    }
//
//    /// Creates a new linear scale for the upper and lower bounds of the domain range you provide.
//    /// - Parameters:
//    ///   - range: A range that represents the scale's domain.
//    ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
//    ///   - desiredTicks: The desired number of ticks when visually representing the scale.
//    public init(_ range: ClosedRange<InputType>,
//                transform: DomainDataTransform = .none,
//                desiredTicks: Int = 10,
//                reversed: Bool = false,
//                rangeLower: OutputType? = nil,
//                rangeHigher: OutputType? = nil)
//    {
//        self.init(from: range.lowerBound, to: range.upperBound, transform: transform, desiredTicks: desiredTicks, reversed: reversed, rangeLower: rangeLower, rangeHigher: rangeHigher)
//    }
//
//    /// Creates a new power scale for the domain of `0` to the value you provide.
//    ///
//    /// If the value you provide is less than `0`, the domain of the scale ranges from the value you provide to `0`.
//    /// If the value you provide is greater than `0`, the domain of the scale ranges from `0` to the value you provide.
//    /// - Parameters:
//    ///   - single: The upper, or lower, bound for the domain.
//    ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
//    ///   - desiredTicks: The desired number of ticks when visually representing the scale.
//    public init(_ single: InputType,
//                transform: DomainDataTransform = .none,
//                desiredTicks: Int = 10,
//                reversed: Bool = false,
//                rangeLower: OutputType? = nil,
//                rangeHigher: OutputType? = nil)
//    {
//        if single > 0 {
//            self.init(from: 0, to: single, transform: transform, desiredTicks: desiredTicks, reversed: reversed, rangeLower: rangeLower, rangeHigher: rangeHigher)
//        } else {
//            self.init(from: single, to: 0, transform: transform, desiredTicks: desiredTicks, reversed: reversed, rangeLower: rangeLower, rangeHigher: rangeHigher)
//        }
//    }
//
//    // MARK: - modifier functions
//
//    /// Returns a new scale with the domain set to the values you provide.
//    /// - Parameters:
//    ///   - lower: The lower bound for the scale's domain.
//    ///   - higher: The upper bound for the scale's domain.
//    /// - Returns: A copy of the scale with the domain values you provide.
//    public func domain(lower: InputType, higher: InputType) -> Self {
//        type(of: self).init(from: lower, to: higher, transform: transformType, desiredTicks: desiredTicks, reversed: reversed, rangeLower: rangeLower, rangeHigher: rangeHigher)
//    }
//
//    /// Returns a new scale with the domain set to the values you provide.
//    /// - Parameters:
//    ///   - range: The range to apply as the scale's domain
//    /// - Returns: A copy of the scale with the domain values you provide.
//    public func domain(_ range: ClosedRange<InputType>) -> Self {
//        type(of: self).init(from: range.lowerBound, to: range.upperBound, transform: transformType, desiredTicks: desiredTicks, reversed: reversed, rangeLower: rangeLower, rangeHigher: rangeHigher)
//    }
//
//    /// Returns a new scale with the domain set to span the values you provide.
//    /// - Parameter values: An array of input values.
//    public func domain(_ values: [InputType]) -> Self {
//        domain(values, nice: true)
//    }
//
//    /// Returns a new scale with the domain inferred from the list of values you provide.
//    /// - Parameters:
//    ///   - values: The list of values to use to determine the scale's domain.
//    ///   - nice: A Boolean value that indicates whether to expand the domain to visually nice values.
//    /// - Returns: A copy of the scale with the domain values you provide.
//    public func domain(_ values: [InputType], nice: Bool) -> LinearScale<InputType, OutputType> {
//        guard let min = values.min(), let max = values.max() else {
//            return self
//        }
//        if values.count == 1 || min == max {
//            if nice {
//                let bottom: Double = 0
//                let top = Double.niceVersion(for: max.toDouble(), trendTowardsZero: false)
//                return domain(lower: InputType.fromDouble(bottom), higher: InputType.fromDouble(top))
//            } else {
//                return domain(lower: 0, higher: max)
//            }
//        } else {
//            if nice {
//                let bottom = Double.niceMinimumValueForRange(min: min.toDouble(), max: max.toDouble())
//                let top = Double.niceVersion(for: max.toDouble(), trendTowardsZero: false)
//                return domain(lower: InputType.fromDouble(bottom), higher: InputType.fromDouble(top))
//            } else {
//                return domain(lower: min, higher: max)
//            }
//        }
//    }
//
//    /// Returns a new scale with the range set to the values you provide.
//    /// - Parameters:
//    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
//    ///   - lower: The lower bound for the scale's range.
//    ///   - higher: The upper bound for the scale's range.
//    /// - Returns: A copy of the scale with the range values you provide.
//    public func range(reversed: Bool, lower: OutputType, higher: OutputType) -> Self {
//        type(of: self).init(from: domainLower, to: domainHigher, transform: transformType, desiredTicks: desiredTicks, reversed: reversed, rangeLower: lower, rangeHigher: higher)
//    }
//
//    /// Returns a new scale with the range set to the values you provide.
//    /// - Parameters:
//    ///   - lower: The lower bound for the scale's range.
//    ///   - higher: The upper bound for the scale's range.
//    /// - Returns: A copy of the scale with the range values you provide.
//    public func range(lower: OutputType, higher: OutputType) -> Self {
//        type(of: self).init(from: domainLower, to: domainHigher, transform: transformType, desiredTicks: desiredTicks, reversed: reversed, rangeLower: lower, rangeHigher: higher)
//    }
//
//    /// Returns a new scale with the range set to the values you provide.
//    /// - Parameters:
//    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
//    ///   - range: The range to apply as the scale's range.
//    /// - Returns: A copy of the scale with the range values you provide.
//    public func range(reversed: Bool, _ range: ClosedRange<OutputType>) -> Self {
//        type(of: self).init(from: domainLower, to: domainHigher, transform: transformType, desiredTicks: desiredTicks, reversed: reversed, rangeLower: range.lowerBound, rangeHigher: range.upperBound)
//    }
//
//    /// Returns a new scale with the range set to the values you provide.
//    /// - Parameters:
//    ///   - range: The range to apply as the scale's range.
//    /// - Returns: A copy of the scale with the range values you provide.
//    public func range(_ range: ClosedRange<OutputType>) -> Self {
//        type(of: self).init(from: domainLower, to: domainHigher, transform: transformType, desiredTicks: desiredTicks, reversed: reversed, rangeLower: range.lowerBound, rangeHigher: range.upperBound)
//    }
//
//    /// Returns a new scale with the transform set to the value you provide.
//    /// - Parameters:
//    ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
//    /// - Returns: A copy of the scale with the transform setting you provide.
//    public func transform(_ transform: DomainDataTransform) -> Self {
//        type(of: self).init(from: domainLower, to: domainHigher, transform: transform, desiredTicks: desiredTicks, reversed: reversed, rangeLower: rangeLower, rangeHigher: rangeHigher)
//    }
//
//    // MARK: - scale functions
//
//    /// Transforms the input value using a linear function to the resulting value into the range you provide.
//    ///
//    /// - Parameter domainValue: A value in the domain of the scale.
//    /// - Returns: A value mapped to the range you provide.
//    public func scale(_ domainValue: InputType) -> OutputType? {
//        guard let domainValue = transformAgainstDomain(domainValue), let rangeLower = rangeLower, let rangeHigher = rangeHigher else {
//            return nil
//        }
//        let normalizedInput = normalize(domainValue.toDouble(), lower: domainLower.toDouble(), higher: domainHigher.toDouble())
//        let result: Double
//        if reversed {
//            result = interpolate(normalizedInput, lower: rangeHigher.toDouble(), higher: rangeLower.toDouble())
//        } else {
//            result = interpolate(normalizedInput, lower: rangeLower.toDouble(), higher: rangeHigher.toDouble())
//        }
//        return OutputType.fromDouble(result)
//    }
//
//    /// Transforms the input value using a linear function to the resulting value into the range you provide.
//    ///
//    /// - Parameter domainValue: A value in the domain of the scale.
//    /// - Parameter reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
//    /// - Parameter lower: The lower bound to the range to map to.
//    /// - Parameter higher: The upper bound of the range to map to.
//    /// - Returns: A value mapped to the range you provide.
//    public func scale(_ domainValue: InputType, reversed: Bool, from lower: OutputType, to higher: OutputType) -> OutputType? {
//        let reconfigScale = range(reversed: reversed, lower: lower, higher: higher)
//        return reconfigScale.scale(domainValue)
//    }
//
//    /// Transforms the input value using a linear function to the resulting value into the range you provide.
//    ///
//    /// - Parameter domainValue: A value in the domain of the scale.
//    /// - Parameter lower: The lower bound to the range to map to.
//    /// - Parameter higher: The upper bound of the range to map to.
//    /// - Returns: A value mapped to the range you provide.
//    public func scale(_ domainValue: InputType, from lower: OutputType, to higher: OutputType) -> OutputType? {
//        let reconfigScale = range(lower: lower, higher: higher)
//        return reconfigScale.scale(domainValue)
//    }
//
//    /// Transforms a value within the range into the associated domain value.
//    /// - Parameters:
//    ///   - rangeValue: A value in the range of the scale.
//    ///   - lower: The lower bound to the range to map from.
//    ///   - higher: The upper bound to the range to map from.
//    /// - Returns: A value linearly mapped from the range back into the domain.
//    public func invert(_ rangeValue: OutputType) -> InputType? {
//        guard let rangeLower = rangeLower, let rangeHigher = rangeHigher else {
//            return nil
//        }
//        // inverts the scale, taking a value in the output range and returning the relevant value from the input domain
//        let normalizedRangeValue = normalize(rangeValue.toDouble(), lower: rangeLower.toDouble(), higher: rangeHigher.toDouble())
//        let mappedToDomain: Double
//        if reversed {
//            mappedToDomain = interpolate(normalizedRangeValue, lower: domainHigher.toDouble(), higher: domainLower.toDouble())
//        } else {
//            mappedToDomain = interpolate(normalizedRangeValue, lower: domainLower.toDouble(), higher: domainHigher.toDouble())
//        }
//        let castToInputType = InputType.fromDouble(mappedToDomain)
//        return transformAgainstDomain(castToInputType)
//    }
//
//    /// Transforms a value within the range into the associated domain value.
//    /// - Parameters:
//    ///   - rangeValue: A value in the range of the scale.
//    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
//    ///   - lower: The lower bound to the range to map from.
//    ///   - higher: The upper bound to the range to map from.
//    /// - Returns: A value linearly mapped from the range back into the domain.
//    public func invert(_ rangeValue: OutputType, reversed: Bool, from lower: OutputType, to higher: OutputType) -> InputType? {
//        let reconfigScale = range(reversed: reversed, lower: lower, higher: higher)
//        return reconfigScale.invert(rangeValue)
//    }
//
//    /// Transforms a value within the range into the associated domain value.
//    /// - Parameters:
//    ///   - rangeValue: A value in the range of the scale.
//    ///   - lower: The lower bound to the range to map from.
//    ///   - higher: The upper bound to the range to map from.
//    /// - Returns: A value linearly mapped from the range back into the domain.
//    public func invert(_ rangeValue: OutputType, from lower: OutputType, to higher: OutputType) -> InputType? {
//        let reconfigScale = range(lower: lower, higher: higher)
//        return reconfigScale.invert(rangeValue)
//    }
// }
