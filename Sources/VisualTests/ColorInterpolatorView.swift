//
//  ColorInterpolatorView.swift
//

import SwiftUI
@testable import SwiftVizScale

@available(macOS 12.0, iOS 15.0, *)
struct ColorInterpolatorView: View {
    var steps: CGFloat
    var interpolator: ColorInterpolator

    func color(_ stepValue: Int) -> CGColor {
        let t = normalize(Double(stepValue),
                          lower: 0.0,
                          higher: steps - 1)
        return interpolator.interpolate(t)
    }

    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0.0) {
                ForEach(0 ... Int(steps - 1), id: \.self) { stepValue in
                    Color(cgColor: color(stepValue))
                        .frame(width: proxy.size.width / steps)
                }
            }
        }
    }
}

@available(macOS 12.0, iOS 15.0, *)
struct ColorInterpolatorView_Previews: PreviewProvider {
    static var previews: some View {
        ColorInterpolatorView(steps: 128, interpolator: .Viridis)
    }
}
