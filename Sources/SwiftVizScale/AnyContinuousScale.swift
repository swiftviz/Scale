//
//  AnyContinuousScale.swift
//
//
//  Created by Joseph Heck on 4/6/22.
//

import Foundation

// fatal error function (with line numbers to debug) that shows when you've accidentally
// called a function on what should be an abstract base class.
internal func _abstract(
    file: StaticString = #file,
    line: UInt = #line
) -> Never {
    fatalError("Method must be overridden", file: file, line: line)
}

// the abstract base class, implementing the base methods
internal class _AnyContinuousScale<InputType: ConvertibleWithDouble & NiceValue,
    OutputType: ConvertibleWithDouble>: ContinuousScaleProtocol
{
    // ContinuousScaleProtocol protocol conformance

    var scaleType: ContinuousScaleType {
        _abstract()
    }

    var transformType: DomainDataTransform {
        _abstract()
    }

    var domainLower: InputType {
        _abstract()
    }

    var domainHigher: InputType {
        _abstract()
    }

    var domainExtent: InputType {
        _abstract()
    }

    var desiredTicks: Int {
        _abstract()
    }

    var reversed: Bool {
        _abstract()
    }

    var rangeLower: OutputType? {
        _abstract()
    }

    var rangeHigher: OutputType? {
        _abstract()
    }

    func domain(lower _: InputType, higher _: InputType) -> Self {
        _abstract()
    }

    func domain(_: ClosedRange<InputType>) -> Self {
        _abstract()
    }

    func domain(_: [InputType]) -> Self {
        _abstract()
    }

    func domain(_: [InputType], nice _: Bool) -> Self {
        _abstract()
    }

    func range(reversed _: Bool, lower _: OutputType, higher _: OutputType) -> Self {
        _abstract()
    }

    func range(reversed _: Bool, _: ClosedRange<OutputType>) -> Self {
        _abstract()
    }

    func range(lower _: OutputType, higher _: OutputType) -> Self {
        _abstract()
    }

    func range(_: ClosedRange<OutputType>) -> Self {
        _abstract()
    }

    func transform(_: DomainDataTransform) -> Self {
        _abstract()
    }

    func scale(_: InputType, reversed _: Bool, from _: OutputType, to _: OutputType) -> OutputType? {
        _abstract()
    }

    func invert(_: OutputType, reversed _: Bool, from _: OutputType, to _: OutputType) -> InputType? {
        _abstract()
    }

    func scale(_: InputType, from _: OutputType, to _: OutputType) -> OutputType? {
        _abstract()
    }

    func invert(_: OutputType, from _: OutputType, to _: OutputType) -> InputType? {
        _abstract()
    }

    // Scale protocol conformance

    func scale(_: InputType) -> OutputType? {
        _abstract()
    }

    func invert(_: OutputType) -> InputType? {
        _abstract()
    }
}

// the "Any" class to hold a reference to a specific type, and forward invocations from
// the (partially) type-erased class into the concrete, specific class that it holds
// (which is how we achieve type-erasure)
internal final class _ContinuousScale<WrappedContinuousScale: ContinuousScaleProtocol>: _AnyContinuousScale<WrappedContinuousScale.InputType, WrappedContinuousScale.OutputType> {
    private var _base: WrappedContinuousScale

    init(_ base: WrappedContinuousScale) {
        _base = base
    }

    // ContinuousScaleProtocol Overrides

    override public var scaleType: ContinuousScaleType {
        _base.scaleType
    }

    override public var transformType: DomainDataTransform {
        _base.transformType
    }

    override public var desiredTicks: Int {
        _base.desiredTicks
    }

    override public var domainLower: InputType {
        _base.domainLower
    }

    override public var domainHigher: InputType {
        _base.domainHigher
    }

    override public var domainExtent: InputType {
        _base.domainExtent
    }

    override public var reversed: Bool {
        _base.reversed
    }

    override public var rangeLower: OutputType? {
        _base.rangeLower
    }

    override public var rangeHigher: OutputType? {
        _base.rangeHigher
    }

    override public func domain(lower: InputType, higher: InputType) -> Self {
        Self(_base.domain(lower: lower, higher: higher))
    }

