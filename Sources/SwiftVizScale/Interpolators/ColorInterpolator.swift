//
//  ColorInterpolator.swift
//
#if canImport(CoreGraphics)
    import CoreGraphics

    /// A type that can provide an interpolated color.
    public protocol ColorInterpolator {
        /// Returns the color mapped from the unit value you provide.
        /// - Parameter t: A unit value between `0` and  `1`.
        func interpolate(_ t: Double) -> CGColor
    }
#endif
