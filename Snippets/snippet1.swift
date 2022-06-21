import Foundation
import SwiftVizScale

func doSomething() {
    let linear = LinearScale<Double, CGFloat>(0.0 ... 50.0)
    let scaledValue = linear.scale(3, from: 0, to: 100)
    print(String(describing: scaledValue))
}