    override public func domain(_ domain: ClosedRange<InputType>) -> Self {
        Self(_base.domain(domain))
    }

    override public func domain(_ values: [InputType]) -> Self {
        Self(_base.domain(values))
    }

    override func domain(_ values: [InputType], nice: Bool) -> Self {
        Self(_base.domain(values, nice: nice))
    }

    override public func range(reversed: Bool, lower: OutputType, higher: OutputType) -> Self {
        Self(_base.range(reversed: reversed, lower: lower, higher: higher))
    }

    override public func range(reversed: Bool, _ range: ClosedRange<OutputType>) -> Self {
        Self(_base.range(reversed: reversed, range))
    }

    override public func range(lower: OutputType, higher: OutputType) -> Self {
        Self(_base.range(lower: lower, higher: higher))
    }

    override public func range(_ range: ClosedRange<OutputType>) -> Self {
        Self(_base.range(range))
    }

    override public func transform(_ transform: DomainDataTransform) -> Self {
        Self(_base.transform(transform))
    }

    override public func invert(_ rangeValue: OutputType, reversed: Bool, from: OutputType, to: OutputType) -> InputType? {
        _base.invert(rangeValue, reversed: reversed, from: from, to: to)
    }

    override public func scale(_ domainValue: InputType, reversed: Bool, from: OutputType, to: OutputType) -> OutputType? {
        _base.scale(domainValue, reversed: reversed, from: from, to: to)
    }

    override public func invert(_ rangeValue: OutputType, from: OutputType, to: OutputType) -> InputType? {
        _base.invert(rangeValue, from: from, to: to)
    }

    override public func scale(_ domainValue: InputType, from: OutputType, to: OutputType) -> OutputType? {
        _base.scale(domainValue, from: from, to: to)
    }

    // Scale Conformance

    override public func invert(_ rangeValue: OutputType) -> InputType? {
        _base.invert(rangeValue)
    }

    override public func scale(_ domainValue: InputType) -> OutputType? {
        _base.scale(domainValue)
    }
}

