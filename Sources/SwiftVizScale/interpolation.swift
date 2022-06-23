import Numerics

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
    precondition(x >= 0 && x <= 1)
    return lower * (1 - x) + higher * x
}

public protocol Interpolator {
    associatedtype OutputType
    func interpolate<T: Real>(_ t: T) -> OutputType
}

import CoreGraphics
enum MyColorSpaces {
    private static var rgb: CGColorSpace = .init(name: CGColorSpace.genericRGBLinear)!

    private static var lab: CGColorSpace = .init(name: CGColorSpace.genericLab)!

    static func color(from components: [CGFloat]) -> CGColor {
        CGColor(colorSpace: Self.rgb, components: components)!
    }

    static func components(from color: CGColor) -> [CGFloat] {
        let convertedColor = color.converted(to: Self.rgb, intent: .perceptual, options: nil)!
        let components = convertedColor.components!
        return components
    }

    static func interpolate(_ color1: CGColor, _ color2: CGColor, t: CGFloat) -> CGColor {
        precondition(t >= 0 && t <= 1)
        let components1 = MyColorSpaces.components(from: color1)
        let components2 = MyColorSpaces.components(from: color2)
        let newComponents = [
            components1[0] + (components2[0] - components1[0]) * t,
            components1[1] + (components2[1] - components1[1]) * t,
            components1[2] + (components2[2] - components1[2]) * t,
            components1[3] + (components2[3] - components1[3]) * t,
        ]
        return MyColorSpaces.color(from: newComponents)
    }
}
