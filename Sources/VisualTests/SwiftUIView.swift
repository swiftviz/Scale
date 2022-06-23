//
//  SwiftUIView.swift
//  

import SwiftUI
import Numerics
@testable import SwiftVizScale

@available(macOS 12.0, *)
struct SwiftUIView: View {
    let steps: CGFloat = 32
    let red = CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)
    let blue = CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 1)
    func color(_ stepValue: Int) -> CGColor {
        LCH.interpolate(red,
                        blue,
                        t: normalize(Double(stepValue), lower: 0.0, higher: 31.0),
                        using: CGColorSpace(name: CGColorSpace.sRGB)!)
    }
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0.0) {
                ForEach((0...31), id: \.self) { stepValue in
                    Color(cgColor: color(stepValue))
                        .frame(width: proxy.size.width/steps, height: proxy.size.width/steps)
                }
            }
        }
        
    }
}

@available(macOS 12.0, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
