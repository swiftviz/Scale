//
//  AnyContinuousScale.swift
//
//
//  Created by Joseph Heck on 4/6/22.
//

import Foundation

/// The type of continuous scale.
///
/// Exponential scales (``PowerScale``) require an additional value for the exponent of the scale.
public enum ContinuousScaleType: Equatable {
    /// A linear continuous scale.
    case linear
    /// A logarithmic continuous scale.
    case log
    /// An exponential continuous scale.
    case power(Double)
    /// A linear continuous scale that squares the result.
    case radial
}

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
    OutputType: ConvertibleWithDouble>: ContinuousScale
{
    // ContinuousScale protocol conformance

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

    var rangeLower: OutputType? {
        _abstract()
    }

    var rangeHigher: OutputType? {
        _abstract()
    }

    func domain(lower _: InputType, higher _: InputType) -> Self {
        _abstract()
    }

    func range(lower _: OutputType, higher _: OutputType) -> Self {
        _abstract()
    }

    func transform(_: DomainDataTransform) -> Self {
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
internal final class _ContinuousScale<WrappedContinuousScale: ContinuousScale>: _AnyContinuousScale<WrappedContinuousScale.InputType, WrappedContinuousScale.OutputType> {
    private var _base: WrappedContinuousScale

    init(_ base: WrappedContinuousScale) {
        _base = base
    }

    // ContinuousScale Overrides

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

    override public var rangeLower: OutputType? {
        _base.rangeLower
    }

    override public var rangeHigher: OutputType? {
        _base.rangeHigher
    }

    override public func domain(lower: InputType, higher: InputType) -> Self {
        Self(_base.domain(lower: lower, higher: higher))
    }

    override public func range(lower: OutputType, higher: OutputType) -> Self {
        Self(_base.range(lower: lower, higher: higher))
    }

    override public func transform(_ transform: DomainDataTransform) -> Self {
        Self(_base.transform(transform))
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
    OutputType: ConvertibleWithDouble>: ContinuousScale
{
    private let _box: _AnyContinuousScale<InputType, OutputType>

    /// Creates a type-erased continuous scale.
    /// - Parameter base: The continuous scale to wrap.
    public init<WrappedScale: ContinuousScale>(_ base: WrappedScale) where WrappedScale.InputType == InputType, WrappedScale.OutputType == OutputType {
        _box = _ContinuousScale(base)
    }

    // ContinuousScale Conformance

    public var transformType: DomainDataTransform {
        _box.transformType
    }

    public var scaleType: ContinuousScaleType {
        _box.scaleType
    }

    public var domainLower: InputType {
        _box.domainLower
    }

    public var domainHigher: InputType {
        _box.domainHigher
    }

    public var domainExtent: InputType {
        _box.domainExtent
    }

    public var desiredTicks: Int {
        _box.desiredTicks
    }

    public var rangeLower: OutputType? {
        _box.rangeLower
    }

    public var rangeHigher: OutputType? {
        _box.rangeHigher
    }

    public func domain(lower: InputType, higher: InputType) -> Self {
        AnyContinuousScale(
            _box.domain(lower: lower, higher: higher)
        )
    }

    public func range(lower: OutputType, higher: OutputType) -> Self {
        AnyContinuousScale(
            _box.range(lower: lower, higher: higher)
        )
    }

    public func transform(_ transform: DomainDataTransform) -> Self {
        AnyContinuousScale(
            _box.transform(transform)
        )
    }

    public func invert(_ rangeValue: OutputType, from: OutputType, to: OutputType) -> InputType? {
        _box.invert(rangeValue, from: from, to: to)
    }

    public func scale(_ domainValue: InputType, from: OutputType, to: OutputType) -> OutputType? {
        _box.scale(domainValue, from: from, to: to)
    }

    // Scale Conformance

    public func invert(_ rangeValue: OutputType) -> InputType? {
        _box.invert(rangeValue)
    }

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
