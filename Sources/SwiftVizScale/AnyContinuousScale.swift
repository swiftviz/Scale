//
//  AnyContinuousScale.swift
//
//
//  Created by Joseph Heck on 4/6/22.
//

import Foundation

public enum ContinuousScaleTypes: Equatable {
    case linear
    case log
    case power(Double)
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

    var scaleType: ContinuousScaleTypes {
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
internal final class _ContinuousScale<ContinuousScaleType: ContinuousScale>: _AnyContinuousScale<ContinuousScaleType.InputType, ContinuousScaleType.OutputType> {
    private var _base: ContinuousScaleType

    init(_ base: ContinuousScaleType) {
        _base = base
    }

    // ContinuousScale Overrides

    override public var scaleType: ContinuousScaleTypes {
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

// Partially type erased visual channel, with internals (including the type of property that
// it maps) hidden.
// A partially type-erased visual channel that maps properties from data into a mark.
public struct AnyContinuousScale<InputType: ConvertibleWithDouble & NiceValue,
    OutputType: ConvertibleWithDouble>: ContinuousScale
{
    private let _box: _AnyContinuousScale<InputType, OutputType>

    public init<CS: ContinuousScale>(_ base: CS) where CS.InputType == InputType, CS.OutputType == OutputType {
        _box = _ContinuousScale(base)
    }

    // ContinuousScale Conformance

    public var transformType: DomainDataTransform {
        _box.transformType
    }

    public var scaleType: ContinuousScaleTypes {
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
    
    public func scaleType(_ type: ContinuousScaleTypes) -> Self {
        switch type {
        case .linear:
            return AnyContinuousScale(
                LinearScale(from: _box.domainLower, to: _box.domainHigher, transform: _box.transformType, desiredTicks: _box.desiredTicks, rangeLower: nil, rangeHigher: nil)
                )
        case .log:
            return AnyContinuousScale(
                LogScale(from: _box.domainLower, to: _box.domainHigher, transform: _box.transformType, desiredTicks: _box.desiredTicks, rangeLower: nil, rangeHigher: nil)
                )
        case .power(let exponent):
            return AnyContinuousScale(
                PowerScale(from: _box.domainLower, to: _box.domainHigher, exponent: exponent, transform: _box.transformType, desiredTicks: _box.desiredTicks, rangeLower: nil, rangeHigher: nil)
                )
        case .radial:
            return AnyContinuousScale(
                LinearScale(from: _box.domainLower, to: _box.domainHigher, transform: _box.transformType, desiredTicks: _box.desiredTicks, rangeLower: nil, rangeHigher: nil)
                )
        }
        
    }
}