//
//  InterpolationView.swift
//

import SwiftUI
@testable import SwiftVizScale

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
struct InterpolationView: View {
    var steps: CGFloat
    var startColor: CGColor
    var endColor: CGColor
    var colorspace: CGColorSpace
    func color(_ stepValue: Int) -> CGColor {
        IndexedColorInterpolator.interpolate(startColor,
                                      endColor,
                                      t: normalize(Double(stepValue), lower: 0.0, higher: steps - 1),
                                      using: colorspace)
    }

    var body: some View {
        ZStack {
            GeometryReader { proxy in
                HStack(spacing: 0.0) {
                    ForEach(0 ... Int(steps - 1), id: \.self) { stepValue in
                        Color(cgColor: color(stepValue))
                            .frame(width: proxy.size.width / steps, height: 30)
                    }
                }
                Text(String(colorspace.name!))
            }
        }
    }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
struct LCHInterpolationView: View {
    var steps: CGFloat
    var startColor: CGColor
    var endColor: CGColor
    func color(_ stepValue: Int) -> CGColor {
        LCH.interpolate(startColor,
                        endColor,
                        t: normalize(Double(stepValue), lower: 0.0, higher: steps - 1))
    }

    var body: some View {
        ZStack {
            GeometryReader { proxy in
                HStack(spacing: 0.0) {
                    ForEach(0 ... Int(steps - 1), id: \.self) { stepValue in
                        Color(cgColor: color(stepValue))
                            .frame(width: proxy.size.width / steps, height: 30)
                    }
                }
                Text("LCH")
            }
        }
    }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
struct InterpolationSetView: View {
    var steps: CGFloat
    var startColor: CGColor
    var endColor: CGColor

    var body: some View {
        VStack {
            InterpolationView(steps: 32, startColor: startColor, endColor: endColor, colorspace: CGColorSpace(name: CGColorSpace.genericLab)!)

//            InterpolationView(steps: 32, startColor: startColor, endColor: endColor, colorspace: CGColorSpace(name: CGColorSpace.genericXYZ)!)
//
//            InterpolationView(steps: 32, startColor: startColor, endColor: endColor, colorspace: CGColorSpace(name: CGColorSpace.genericRGBLinear)!)
//
//            InterpolationView(steps: 32, startColor: startColor, endColor: endColor, colorspace: CGColorSpace(name: CGColorSpace.sRGB)!)
//
//            InterpolationView(steps: 32, startColor: startColor, endColor: endColor, colorspace: CGColorSpace(name: CGColorSpace.extendedLinearSRGB)!)

            LCHInterpolationView(steps: 32, startColor: startColor, endColor: endColor)
        }
    }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
struct InterpolationView_Previews: PreviewProvider {
    static let red = CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)
    static let blue = CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 1)
    static let green = CGColor(srgbRed: 0, green: 1, blue: 0, alpha: 1)
    static let white = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)

    static let black = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)

    static var previews: some View {
        VStack {
            InterpolationSetView(steps: 64, startColor: white, endColor: black)
            InterpolationSetView(steps: 64, startColor: red, endColor: blue)
            InterpolationSetView(steps: 64, startColor: blue, endColor: green)
            InterpolationSetView(steps: 64, startColor: green, endColor: red)
        }
        .padding()
    }
}
