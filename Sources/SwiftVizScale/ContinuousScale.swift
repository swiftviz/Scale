import Foundation
import Numerics
#if canImport(CoreGraphics)
    import CoreGraphics
#endif
// =============================================================
//  ContinuousScale.swift

// Inspired by D3's scale concept - maps input values (domain) to an output range (range)
// - https://github.com/d3/d3-scale
// - https://github.com/pshrmn/notes/blob/master/d3/scales.md

// import { scaleTime } from 'd3-scale';
// const time = scaleTime()
//    .domain([new Date('1910-1-1'), (new Date('1920-1-1'))]);
//
/// / for UTC
// const utc = d3.scaleUtc();
// https://github.com/d3/d3-scale#scaleUtc
// https://github.com/d3/d3-3.x-api-reference/blob/master/Time-Scales.md
// Time Scale
// - https://github.com/d3/d3-scale/blob/master/src/time.js
// - D3 has a time format (https://github.com/d3/d3-time-format), but we can probably use
//   IOS/MacOS NSTime, NSDate formatters and calendrical mechanisms

/// A value that represents how a scale handles data transformation that exceed the domain or range of the scale.
public enum DomainDataTransform {
    /// Data processed against a scale isn't influenced by the scale's domain.
    case none
    /// Data processed against a scale is dropped if the value is outside of the scale's domain.
    case drop
    /// Data processed against a scale is clamped to the upper and lower values of the scale's domain.
    case clamp

    var description: String {
        switch self {
        case .none:
            return "none"
        case .drop:
            return "drop"
        case .clamp:
            return "clamp"
        }
    }
}

/// A type that maps continuous values from an input _domain_ to an output _range_.
public protocol ContinuousScale: Scale, CustomStringConvertible where InputType: ConvertibleWithDouble & NiceValue, RangeType == OutputType {
    /// A transformation value that indicates whether the output vales are constrained to the min and max of the output range.
    ///
    /// If `true`, values processed by the scale are constrained to the output range, and values processed backwards through the scale
    /// are constrained to the input domain.
    var transformType: DomainDataTransform { get }

    /// The type of continuous scale.
    var scaleType: ContinuousScaleType { get }

    /// The lower bound of the input domain.
    var domainLower: InputType { get }
    /// The upper bound of the input domain.
    var domainHigher: InputType { get }
    /// The distance or length between the upper and lower bounds of the input domain.
    var domainExtent: InputType { get }

    /// The lower bound of the input domain.
    var rangeLower: OutputType? { get }
    /// The upper bound of the input domain.
    var rangeHigher: OutputType? { get }

    /// A Boolean value that indicates if the mapping from domain to range is inverted.
    var reversed: Bool { get }

    /// The number of requested tick marks for the scale.
    var desiredTicks: Int { get }

    /// Returns a Boolean value that indicates whether the value you provided is within the scale's domain.
    /// - Parameter value: The value to compare.
    /// - Returns: `true` if the value is between the lower and upper domain values.
    func domainContains(_ value: InputType) -> Bool

    // modifier functions

    /// Returns a new scale with the domain set to the values you provide.
    /// - Parameters:
    ///   - lower: The lower bound for the scale's domain.
    ///   - higher: The upper bound for the scale's domain.
    /// - Returns: A replica of the scale, with new domain values.
    func domain(lower: InputType, higher: InputType) -> Self

    /// Returns a new scale with the domain set to the values you provide.
    /// - Parameters:
    ///   - range: The range to apply as the scale's domain
    /// - Returns: A copy of the scale with the domain values you provide.
    func domain(_ range: ClosedRange<InputType>) -> Self

