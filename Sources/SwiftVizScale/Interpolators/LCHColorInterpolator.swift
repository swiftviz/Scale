//
//  LCHColorInterpolator.swift
//
#if canImport(CoreGraphics)
    import CoreGraphics

    /// A color interpolator that maps colors between two colors through the LCH color space.
    @available(watchOS 6.0, *)
    public struct LCHColorInterpolator: ColorInterpolator {
        let startColor: CGColor
        let endColor: CGColor

        /// Creates a new color interpolator that maps between the two colors you provide.
        /// - Parameters:
        ///   - from: The color at the beginning.
        ///   - to: The color at the end.
        public init(_ from: CGColor, _ to: CGColor) {
            startColor = from
            endColor = to
        }

        /// Returns the color mapped from the unit value you provide.
        /// - Parameter t: A unit value between `0` and  `1`.
        public func interpolate(_ t: Double) -> CGColor {
            LCH.interpolate(startColor, endColor, t: t)
        }
    }
#endif