/// A type-erased continuous scale.
///
/// Encapsulates a scale that conforms to the``ContinuousScale`` protocol, identified by ``ContinuousScaleType``.
public struct AnyContinuousScale<InputType: ConvertibleWithDouble & NiceValue,
    OutputType: ConvertibleWithDouble>: ContinuousScaleProtocol
{
    private let _box: _AnyContinuousScale<InputType, OutputType>

    /// Creates a type-erased continuous scale.
    /// - Parameter base: The continuous scale to wrap.
    public init<WrappedScale: ContinuousScaleProtocol>(_ base: WrappedScale) where WrappedScale.InputType == InputType, WrappedScale.OutputType == OutputType {
        _box = _ContinuousScale(base)
    }

    // ContinuousScaleProtocol Conformance

    /// A transformation value that indicates whether the output vales are constrained to the min and max of the output range.
    ///
    /// If `true`, values processed by the scale are constrained to the output range, and values processed backwards through the scale
    /// are constrained to the input domain.
    public var transformType: DomainDataTransform {
        _box.transformType
    }

    /// The type of continuous scale.
    public var scaleType: ContinuousScaleType {
        _box.scaleType
    }

    /// The lower bound of the input domain.
    public var domainLower: InputType {
        _box.domainLower
    }

    /// The upper bound of the input domain.
    public var domainHigher: InputType {
        _box.domainHigher
    }

    /// The distance or length between the upper and lower bounds of the input domain.
    public var domainExtent: InputType {
        _box.domainExtent
    }

    /// The number of requested tick marks for the scale.
    public var desiredTicks: Int {
        _box.desiredTicks
    }

    /// A Boolean value that indicates if the mapping from domain to range is inverted.
    public var reversed: Bool {
        _box.reversed
    }

    /// The lower bound of the input domain.
    public var rangeLower: OutputType? {
        _box.rangeLower
    }

    /// The upper bound of the input domain.
    public var rangeHigher: OutputType? {
        _box.rangeHigher
    }

    /// Returns a new scale with the domain set to the values you provide.
    /// - Parameters:
    ///   - lower: The lower bound for the scale's domain.
    ///   - higher: The upper bound for the scale's domain.
    /// - Returns: A replica of the scale, with new domain values.
    public func domain(lower: InputType, higher: InputType) -> Self {
        AnyContinuousScale(
            _box.domain(lower: lower, higher: higher)
        )
    }

    /// Returns a new scale with the domain set to the values you provide.
    /// - Parameters:
    ///   - range: The range to apply as the scale's domain
    /// - Returns: A copy of the scale with the domain values you provide.
    public func domain(_ range: ClosedRange<InputType>) -> AnyContinuousScale<InputType, OutputType> {
        AnyContinuousScale(
            _box.domain(range)
        )
    }

    /// Returns a new scale with the domain set to span the values you provide.
    /// - Parameter values: An array of input values.
    public func domain(_ values: [InputType]) -> AnyContinuousScale<InputType, OutputType> {
        AnyContinuousScale(
            _box.domain(values)
        )
    }

    /// Returns a new scale with the domain inferred from the list of values you provide.
    /// - Parameters:
    ///   - values: The list of values to use to determine the scale's domain.
    ///   - nice: A Boolean value that indicates whether to expand the domain to visually nice values.
    /// - Returns: A copy of the scale with the domain values you provide.
    public func domain(_ values: [InputType], nice: Bool) -> AnyContinuousScale<InputType, OutputType> {
        AnyContinuousScale(
            _box.domain(values, nice: nice)
        )
    }

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    ///   - lower: The lower value of the range into which the discrete values map.
    ///   - higher: The upper value of the range into which the discrete values map.
    public func range(reversed: Bool, lower: OutputType, higher: OutputType) -> Self {
        AnyContinuousScale(
            _box.range(reversed: reversed, lower: lower, higher: higher)
        )
    }

    /// Returns a new scale with the range set to the values you provide.
    /// - Parameters:
    ///   - lower: The lower value of the range into which the discrete values map.
    ///   - higher: The upper value of the range into which the discrete values map.
    public func range(lower: OutputType, higher: OutputType) -> Self {
        AnyContinuousScale(
            _box.range(reversed: reversed, lower: lower, higher: higher)
        )
    }

    /// Returns a new scale with the range set to the range you provide.
    /// - Parameter reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    /// - Parameter range: The range of the values into which the discrete values map.
    public func range(reversed: Bool, _ range: ClosedRange<OutputType>) -> Self {
        AnyContinuousScale(
            _box.range(reversed: reversed, range)
        )
    }

    /// Returns a new scale with the range set to the range you provide.
    /// - Parameter range: The range of the values into which the discrete values map.
    public func range(_ range: ClosedRange<OutputType>) -> Self {
        AnyContinuousScale(
            _box.range(reversed: reversed, range)
        )
    }

    public func transform(_ transform: DomainDataTransform) -> Self {
        AnyContinuousScale(
            _box.transform(transform)
        )
    }

    /// Converts back from the output _range_ to a value within the input _domain_.
    ///
    /// The inverse of ``ContinuousScaleProtocol/scale(_:from:to:)``.
    /// After converting the data back to the domain range, the scale may transform or drop the value based on the setting of ``ContinuousScaleProtocol/transformType``.
    ///
    /// - Parameter rangeValue: The value to be scaled back from the range values to the domain.
    /// - Parameter reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    /// - Parameter from: The lower bounding value of the range to transform from.
    /// - Parameter to: The higher bounding value of the range to transform from.
    /// - Returns: A value within the bounds of the range values you provide, or `nil` if the value was dropped.
    public func invert(_ rangeValue: OutputType, reversed: Bool, from: OutputType, to: OutputType) -> InputType? {
        _box.invert(rangeValue, reversed: reversed, from: from, to: to)
    }

    /// Converts back from the output _range_ to a value within the input _domain_.
    ///
    /// The inverse of ``ContinuousScaleProtocol/scale(_:from:to:)``.
    /// After converting the data back to the domain range, the scale may transform or drop the value based on the setting of ``ContinuousScaleProtocol/transformType``.
    ///
    /// - Parameter rangeValue: The value to be scaled back from the range values to the domain.
    /// - Parameter from: The lower bounding value of the range to transform from.
    /// - Parameter to: The higher bounding value of the range to transform from.
    /// - Returns: A value within the bounds of the range values you provide, or `nil` if the value was dropped.
    public func invert(_ rangeValue: OutputType, from: OutputType, to: OutputType) -> InputType? {
        _box.invert(rangeValue, from: from, to: to)
    }

    /// Converts a value comparing it to the input domain, transforming the value, and mapping it between the range values you provide.
    ///
    /// Before scaling the value, the scale may transform or drop the value based on the setting of ``ContinuousScaleProtocol/transformType``.
    ///
    /// - Parameter domainValue: The value to be scaled.
    /// - Parameter reversed: A Boolean value that indicates if the mapping from domain to range is inverted.
    /// - Parameter from: The lower bounding value of the range to transform to.
    /// - Parameter to: The higher bounding value of the range to transform to.
    /// - Returns: A value within the bounds of the range values you provide, or `nil` if the value was dropped.
    public func scale(_ domainValue: InputType, reversed: Bool, from: OutputType, to: OutputType) -> OutputType? {
        _box.scale(domainValue, reversed: reversed, from: from, to: to)
    }

    /// Converts a value comparing it to the input domain, transforming the value, and mapping it between the range values you provide.
    ///
    /// Before scaling the value, the scale may transform or drop the value based on the setting of ``ContinuousScaleProtocol/transformType``.
    ///
    /// - Parameter domainValue: The value to be scaled.
    /// - Parameter from: The lower bounding value of the range to transform to.
    /// - Parameter to: The higher bounding value of the range to transform to.
    /// - Returns: A value within the bounds of the range values you provide, or `nil` if the value was dropped.
    public func scale(_ domainValue: InputType, from: OutputType, to: OutputType) -> OutputType? {
        _box.scale(domainValue, from: from, to: to)
    }

    // Scale Conformance

    /// Converts back from the output _range_ to a value within the input _domain_.
    ///
    /// The inverse of ``ContinuousScaleProtocol/scale(_:from:to:)``.
    /// After converting the data back to the domain range, the scale may transform or drop the value based on the setting of ``ContinuousScaleProtocol/transformType``.
    ///
    /// - Parameter rangeValue: The value to be scaled back from the range values to the domain.
    /// - Returns: A value within the bounds of the range values you provide, or `nil` if the value was dropped.
    public func invert(_ rangeValue: OutputType) -> InputType? {
        _box.invert(rangeValue)
    }

    /// Converts a value comparing it to the input domain, transforming the value, and mapping it between the range values you provide.
    ///
    /// Before scaling the value, the scale may transform or drop the value based on the setting of ``ContinuousScaleProtocol/transformType``.
    ///
    /// - Parameter inputValue: The value to be scaled.
    /// - Returns: A value within the bounds of the range values you provide, or `nil` if the value was dropped.
    public func scale(_ domainValue: InputType) -> OutputType? {
        _box.scale(domainValue)
    }

    // Transformation types (converting between enclosed scale types)

    public func scaleType(_ type: ContinuousScaleType) -> Self {
        switch type {
        case .linear:
            return AnyContinuousScale(
                LinearScale(from: _box.domainLower, to: _box.domainHigher, transform: _box.transformType, desiredTicks: _box.desiredTicks, rangeLower: _box.rangeLower, rangeHigher: _box.rangeHigher)
            )
        case .log:
            return AnyContinuousScale(
                LogScale(from: _box.domainLower, to: _box.domainHigher, transform: _box.transformType, desiredTicks: _box.desiredTicks, rangeLower: _box.rangeLower, rangeHigher: _box.rangeHigher)
            )
        case let .power(exponent):
            return AnyContinuousScale(
                PowerScale(from: _box.domainLower, to: _box.domainHigher, exponent: exponent, transform: _box.transformType, desiredTicks: _box.desiredTicks, rangeLower: _box.rangeLower, rangeHigher: _box.rangeHigher)
            )
        case .radial:
            return AnyContinuousScale(
                RadialScale(from: _box.domainLower, to: _box.domainHigher, transform: _box.transformType, desiredTicks: _box.desiredTicks, rangeLower: _box.rangeLower, rangeHigher: _box.rangeHigher)
            )
        }
    }
}
