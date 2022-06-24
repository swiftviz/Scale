//
//  InterpolationView.swift
//

import Numerics
import SwiftUI
@testable import SwiftVizScale

@available(macOS 12.0, iOS 15.0, *)
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
        ZStack {
            GeometryReader { proxy in
                HStack(spacing: 0.0) {
                    ForEach(0 ... 31, id: \.self) { stepValue in
                        Color(cgColor: color(stepValue))
                            .frame(width: proxy.size.width / steps, height: 30)
                    }
                }
                Text(String(colorspace.name!))
            }
        }
    }
}

@available(macOS 12.0, iOS 15.0, *)
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
        ZStack {
            GeometryReader { proxy in
                HStack(spacing: 0.0) {
                    ForEach(0 ... 31, id: \.self) { stepValue in
                        Color(cgColor: color(stepValue))
                            .frame(width: proxy.size.width / steps, height: 30)
                    }
                }
                Text("LCH")
            }
        }
    }
}

@available(macOS 12.0, iOS 15.0, *)
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

struct LCHValues: View {
    var values: [CGFloat]
    var name: String
    var body: some View {
        HStack {
            Text(name)
            Text("L: \(values[0])")
            Text("C: \(values[1])")
            Text("H: \(values[2])")
            Text("a: \(values[3])")
        }
    }

    public init(color: CGColor, name: String) {
        values = LCH.components(from: color)
        self.name = name
    }
}

@available(macOS 12.0, iOS 15.0, *)
struct LCHAssembler: View {
    static let red = CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)
    static let blue = CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 1)
    static let green = CGColor(srgbRed: 0, green: 1, blue: 0, alpha: 1)
    static let white = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
    static let black = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)

    static let yellow = CGColor(srgbRed: 1, green: 1, blue: 0, alpha: 1)
    static let purple = CGColor(srgbRed: 1, green: 0, blue: 1, alpha: 1)
    static let cyan = CGColor(srgbRed: 0, green: 1, blue: 1, alpha: 1)
    @State private var L: CGFloat = 100 // luminance ( 0 - 100 )
    @State private var C: CGFloat = 130 // chroma ( 0 - 130 )
    @State private var H: CGFloat = 0 // hue ( iterations of 2*.pi )

    let decimal: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    func colorFromLCHComponents(_ l: CGFloat, _ c: CGFloat, _ h: CGFloat) -> CGColor {
        LCH.color(from: [l, c, h, 1.0])
    }

    var body: some View {
        VStack {
            Group {
                LCHValues(color: LCHAssembler.red, name: "red")
                LCHValues(color: LCHAssembler.blue, name: "blue")
                LCHValues(color: LCHAssembler.green, name: "green")

                LCHValues(color: LCHAssembler.white, name: "white")
                LCHValues(color: LCHAssembler.black, name: "black")

                LCHValues(color: LCHAssembler.yellow, name: "yellow")
                LCHValues(color: LCHAssembler.purple, name: "purple")
                LCHValues(color: LCHAssembler.cyan, name: "cyan")
            }
            Form {
                TextField("L", value: $L, formatter: decimal)
                TextField("C", value: $C, formatter: decimal)
                TextField("H", value: $H, formatter: decimal)
            }
            Text("\(L), \(C), \(H)")
            Color(cgColor: colorFromLCHComponents(L, C, H))
                .frame(width: 40, height: 40)
        }
        .padding()
    }
}

@available(macOS 12.0, iOS 15.0, *)
struct LCHAssembler_Previews: PreviewProvider {
    static var previews: some View {
        LCHAssembler()
    }
}

@available(macOS 12.0, iOS 15.0, *)
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
    }
}