    /// Returns a new scale with the domain inferred from the list of values you provide.
    /// - Parameters:
    ///   - values: The list of values to use to determine the scale's domain.
    ///   - nice: A Boolean value that indicates whether to expand the domain to visually nice values.
    /// - Returns: A copy of the scale with the domain values you provide.
    func domain(_ values: [InputType], nice: Bool) -> Self

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    ///   - lower: The lower bound for the scale's range.
    ///   - higher: The upper bound for the scale's range.
    /// - Returns: A replica of the scale, with new range values.
    func range(reversed: Bool, lower: RangeType, higher: RangeType) -> Self

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    ///   - range: The range to apply as the scale's range.
    /// - Returns: A copy of the scale with the range values you provide.
    func range(reversed: Bool, _ range: ClosedRange<OutputType>) -> Self

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - lower: The lower bound for the scale's range.
    ///   - higher: The upper bound for the scale's range.
    /// - Returns: A replica of the scale, with new range values.
    func range(lower: RangeType, higher: RangeType) -> Self

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - range: The range to apply as the scale's range.
    /// - Returns: A copy of the scale with the range values you provide.
    func range(_ range: ClosedRange<OutputType>) -> Self

    /// Returns a new scale with the transform set to the value you provide.
    /// - Parameters:
    ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
    /// - Returns: A replica of the scale, updating the ``transformType``.
    func transform(_ transform: DomainDataTransform) -> Self

    /// Converts a value comparing it to the input domain, transforming the value, and mapping it between the range values you provide.
    ///
    /// Before scaling the value, the scale may transform or drop the value based on the setting of ``ContinuousScale/transformType``.
    ///
    /// - Parameter domainValue: The value to be scaled.
    /// - Parameter reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    /// - Parameter from: The lower bounding value of the range to transform to.
    /// - Parameter to: The higher bounding value of the range to transform to.
    /// - Returns: A value within the bounds of the range values you provide, or `nil` if the value was dropped.
    func scale(_ domainValue: InputType, reversed: Bool, from: OutputType, to: OutputType) -> OutputType?

    /// Converts a value comparing it to the input domain, transforming the value, and mapping it between the range values you provide.
    ///
    /// Before scaling the value, the scale may transform or drop the value based on the setting of ``ContinuousScale/transformType``.
    ///
    /// - Parameter domainValue: The value to be scaled.
    /// - Parameter from: The lower bounding value of the range to transform to.
    /// - Parameter to: The higher bounding value of the range to transform to.
    /// - Returns: A value within the bounds of the range values you provide, or `nil` if the value was dropped.
    func scale(_ domainValue: InputType, from: OutputType, to: OutputType) -> OutputType?

    /// Converts a value comparing it to the input domain, transforming the value, and mapping it between the range values you provide.
    ///
    /// Before scaling the value, the scale may transform or drop the value based on the setting of ``ContinuousScale/transformType``.
    ///
    /// - Parameter inputValue: The value to be scaled.
    /// - Returns: A value within the bounds of the range values you provide, or `nil` if the value was dropped.
    func scale(_ domainValue: InputType) -> OutputType?

    /// Converts back from the output _range_ to a value within the input _domain_.
    ///
    /// The inverse of ``ContinuousScale/scale(_:from:to:)``.
    /// After converting the data back to the domain range, the scale may transform or drop the value based on the setting of ``ContinuousScale/transformType``.
    ///
    /// - Parameter rangeValue: The value to be scaled back from the range values to the domain.
    /// - Parameter reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    /// - Parameter from: The lower bounding value of the range to transform from.
    /// - Parameter to: The higher bounding value of the range to transform from.
    /// - Returns: A value within the bounds of the range values you provide, or `nil` if the value was dropped.
    func invert(_ rangeValue: OutputType, reversed: Bool, from: OutputType, to: OutputType) -> InputType?

    /// Converts back from the output _range_ to a value within the input _domain_.
    ///
    /// The inverse of ``ContinuousScale/scale(_:from:to:)``.
    /// After converting the data back to the domain range, the scale may transform or drop the value based on the setting of ``ContinuousScale/transformType``.
    ///
    /// - Parameter rangeValue: The value to be scaled back from the range values to the domain.
    /// - Parameter from: The lower bounding value of the range to transform from.
    /// - Parameter to: The higher bounding value of the range to transform from.
    /// - Returns: A value within the bounds of the range values you provide, or `nil` if the value was dropped.
    func invert(_ rangeValue: OutputType, from: OutputType, to: OutputType) -> InputType?

