//
//  NiceValue.swift
//

import Foundation

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

// MARK: - FloatingPoint Numbers

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

    static func logRangeOfNiceValues(min: Self, max: Self) -> [Self] {
        // ex: 2 to 2013 - extent = 2011, mag of extent: 3.3
        // Safety net - make sure we're not passed '0', which explodes the math in this
        // algorithm. If they're that crazy, pick the smallest non-zero value and work up
        // from there.
        let fixedMin: Double
        if min == 0 {
            fixedMin = Double.leastNonzeroMagnitude
        } else {
            fixedMin = Double(min)
        }
        let testRange = fixedMin ... Double(max)
        var result: [Self] = []
        // values:
        //  - iterate up from the lowest included value using a 1,2,5 pattern
        //    for each magnitude within the range.
        //  - stop when > max
        var magnitude = floor(log10(fixedMin))
        let cutoff = log10(Double(max))
        while magnitude < cutoff {
            // The 1,2,5 pattern presents the most visually even display of ticks
            // within a log output.
            // 10  -> 1
            // 20  -> 1.3
            // 50  -> 1.69
            // 100 -> 2
            let marks = [1, 2, 5].map { $0 * pow(10.0, magnitude) }
            for m in marks {
                if testRange.contains(m) {
                    result.append(Self(m))
                }
            }
            magnitude += 1.0
        }
        return result
    }
}

// MARK: - Dates

/// A type that represents the magnitude of the range between two dates.
public enum DateMagnitude: Equatable {
    /// Less than a second.
    case subsecond
    /// Seconds, up to a minute.
    case seconds
    /// Minutes, up to an hour.
    case minutes
    /// Hours, up to a day.
    case hours
    /// Days, up to a month.
    case days
    /// Months, up to a year.
    case months
    /// Years.
    case years(magnitude: Double, fraction: Double)

    static let subsecondThreshold: PartialRangeUpTo<Double> = ..<1
    static let secondsThreshold: Range<Double> = 1 ..< 60
    static let minutesThreshold: Range<Double> = 60 ..< 60 * 60
    static let hoursThreshold: Range<Double> = 60 * 60 ..< 60 * 60 * 24
    static let daysThreshold: Range<Double> = 60 * 60 * 24 ..< 60 * 60 * 24 * 28
    static let monthsThreshold: Range<Double> = 60 * 60 * 24 * 28 ..< 60 * 60 * 24 * 365
    static let yearsThreshold: PartialRangeFrom<Double> = (60 * 60 * 24 * 365)...

    public static func magnitudeOfDateRange(_ lhs: Date, _ rhs: Date) -> DateMagnitude {
        let dateExtentMagnitude = abs(lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate)
        switch dateExtentMagnitude {
        case subsecondThreshold:
            return .subsecond
        case secondsThreshold:
            return .seconds
        case minutesThreshold:
            return .minutes
        case hoursThreshold:
            return .hours
        case daysThreshold:
            return .days
        case monthsThreshold:
            return .months
        default:
            let yearsValue = abs(lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate) / yearsThreshold.lowerBound
            let yearsMagnitude = floor(log10(yearsValue))
            let yearsFraction = yearsValue / pow(10, yearsMagnitude)
            // print("\(lhs) to \(rhs) is \(yearsValue) years")
            // print("log10 of that is \(log10(yearsValue))")
            return .years(magnitude: yearsMagnitude, fraction: yearsFraction)
        }
    }
}

