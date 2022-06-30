////
////  ColorInterpolatorView.swift
////
//
//import SwiftUI
//import SwiftVizScale
//import Numerics
//
///// normalize(x, a ... b) takes a value x and normalizes it across the domain a...b
///// It returns the corresponding parameter within the range [0...1] if it was within the domain of the scale
///// If the value provided is outside of the domain of the scale, the resulting normalized value will be extrapolated
//func normalize<T: Real>(_ x: T, lower: T, higher: T) -> T {
//    precondition(lower < higher)
//    let extent = higher - lower
//    return (x - lower) / extent
//}
//
//@available(macOS 12.0, iOS 15.0, *)
//public struct ColorInterpolatorView: View {
//    var steps: CGFloat
//    var interpolator: ColorInterpolator
//
//    func color(_ stepValue: Int) -> CGColor {
//        let t = normalize(Double(stepValue),
//                          lower: 0.0,
//                          higher: steps - 1)
//        return interpolator.interpolate(t)
//    }
//
//    public init(steps: CGFloat, interpolator: ColorInterpolator) {
//        self.steps = steps
//        self.interpolator = interpolator
//    }
//    
//    public var body: some View {
//        GeometryReader { proxy in
//            HStack(spacing: 0.0) {
//                ForEach(0 ... Int(steps - 1), id: \.self) { stepValue in
//                    Color(cgColor: color(stepValue))
//                        .frame(width: proxy.size.width / steps)
//                }
//            }
//        }
//    }
//}
//
////@available(macOS 12.0, iOS 15.0, *)
////struct ColorInterpolatorView_Previews: PreviewProvider {
////    static var previews: some View {
////        ColorInterpolatorView(steps: 128, interpolator: .Viridis)
////    }
////}
////