    /// Converts back from the output _range_ to a value within the input _domain_.
    ///
    /// The inverse of ``ContinuousScale/scale(_:from:to:)``.
    /// After converting the data back to the domain range, the scale may transform or drop the value based on the setting of ``ContinuousScale/transformType``.
    ///
    /// - Parameter rangeValue: The value to be scaled back from the range values to the domain.
    /// - Returns: A value within the bounds of the range values you provide, or `nil` if the value was dropped.
    func invert(_ rangeValue: OutputType) -> InputType?
}

public extension ContinuousScale {
    var description: String {
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
    func transformAgainstDomain(_ value: InputType) -> InputType? {
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

    /// Converts a value comparing it to the input domain, transforming the value, and mapping it into values between `0` and to the upper bound you provide.
    ///
    /// This method is a convenience method that sets the lower value of the range is `0`.
    /// Before scaling the value, the scale may transform or drop the value based on the setting of ``ContinuousScale/transformType``.
    ///
    /// - Parameter domainValue: The value to be scaled.
    /// - Parameter reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    /// - Parameter to: The higher bounding value of the range to transform from.
    /// - Returns: a value within the bounds of the range values you provide, or `nil` if the value was dropped.
    func scale(_ domainValue: InputType, to upper: OutputType, reversed: Bool) -> OutputType? {
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
    func scale(_ domainValue: InputType, to upper: OutputType) -> OutputType? {
        scale(domainValue, from: 0, to: upper)
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
    func invert(_ rangeValue: OutputType, to upper: OutputType, reversed: Bool) -> InputType? {
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
    func invert(_ rangeValue: OutputType, to upper: OutputType) -> InputType? {
        invert(rangeValue, from: 0, to: upper)
    }

    /// Returns a list of strings that make up the valid tick values out of the set that you provide.
    /// - Parameters:
    ///   - inputValues: an array of values of the Scale's InputType
    ///   - formatter: An optional formatter to convert the domain values into strings.
    func validTickValues(_ inputValues: [InputType], formatter: Formatter? = nil) -> [String] {
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
    func ticksFromValues(_ inputValues: [InputType], reversed: Bool = false, from lower: OutputType, to higher: OutputType, formatter: Formatter? = nil) -> [Tick<OutputType>] {
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
}

public extension ContinuousScale where InputType == Int {
    /// Returns an array of the locations within the output range to locate ticks for the scale.
    /// - Parameters:
    ///   - rangeLower: the lower value for the range into which to position the ticks.
    ///   - rangeHigher: The higher value for the range into which to position the ticks.
    ///   - formatter: An optional formatter to convert the domain values into strings.
    func ticks(rangeLower: OutputType, rangeHigher: OutputType, formatter: Formatter? = nil) -> [Tick<OutputType>] {
        let tickValues = InputType.rangeOfNiceValues(min: domainLower, max: domainHigher, ofSize: desiredTicks)
        // NOTE(heckj): perf: for a larger number of ticks, it may be more efficient to assign the range to a temp scale and then iterate on that...
        return tickValues.compactMap { tickValue in
            if let tickRangeLocation = scale(tickValue, reversed: self.reversed, from: rangeLower, to: rangeHigher) {
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
    func ticks(reversed: Bool, rangeLower: OutputType, rangeHigher: OutputType, formatter: Formatter? = nil) -> [Tick<OutputType>] {
        let tickValues = InputType.rangeOfNiceValues(min: domainLower, max: domainHigher, ofSize: desiredTicks)
        // NOTE(heckj): perf: for a larger number of ticks, it may be more efficient to assign the range to a temp scale and then iterate on that...
        return tickValues.compactMap { tickValue in
            if let tickRangeLocation = scale(tickValue, reversed: reversed, from: rangeLower, to: rangeHigher) {
                return Tick(value: tickValue, location: tickRangeLocation, formatter: formatter)
            }
            return nil
        }
    }

    /// Returns an array of the strings that make up the ticks for the scale.
    /// - Parameter formatter: An optional formatter to convert the domain values into strings.
    func defaultTickValues(formatter: Formatter? = nil) -> [String] {
        let tickValues = InputType.rangeOfNiceValues(min: domainLower, max: domainHigher, ofSize: desiredTicks)
        return tickValues.map { intValue in
            if let formatter = formatter {
                return formatter.string(for: intValue) ?? ""
            } else {
                return String("\(intValue)")
            }
        }
    }
}

public extension ContinuousScale where InputType == Float {
    /// Returns an array of the locations within the output range to locate ticks for the scale.
    /// - Parameters:
    ///   - rangeLower: the lower value for the range into which to position the ticks.
    ///   - rangeHigher: The higher value for the range into which to position the ticks.
    ///   - formatter: An optional formatter to convert the domain values into strings.
    func ticks(rangeLower: OutputType, rangeHigher: OutputType, formatter: Formatter? = nil) -> [Tick<OutputType>] {
        let tickValues = InputType.rangeOfNiceValues(min: domainLower, max: domainHigher, ofSize: desiredTicks)
        // NOTE(heckj): perf: for a larger number of ticks, it may be more efficient to assign the range to a temp scale and then iterate on that...
        return tickValues.compactMap { tickValue in
            if let tickRangeLocation = scale(tickValue, reversed: self.reversed, from: rangeLower, to: rangeHigher) {
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
    func ticks(reversed: Bool, rangeLower: OutputType, rangeHigher: OutputType, formatter: Formatter? = nil) -> [Tick<OutputType>] {
        let tickValues = InputType.rangeOfNiceValues(min: domainLower, max: domainHigher, ofSize: desiredTicks)
        // NOTE(heckj): perf: for a larger number of ticks, it may be more efficient to assign the range to a temp scale and then iterate on that...
        return tickValues.compactMap { tickValue in
            if let tickRangeLocation = scale(tickValue, reversed: reversed, from: rangeLower, to: rangeHigher) {
                return Tick(value: tickValue, location: tickRangeLocation, formatter: formatter)
            }
            return nil
        }
    }

    /// Returns an array of the strings that make up the ticks for the scale.
    /// - Parameter formatter: An optional formatter to convert the domain values into strings.
    func defaultTickValues(formatter: Formatter? = nil) -> [String] {
        let tickValues = InputType.rangeOfNiceValues(min: domainLower, max: domainHigher, ofSize: desiredTicks)
        return tickValues.map { intValue in
            if let formatter = formatter {
                return formatter.string(for: intValue) ?? ""
            } else {
                return String("\(intValue)")
            }
        }
    }
}

#if canImport(CoreGraphics)
    public extension ContinuousScale where InputType == CGFloat {
        /// Returns an array of the locations within the output range to locate ticks for the scale.
        /// - Parameters:
        ///   - rangeLower: the lower value for the range into which to position the ticks.
        ///   - rangeHigher: The higher value for the range into which to position the ticks.
        ///   - formatter: An optional formatter to convert the domain values into strings.
        func ticks(rangeLower: OutputType, rangeHigher: OutputType, formatter: Formatter? = nil) -> [Tick<OutputType>] {
            let ticksFromValues = InputType.rangeOfNiceValues(min: domainLower, max: domainHigher, ofSize: desiredTicks)
            // NOTE(heckj): perf: for a larger number of ticks, it may be more efficient to assign the range to a temp scale and then iterate on that...
            return ticksFromValues.compactMap { tickValue in
                if let tickRangeLocation = scale(tickValue, reversed: self.reversed, from: rangeLower, to: rangeHigher) {
                    return Tick(value: tickValue, location: tickRangeLocation, formatter: formatter)
                }
                return nil
            }
        }

        /// Returns an array of the locations within the output range to locate ticks for the scale.
        /// - Parameters:
        ///   - rangeLower: the lower value for the range into which to position the ticks.
        ///   - rangeHigher: The higher value for the range into which to position the ticks.
        ///   - formatter: An optional formatter to convert the domain values into strings.
        ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
        func ticks(reversed _: Bool, rangeLower: OutputType, rangeHigher: OutputType, formatter: Formatter? = nil) -> [Tick<OutputType>] {
            let ticksFromValues = InputType.rangeOfNiceValues(min: domainLower, max: domainHigher, ofSize: desiredTicks)
            // NOTE(heckj): perf: for a larger number of ticks, it may be more efficient to assign the range to a temp scale and then iterate on that...
            return ticksFromValues.compactMap { tickValue in
                if let tickRangeLocation = scale(tickValue, reversed: self.reversed, from: rangeLower, to: rangeHigher) {
                    return Tick(value: tickValue, location: tickRangeLocation, formatter: formatter)
                }
                return nil
            }
        }

        /// Returns an array of the strings that make up the ticks for the scale.
        /// - Parameter formatter: An optional formatter to convert the domain values into strings.
        func defaultTickValues(formatter: Formatter? = nil) -> [String] {
            let ticksFromValues = InputType.rangeOfNiceValues(min: domainLower, max: domainHigher, ofSize: desiredTicks)
            return ticksFromValues.map { intValue in
                if let formatter = formatter {
                    return formatter.string(for: intValue) ?? ""
                } else {
                    return String("\(intValue)")
                }
            }
        }
    }
#endif

public extension ContinuousScale where InputType == Double {
    /// Returns an array of the locations within the output range to locate ticks for the scale.
    /// - Parameters:
    ///   - rangeLower: the lower value for the range into which to position the ticks.
    ///   - rangeHigher: The higher value for the range into which to position the ticks.
    ///   - formatter: An optional formatter to convert the domain values into strings.
    func ticks(rangeLower: OutputType, rangeHigher: OutputType, formatter: Formatter? = nil) -> [Tick<OutputType>] {
        let tickValues = InputType.rangeOfNiceValues(min: domainLower, max: domainHigher, ofSize: desiredTicks)
        // NOTE(heckj): perf: for a larger number of ticks, it may be more efficient to assign the range to a temp scale and then iterate on that...
        return tickValues.compactMap { tickValue in
            if let tickRangeLocation = scale(tickValue, reversed: self.reversed, from: rangeLower, to: rangeHigher),
               tickRangeLocation <= rangeHigher
            {
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
    func ticks(reversed: Bool, rangeLower: OutputType, rangeHigher: OutputType, formatter: Formatter? = nil) -> [Tick<OutputType>] {
        let tickValues = InputType.rangeOfNiceValues(min: domainLower, max: domainHigher, ofSize: desiredTicks)
        // NOTE(heckj): perf: for a larger number of ticks, it may be more efficient to assign the range to a temp scale and then iterate on that...
        return tickValues.compactMap { tickValue in
            if let tickRangeLocation = scale(tickValue, reversed: reversed, from: rangeLower, to: rangeHigher),
               tickRangeLocation <= rangeHigher
            {
                return Tick(value: tickValue, location: tickRangeLocation, formatter: formatter)
            }
            return nil
        }
    }

    /// Returns an array of the strings that make up the ticks for the scale.
    /// - Parameter formatter: An optional formatter to convert the domain values into strings.
    func defaultTickValues(formatter: Formatter? = nil) -> [String] {
        let tickValues = InputType.rangeOfNiceValues(min: domainLower, max: domainHigher, ofSize: desiredTicks)
        return tickValues.map { intValue in
            if let formatter = formatter {
                return formatter.string(for: intValue) ?? ""
            } else {
                return String("\(intValue)")
            }
        }
    }
}

// MARK: - general functions used in various implementations of Scale

/// normalize(x, a ... b) takes a value x and normalizes it across the domain a...b
/// It returns the corresponding parameter within the range [0...1] if it was within the domain of the scale
/// If the value provided is outside of the domain of the scale, the resulting normalized value will be extrapolated
func normalize<T: Real>(_ x: T, lower: T, higher: T) -> T {
    precondition(lower < higher)
    let extent = higher - lower
    return (x - lower) / extent
}

// inspiration - https://github.com/d3/d3-interpolate#interpolateNumber
/// interpolate(a, b)(t) takes a parameter t in [0,1] and
/// returns the corresponding range value x in [a,b].
func interpolate<T: Real>(_ x: T, lower: T, higher: T) -> T {
    lower * (1 - x) + higher * x
}