public extension Date {
    /// Returns a Date value rounded down to the next nice "date" value based on a calendar.
    /// - Parameters:
    ///   - magnitude: The magnitude to which to round
    ///   - calendar: The calendar to use to compute the next lower value.
    func round(magnitude: DateMagnitude, calendar: Calendar) -> Self? {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond, .timeZone, .calendar], from: self)
        assert(components.isValidDate)

        switch magnitude {
        case .subsecond:
            // print(components.nanosecond)
            let asSeconds: Double = .init(components.nanosecond!)
            // ALT:
            let x = Double.niceVersion(for: asSeconds, trendTowardsZero: true)
            print("Original: \(asSeconds) converts to: \(x)")
            components.nanosecond = Int(Double.niceVersion(for: asSeconds, trendTowardsZero: true))
            assert(components.isValidDate)
            return components.date

//                // 10999917 => 11ms (x.011)
//                var exponent = floor(log10(asSeconds))
//                let fraction = asSeconds / pow(10, exponent)
//                let niceFraction: Double
//
//                // Same algorithm to round down to 1, 2, or 5 based on order of magnitude
//                if fraction < 1 {
//                    niceFraction = 10
//                    exponent = max(0, exponent - 1.0)
//                } else if fraction < 2 {
//                    niceFraction = 1
//                } else if fraction < 5 {
//                    niceFraction = 2
//                } else {
//                    niceFraction = 5
//                }
//                let niceNanoseconds = niceFraction * pow(10, exponent)
//                components.nanosecond = Int(niceNanoseconds)
//                assert(components.isValidDate)
//                return components.date
        case .seconds:
            components.setValue(0, for: .nanosecond)
            assert(components.isValidDate)
            return components.date
        case .minutes:
            components.setValue(0, for: .nanosecond)
            components.setValue(0, for: .second)
            assert(components.isValidDate)
            return components.date
        case .hours:
            components.setValue(0, for: .nanosecond)
            components.setValue(0, for: .second)
            components.setValue(0, for: .minute)
            assert(components.isValidDate)
            return components.date
        case .days:
            components.setValue(0, for: .nanosecond)
            components.setValue(0, for: .second)
            components.setValue(0, for: .minute)
            components.setValue(0, for: .hour)
            assert(components.isValidDate)
            return components.date
        case .months:
            components.setValue(0, for: .nanosecond)
            components.setValue(0, for: .second)
            components.setValue(0, for: .minute)
            components.setValue(0, for: .hour)
            components.setValue(1, for: .day)
            assert(components.isValidDate)
            return components.date
        case .years:
            components.setValue(0, for: .nanosecond)
            components.setValue(0, for: .second)
            components.setValue(0, for: .minute)
            components.setValue(0, for: .hour)
            components.setValue(1, for: .day)
            components.setValue(1, for: .month)
            assert(components.isValidDate)
            return components.date
        }
    }

    static func niceStepForMagnitude(step: Double, magnitude: DateMagnitude) -> Double {
        var exponent = floor(log10(step))
        let fraction = step / pow(10, exponent)
        let niceFraction: Double
        switch magnitude {
        case .subsecond:
            if fraction <= 1 {
                niceFraction = 1
            } else if fraction <= 2 {
                niceFraction = 2
            } else if fraction <= 5 {
                niceFraction = 5
            } else {
                niceFraction = 10
            }
        case .seconds:
            exponent = 0
            if step <= 1 {
                niceFraction = 1
            } else if step <= 2 {
                niceFraction = 2
            } else if step <= 5 {
                niceFraction = 5
            } else if step <= 10 {
                niceFraction = 10
            } else {
                niceFraction = 30
            }
        case .minutes:
            exponent = 0
            let stepInMinutes = step / DateMagnitude.minutesThreshold.lowerBound
            if stepInMinutes <= 1 {
                niceFraction = 1 * DateMagnitude.minutesThreshold.lowerBound
            } else if stepInMinutes <= 2 {
                niceFraction = 2 * DateMagnitude.minutesThreshold.lowerBound
            } else if stepInMinutes <= 5 {
                niceFraction = 5 * DateMagnitude.minutesThreshold.lowerBound
            } else if stepInMinutes <= 10 {
                niceFraction = 10 * DateMagnitude.minutesThreshold.lowerBound
            } else {
                niceFraction = 30 * DateMagnitude.minutesThreshold.lowerBound
            }
        case .hours:
            exponent = 0
            let stepInHours = step / DateMagnitude.hoursThreshold.lowerBound
            if stepInHours <= 1 {
                niceFraction = 1 * DateMagnitude.hoursThreshold.lowerBound
            } else if stepInHours <= 2 {
                niceFraction = 2 * DateMagnitude.hoursThreshold.lowerBound
            } else if stepInHours <= 6 {
                niceFraction = 6 * DateMagnitude.hoursThreshold.lowerBound
            } else {
                niceFraction = 12 * DateMagnitude.hoursThreshold.lowerBound
            }
        case .days:
            exponent = 0
            let stepInDays = step / DateMagnitude.daysThreshold.lowerBound
            if stepInDays <= 1 {
                niceFraction = 1 * DateMagnitude.daysThreshold.lowerBound
            } else if stepInDays <= 2 {
                niceFraction = 2 * DateMagnitude.daysThreshold.lowerBound
            } else {
                niceFraction = 7 * DateMagnitude.daysThreshold.lowerBound
            }
        case .months:
            exponent = 0
            let stepInMonths = step / DateMagnitude.monthsThreshold.lowerBound
            if stepInMonths <= 1 {
                niceFraction = 1 * DateMagnitude.monthsThreshold.lowerBound
            } else if stepInMonths <= 2 {
                niceFraction = 2 * DateMagnitude.monthsThreshold.lowerBound
            } else {
                niceFraction = 6 * DateMagnitude.monthsThreshold.lowerBound
            }
        case let .years(magnitude: magnitude, fraction: fraction):
            exponent = 0
            let yearsFraction: Double
            if fraction <= 1 {
                yearsFraction = 1
            } else if fraction <= 2 {
                yearsFraction = 2
            } else if fraction <= 5 {
                yearsFraction = 5
            } else {
                yearsFraction = 10
            }
            niceFraction = yearsFraction * pow(10, magnitude) * DateMagnitude.yearsThreshold.lowerBound
        }
        return niceFraction * pow(10, exponent)
    }

    static func niceMinStepMax(min: Self, max: Self, ofSize size: Int, calendar: Calendar) -> (Self, Double, Self) {
        precondition(size > 1)
        let magnitude = DateMagnitude.magnitudeOfDateRange(min, max)
        let maxDouble = max.timeIntervalSinceReferenceDate
        // calculate the step size in seconds
        let step = abs(maxDouble - min.timeIntervalSinceReferenceDate) / Double(size - 1)
        // calculate a nice version of the step size (in seconds) based on the calendar magnitude of the range.
        let niceStep = Date.niceStepForMagnitude(step: step, magnitude: magnitude)

        // Add the step size (in seconds) to the current max value
        let maxAndStep = Date(timeIntervalSinceReferenceDate: maxDouble + niceStep)
        // and then round it down based on the magnitude of the distance between min and max
        if let niceMax = maxAndStep.round(magnitude: magnitude, calendar: calendar) {
            return (min, niceStep, niceMax)
        } else {
            return (min, niceStep, max)
        }
    }

    static func rangeOfNiceValues(min: Self, max: Self, ofSize size: Int, using calendar: Calendar) -> [Self] {
        // NOTE(heckj): This doesn't have an option, currently, to allow the minimum value to stay _exactly_ where
        // it is, and only modify the upper bound of the tick values to exceed the max. It sort of feels like
        // that may be a desirable result, so might need to circle back and either add an option for that
        // or add a parameter to this method to allow the choice.
        let (niceMin, niceStep, niceMax) = niceMinStepMax(min: min, max: max, ofSize: size, calendar: calendar)
        var result: [Self] = []
        // incrementing the comparison point by a half step
        // prevents some slight rounding errors that could lead
        // to a final value not getting appended.
        let comparisonPoint = niceMax.timeIntervalSinceReferenceDate + (0.5 * niceStep)
        let minInSeconds = niceMin.timeIntervalSinceReferenceDate
        result.append(niceMin)
        for i in 1 ... size - 1 {
            let steppedValue = minInSeconds + Double(i) * niceStep
            if steppedValue <= comparisonPoint {
                result.append(Date(timeIntervalSinceReferenceDate: steppedValue))
            } else {
                break
            }
        }
        return result
    }
}
