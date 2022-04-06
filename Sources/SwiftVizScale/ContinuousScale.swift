import Foundation
import Numerics

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
}

/// A type that maps continuous values from an input _domain_ to an output _range_.
public protocol ContinuousScale: Scale where InputType: ConvertibleWithDouble & NiceValue, OutputType: ConvertibleWithDouble {
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

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - lower: The lower bound for the scale's range.
    ///   - higher: The upper bound for the scale's range.
    /// - Returns: A replica of the scale, with new range values.
    func range(lower: OutputType, higher: OutputType) -> Self

    /// Returns a new scale with the transform set to the value you provide.
    /// - Parameters:
    ///   - transform: The transform constraint to apply when values fall outside the domain of the scale.
    /// - Returns: A replica of the scale, updating the ``transformType``.
    func transform(_ transform: DomainDataTransform) -> Self

    /// Converts a value comparing it to the input domain, transforming the value, and mapping it between the range values you provide.
    ///
    /// Before scaling the value, the scale may transform or drop the value based on the setting of ``ContinuousScale/transformType``.
    ///
    /// - Parameter inputValue: The value to be scaled.
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
    /// - Parameter inputValue: The value to be scaled.
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
    /// - Parameter to: The higher bounding value of the range to transform from.
    /// - Returns: a value within the bounds of the range values you provide, or `nil` if the value was dropped.
    func invert(_ rangeValue: OutputType, to upper: OutputType) -> InputType? {
        invert(rangeValue, from: 0, to: upper)
    }
}

// NOTE(heckj): OTHER SCALES: make a PowScale (& maybe Sqrt, Log, Ln)

// Quantize scale: Quantize scales use a discrete range and a
// continuous domain. Range mapping is done by dividing the domain
// evenly by the number of elements in the range. Because the range
// is discrete, the values do not have to be numbers.

// Quantile scale: Quantile scales are similar to quantize scales,
// but instead of evenly dividing the domain, they determine threshold
// values based on the domain that are used as the cutoffs between
// values in the range. Quantile scales take an array of values for a
// domain (not just a lower and upper limit) and maps range to be an
// even distribution over the input domain

// Threshold Scale
// Power Scale
// Ordinal Scale
// Band Scale
// Point Scale

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
    precondition(lower < higher)
    return lower * (1 - x) + higher * x
}
