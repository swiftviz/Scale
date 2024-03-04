//
// LCH.swift
//
#if canImport(CoreGraphics)
    import CoreGraphics

    /// A type that provides conversion and interpolation of colors through the LCH color space.
    ///
    /// The LCH (Luminosity, Chroma, Hue) color space provides a perceptually consistent interpolation between
    /// two colors when compared to interpolating through other color spaces.
    /// Interpolation using the LAB color space is the close, but can result in perceptually darker segments during the interpolation.
    /// The following image provides a visual comparison of interpolating between the main boundary colors (red, green, and blue)
    /// when interpolated through the LAB color space and the LCH color space.
    ///
    /// ![A table of of colors interpolated using two different color spaces.](LAB_vs_LCH.png)
    /// The wikipedia article on the [LCH color space](https://en.wikipedia.org/wiki/HCL_color_space) provides more information.
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

        @MainActor
        static var lab = CGColorSpace(name: CGColorSpace.genericLab)!

        /// Creates a Core Graphics color instance from individual components in the LCH color space.
        /// - Parameter components: A list of four components in the order: Luminance, Chroma, Hue, and Alpha.
        @MainActor
        public static func color(from components: [CGFloat]) -> CGColor {
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

        /// Returns a list of four components from a Core Graphics color instance, mapped into the LCH color space.
        ///
        /// The components, in order, are Luminance, Chroma, Hue, and Alpha.
        @MainActor
        public static func components(from color: CGColor) -> [CGFloat] {
            // from https://mina86.com/2021/srgb-lab-lchab-conversions/
            // converting L,a*,b* to L,C,Hab (polar coordinate LAB color space)
            // L (luminance) = L
            // C (chroma)    = sqrt(a* ^ 2, b* ^ 2)
            // Hab (hue)     = atan2(b*, a*)
            let labColor = color.converted(to: Self.lab, intent: .perceptual, options: nil)!
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

        // LCH component values from stock sRGB combinations:
        // red:    54.3, 107.3,  0.8
        // blue:   29.6, 131.7,  2.6
        // green:  87.8, 113.7, -0.7
        // yellow: 97.6,  95.1, -0.17
        // purple: 60.2, 111.8,  2.1
        // teal:   90.6,  53.0, -1.86
        // white:  100,     0,   0
        // black:    0,     0,   0

        /// Interpolate between two colors using the LCH color space.
        ///
        /// The [LCH color space](https://en.wikipedia.org/wiki/HCL_color_space) is a mapping of the
        /// color coordinates of the CIELAB color space into polar coordinates with the goal of maintaining a perceptually
        /// constant luminosity and color value (chroma) while interpolating between two colors.
        ///
        /// - Parameters:
        ///   - color1: The first color.
        ///   - color2: The second color.
        ///   - t: A unit value between 0 and 1 representing the position between the first and second colors to return.
        /// - Returns: A color interpolated between the two colors you provide.
        @MainActor
        public static func interpolate(_ color1: CGColor, _ color2: CGColor, t: CGFloat) -> CGColor {
            precondition(t >= 0 && t <= 1)
            let components1 = LCH.components(from: color1)
            let components2 = LCH.components(from: color2)
            // blue to green in LCH is interpolated through red... unexpected
            // blue:   29.6, 131.7,  2.6
            // green:  87.8, 113.7, -0.7

            // The hue (components[2]) is an angle, in radians, with the LCH conversion.
            // As such, it's cyclic, and we need to determine if the shortest path is
            // a direct path between the two hue values provided, or if we should adjust the hue
            // by +/- 2*PI to get a shorter distance.
            let hue1 = components1[2]
            let hue2 = components2[2]
            let targetForInterpolation: CGFloat = if hue1 > hue2 {
                // If the value for hue2 is greater than hue1, add 2*PI to hue2 and compare, choosing
                // the shortest path for the target to which to interpolate.
                if abs(hue1 - hue2) > abs(hue1 - (hue2 + 2 * Double.pi)) {
                    hue2 + 2 * Double.pi
                } else {
                    hue2
                }
            } else {
                // If the value for hue2 is less than hue1, subtract 2*PI to hue2 and compare, choosing
                // the shortest path for the target to which to interpolate.
                if abs(hue1 - hue2) > abs(hue1 - (hue2 - 2 * Double.pi)) {
                    hue2 + 2 * Double.pi
                } else {
                    hue2
                }
            }

            let newComponents = [
                components1[0] + (components2[0] - components1[0]) * t,
                components1[1] + (components2[1] - components1[1]) * t,
                components1[2] + (targetForInterpolation - components1[2]) * t,
                components1[3] + (components2[3] - components1[3]) * t,
            ]
            return LCH.color(from: newComponents)
        }
    }
#endif
