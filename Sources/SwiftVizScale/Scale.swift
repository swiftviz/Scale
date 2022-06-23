//
//  Scale.swift
//

public protocol Scale {
    /// The type used for the scale's domain.
    associatedtype InputType: Comparable
    /// The type used for the scale's output.
    associatedtype OutputType

    /// Converts a value comparing it to the input domain, transforming the value, and mapping it between the range values you provide.
    ///
    /// - Parameter inputValue: The value to be scaled.
    /// - Returns: A value within the bounds of the range values you provide, or `nil` if the value was dropped.
    func scale(_ domainValue: InputType) -> OutputType?

    // MARK: - modifier functions

    /// Returns a new scale with the domain set to the span of values you provide.
    /// - Parameter values: An array of input values.
    func domain(_ values: [InputType]) -> Self
}

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
