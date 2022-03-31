//
//  TickScale.swift
//
//
//  Created by Joseph Heck on 3/10/22.
//

import Foundation
import Numerics

/// A type of scale that provides tick values from the domain it represents.
public protocol TickScale: Scale {
    /// The number of ticks desired when creating the scale.
    ///
    /// This number may not match the number of ticks returned by ``TickScale/tickValues(_:from:to:)``
    var desiredTicks: Int { get }
}

public extension TickScale where OutputType: Real {
    /// Converts an array of values that matches the scale's input type to a list of ticks that are within the scale's domain.
    ///
    /// Used for manually specifying a series of ticks that you want to have displayed.
    ///
    /// Values presented for display that are *not* within the domain of the scale are dropped.
    /// Values that scale outside of the range you provide are adjusted based on the setting of ``Scale/transformType``.
    /// - Parameter inputValues: an array of values of the Scale's InputType
    /// - Parameter lower: The lower value of the range the scale maps to.
    /// - Parameter higher: The higher value of the range the scale maps to.
    /// - Returns: A list of tick values validated against the domain, and range based on the setting of ``Scale/transformType``
    func tickValues(_ inputValues: [InputType], from lower: OutputType, to higher: OutputType) -> [Tick<InputType, OutputType>] {
        inputValues.compactMap { inputValue in
            if domainContains(inputValue),
               let rangeValue = scale(inputValue, from: lower, to: higher)
            {
                switch transformType {
                case .none:
                    return Tick(value: inputValue, location: rangeValue)
                case .drop:
                    if rangeValue > higher || rangeValue < lower {
                        return nil
                    }
                    return Tick(value: inputValue, location: rangeValue)
                case .clamp:
                    if rangeValue > higher {
                        return Tick(value: inputValue, location: higher)
                    } else if rangeValue < lower {
                        return Tick(value: inputValue, location: lower)
                    }
                    return Tick(value: inputValue, location: rangeValue)
                }
            }
            return nil
        }
    }
}

public extension TickScale where InputType == Int, OutputType: Real {
    /// Returns an array of the locations within the output range to locate ticks for the scale.
    ///
    /// - Parameter range: a ClosedRange representing the representing the range we are mapping the values into with the scale
    /// - Returns: an Array of the values within the ClosedRange of range
    func ticks(rangeLower: OutputType, rangeHigher: OutputType) -> [Tick<InputType, OutputType>] {
        let tickValues = InputType.rangeOfNiceValues(min: domainLower, max: domainHigher, ofSize: desiredTicks)
        return tickValues.compactMap { tickValue in
            if let tickRangeLocation = scale(tickValue, from: rangeLower, to: rangeHigher) {
                return Tick(value: tickValue, location: tickRangeLocation)
            }
            return nil
        }
    }
}

public extension TickScale where InputType == Float, OutputType: Real {
    /// Returns an array of the locations within the output range to locate ticks for the scale.
    ///
    /// - Parameter range: a ClosedRange representing the representing the range we are mapping the values into with the scale
    /// - Returns: an Array of the values within the ClosedRange of range
    func ticks(rangeLower: OutputType, rangeHigher: OutputType) -> [Tick<InputType, OutputType>] {
        let tickValues = InputType.rangeOfNiceValues(min: domainLower, max: domainHigher, ofSize: desiredTicks)
        return tickValues.compactMap { tickValue in
            if let tickRangeLocation = scale(tickValue, from: rangeLower, to: rangeHigher) {
                return Tick(value: tickValue, location: tickRangeLocation)
            }
            return nil
        }
    }
}

public extension TickScale where InputType == Double, OutputType: Real {
    /// Returns an array of the locations within the output range to locate ticks for the scale.
    ///
    /// - Parameter range: a ClosedRange representing the representing the range we are mapping the values into with the scale
    /// - Returns: an Array of the values within the ClosedRange of range
    func ticks(rangeLower: OutputType, rangeHigher: OutputType) -> [Tick<InputType, OutputType>] {
        let tickValues = InputType.rangeOfNiceValues(min: domainLower, max: domainHigher, ofSize: desiredTicks)
        return tickValues.compactMap { tickValue in
            if let tickRangeLocation = scale(tickValue, from: rangeLower, to: rangeHigher),
               tickRangeLocation <= rangeHigher
            {
                return Tick(value: tickValue, location: tickRangeLocation)
            }
            return nil
        }
    }
}
