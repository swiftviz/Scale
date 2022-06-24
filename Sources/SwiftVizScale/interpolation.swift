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

/// interpolate(a, b)(t) takes a parameter t in [0,1] and
/// returns the corresponding range value t in [a,b].
func interpolate<T: Real>(_ t: T, lower: T, higher: T) -> T {
    // strict interpolation would require: precondition(t >= 0 && t <= 1)
    lower + (higher - lower) * t
}

public protocol Interpolator {
    associatedtype OutputType
    func interpolate<T: Real>(_ t: T) -> OutputType
}

import CoreGraphics
public enum LCH {
    // https://en.wikipedia.org/wiki/HSL_and_HSV
    // https://en.wikipedia.org/wiki/HCL_color_space
    // https://en.wikipedia.org/wiki/CIELUV#Cylindrical_representation_(CIELCh) (aka HCL)
    // https://en.wikipedia.org/wiki/CIELAB_color_space
    // https://mina86.com/2021/srgb-lab-lchab-conversions/

    // Interpolating between hues with HSV results in varying levels of perceived luminosity.
    // The HCL color maintains luminosity as you interpolate across hues.
    // H: Hue, C: Chroma, L: Lightness

    // examples interpolating through different color spaces (javascript)
    // https://observablehq.com/@zanarmstrong/comparing-interpolating-in-different-color-spaces
    // https://bl.ocks.org/mbostock/3014589

    // Color interpolation discussion:
    // https://www.alanzucconi.com/2016/01/06/colour-interpolation/

    public static var lab = CGColorSpace(name: CGColorSpace.genericLab)!

    static func color(from components: [CGFloat]) -> CGColor {
        precondition(components.count == 4)
        var newComponents = components
        // from https://mina86.com/2021/srgb-lab-lchab-conversions/
        // reversing the computation (LCHab -> La*b*)
        // L = L
        // a* = C * cos(Hab)
        // b* = C * sin(Hab)
        let c = newComponents[1]
        let h = newComponents[2]
        let a = c * sin(h)
        let b = c * cos(h)
        newComponents[1] = a
        newComponents[2] = b
        return CGColor(colorSpace: Self.lab, components: newComponents)!
    }

    static func components(from color: CGColor) -> [CGFloat] {
        // from https://mina86.com/2021/srgb-lab-lchab-conversions/
        // converting L,a*,b* to L,C,Hab (polar coordinate LAB color space)
        // L (luminance) = L
        // C (chroma)    = sqrt(a* ^ 2, b* ^ 2)
        // Hab (hue)     = atan2(b*, a*)
        let labColor = color.converted(to: lab, intent: .perceptual, options: nil)!
        var components = labColor.components!
        precondition(components.count == 4)
        let a = components[1]
        let b = components[2]
        let c = sqrt(a * a + b * b)
        let h = atan2(a, b)
        components[1] = c
        components[2] = h
        return components
    }

    static func color(from components: [CGFloat], using colorspace: CGColorSpace) -> CGColor {
        CGColor(colorSpace: colorspace, components: components)!
    }

    static func components(from color: CGColor, for colorspace: CGColorSpace) -> [CGFloat] {
        let convertedColor = color.converted(to: colorspace, intent: .perceptual, options: nil)!
        let components = convertedColor.components!
        return components
    }

    static func interpolate(_ color1: CGColor, _ color2: CGColor, t: CGFloat, using colorspace: CGColorSpace) -> CGColor {
        precondition(t >= 0 && t <= 1)
        let components1 = LCH.components(from: color1, for: colorspace)
        let components2 = LCH.components(from: color2, for: colorspace)
        let newComponents = [
            components1[0] + (components2[0] - components1[0]) * t,
            components1[1] + (components2[1] - components1[1]) * t,
            components1[2] + (components2[2] - components1[2]) * t,
            components1[3] + (components2[3] - components1[3]) * t,
        ]
        return LCH.color(from: newComponents, using: colorspace)
    }

    // LCH component values from stock sRGB combinations:
    // red:    54.3, 107.3,  0.8
    // blue:   29.6, 131.7,  2.6
    // green:  87.8, 113.7, -0.7
    // yellow: 97.6,  95.1, -0.17
    // purple: 60.2, 111.8,  2.1
    // teal:   90.6,  53.0, -1.86
    // white:  100,     0,   0
    // black:    0,     0,   0

    static func interpolate(_ color1: CGColor, _ color2: CGColor, t: CGFloat) -> CGColor {
        precondition(t >= 0 && t <= 1)
        let components1 = LCH.components(from: color1)
        let components2 = LCH.components(from: color2)
        // blue to green in LCH is interpolated through red... unexpected
        // blue:   29.6, 131.7,  2.6
        // green:  87.8, 113.7, -0.7

        // 0 ... 6.28
        let newComponents = [
            components1[0] + (components2[0] - components1[0]) * t,
            components1[1] + (components2[1] - components1[1]) * t,
            components1[2] + (components2[2] - components1[2]) * t,
            components1[3] + (components2[3] - components1[3]) * t,
        ]
        return LCH.color(from: newComponents)
    }
}
