//
//  SwiftUIView.swift
//

import Numerics
import SwiftUI
@testable import SwiftVizScale

@available(macOS 12.0, *)
struct InterpolationView: View {
    var steps: CGFloat
    var startColor: CGColor
    var endColor: CGColor
    var colorspace: CGColorSpace
    func color(_ stepValue: Int) -> CGColor {
        LCH.interpolate(startColor,
                        endColor,
                        t: normalize(Double(stepValue), lower: 0.0, higher: 31.0),
                        using: colorspace)
    }

    var body: some View {
        VStack {
            Text(String(colorspace.name!))
            GeometryReader { proxy in
                HStack(spacing: 0.0) {
                    ForEach(0 ... 31, id: \.self) { stepValue in
                        Color(cgColor: color(stepValue))
                            .frame(width: proxy.size.width / steps, height: 40)
                    }
                }
            }
        }
    }
}

@available(macOS 12.0, *)
struct LCHInterpolationView: View {
    var steps: CGFloat
    var startColor: CGColor
    var endColor: CGColor
    func color(_ stepValue: Int) -> CGColor {
        LCH.interpolate(startColor,
                        endColor,
                        t: normalize(Double(stepValue), lower: 0.0, higher: 31.0))
    }

    var body: some View {
        VStack {
            Text("LCH")
            GeometryReader { proxy in
                HStack(spacing: 0.0) {
                    ForEach(0 ... 31, id: \.self) { stepValue in
                        Color(cgColor: color(stepValue))
                            .frame(width: proxy.size.width / steps, height: 40)
                    }
                }
            }
            Divider()
        }
    }
}

@available(macOS 12.0, *)
struct InterpolationView_Previews: PreviewProvider {
    let steps: CGFloat = 64
    static let red = CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)
    static let blue = CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 1)

    static var previews: some View {
        VStack {
            InterpolationView(steps: 32, startColor: red, endColor: blue, colorspace: CGColorSpace(name: CGColorSpace.genericLab)!)
            
            InterpolationView(steps: 32, startColor: red, endColor: blue, colorspace: CGColorSpace(name: CGColorSpace.genericXYZ)!)
            
            InterpolationView(steps: 32, startColor: red, endColor: blue, colorspace: CGColorSpace(name: CGColorSpace.genericRGBLinear)!)
            
            InterpolationView(steps: 32, startColor: red, endColor: blue, colorspace: CGColorSpace(name: CGColorSpace.sRGB)!)
            
            InterpolationView(steps: 32, startColor: red, endColor: blue, colorspace: CGColorSpace(name: CGColorSpace.extendedLinearSRGB)!)
            
            LCHInterpolationView(steps: 32, startColor: red, endColor: blue)
        }
    }
}
