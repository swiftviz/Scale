//
//  NiceNumber.swift
//
//
//  Created by Joseph Heck on 3/7/22.
//

import Foundation
import Numerics
#if canImport(CoreGraphics)
    import CoreGraphics
#endif

// MARK: - Integers

public extension BinaryInteger {
    static func niceVersion(for number: Self, trendTowardsZero: Bool) -> Self {
        let negativeInput: Bool = number < 0
        let positiveNumber = abs(Double(number))

        let exponent = floor(log10(positiveNumber))
        let fraction = Double(number) / pow(10, exponent)
        let niceFraction: Double

        if trendTowardsZero {
            if fraction <= 1.5 {
                niceFraction = 1
            } else if fraction <= 3 {
                niceFraction = 2
            } else if fraction <= 7 {
                niceFraction = 5
            } else {
                niceFraction = 10
            }
        } else {
            if fraction <= 1 {
                niceFraction = 1
            } else if fraction <= 2 {
                niceFraction = 2
            } else if fraction <= 5 {
                niceFraction = 5
            } else {
                niceFraction = 10
            }
        }
        if negativeInput {
            return Self(-1.0 * niceFraction * pow(10, exponent))
        }
        return Self(niceFraction * pow(10, exponent))
    }

    static func niceMinimumValueForRange(min: Self, max: Self) -> Self {
        let negativeMinValue = min < 0
        let nice = niceVersion(for: min, trendTowardsZero: !negativeMinValue)
        if negativeMinValue {
            // if the minimum value is below 0, then
            // round it further negative to the next "nice" number
            return nice
        }
        // Otherwise, compare nice against the upper range, and if it's smaller
        // than 10% of the extent of the range, round it down to 0.
        return nice <= (max / 10) ? 0 : nice
    }

    static func niceMinStepMax(min: Self, max: Self, ofSize size: Int) -> (Self, Self, Self) {
        precondition(size > 1)
        let niceMin = niceMinimumValueForRange(min: min, max: max)
        // print("niced min: \(niceMin)")
        let step = (max - niceMin) / Self(size - 1)
        // print("step: \(step)")
        let niceStep = niceVersion(for: step, trendTowardsZero: false)
        // print("niced step: \(niceStep)")
        var niceMax = niceVersion(for: max + niceStep, trendTowardsZero: true)
        // niceMax should never be below the provided 'max' value, so increment by the
        // calculated step value until it's above it:
        while niceMax < max {
            niceMax += niceStep
        }
        return (niceMin, niceStep, niceMax)
    }

    static func rangeOfNiceValues(min: Self, max: Self, ofSize size: Int) -> [Self] {
        let (niceMin, niceStep, _) = niceMinStepMax(min: min, max: max, ofSize: size)
        var result: [Self] = []
        result.append(niceMin)
        for i in 1 ... size - 1 {
            result.append(niceMin + Self(i) * niceStep)
        }
        return result
    }
}

// MARK: - FloatingPoint

public extension BinaryFloatingPoint {
    static func niceVersion(for number: Self, trendTowardsZero: Bool) -> Self {
        let negativeInput: Bool = number < 0
        let positiveNumber = abs(Double(number))
        var exponent = floor(log10(positiveNumber))
        let fraction = positiveNumber / pow(10, exponent)
        let niceFraction: Double

        if trendTowardsZero {
            // we're trying to round to the nearest 'nice' number - interval of 1, 2, 5, or 10
            // that's CLOSER TO ZERO than the provided number.
            if fraction < 1 {
                niceFraction = 10
                exponent = max(0, exponent - 1.0)
            } else if fraction < 2 {
                niceFraction = 1
            } else if fraction < 5 {
                niceFraction = 2
            } else {
                niceFraction = 5
            }
        } else {
            // we're trying to round to the nearest 'nice' number - interval of 1, 2, 5, or 10
            // that's FARTHER FROM ZERO than the provided number.
            if fraction <= 1 {
                niceFraction = 1
            } else if fraction <= 2 {
                niceFraction = 2
            } else if fraction <= 5 {
                niceFraction = 5
            } else {
                niceFraction = 10
            }
        }
        if negativeInput {
            return Self(-1.0 * niceFraction * pow(10, exponent))
        }
        return Self(niceFraction * pow(10, exponent))
    }

    static func niceMinimumValueForRange(min: Self, max: Self) -> Self {
        let minValueBelowZero = min < 0

        let nice = niceVersion(for: min, trendTowardsZero: !minValueBelowZero)
        if minValueBelowZero {
            // if the minimum value is below 0, then
            // round it further negative to the next "nice" number
            return nice
        }
        // Otherwise, compare nice against the upper range, and if it's smaller
        // than 10% of the extent of the range, round it down to 0.
        let tenPercentOfRange = (max - min) / 10
        if nice < (max - tenPercentOfRange), !minValueBelowZero {
            return 0
        }
        return nice
    }

    static func niceMinStepMax(min: Self, max: Self, ofSize size: Int) -> (Self, Self, Self) {
        precondition(size > 1)
        let niceMin = niceMinimumValueForRange(min: min, max: max)
        // print("niced min: \(niceMin)")
        let step = (max - niceMin) / Self(size - 1)
        // print("step: \(step)")
        let niceStep = niceVersion(for: step, trendTowardsZero: false)
        // print("niced step: \(niceStep)")
        var niceMax = niceVersion(for: max + niceStep, trendTowardsZero: true)
        // print("niced max: \(niceMax)")
        // niceMax should never be below the provided 'max' value, so increment by the
        // calculated step value until it's above it:
        while niceMax < max {
            niceMax += niceStep
        }
        return (niceMin, niceStep, niceMax)
    }

    static func rangeOfNiceValues(min: Self, max: Self, ofSize size: Int) -> [Self] {
        let (niceMin, niceStep, niceMax) = niceMinStepMax(min: min, max: max, ofSize: size)
        var result: [Self] = []
        // incrementing the comparison point by a half step
        // prevents some slight rounding errors that could lead
        // to a final value not getting appended.
        let comparisonPoint = niceMax + (0.5 * niceStep)
        result.append(niceMin)
        for i in 1 ... size - 1 {
            let steppedValue = niceMin + Self(i) * niceStep
            if steppedValue <= comparisonPoint {
                result.append(steppedValue)
            } else {
                break
            }
        }
        return result
    }
}
