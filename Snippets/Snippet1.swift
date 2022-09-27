import Foundation
import SwiftVizScale

// snippet.setup
func doSomething() {
    let linear = ContinuousScale<CGFloat>(0.0 ... 50.0)
    let scaledValue = linear.scale(3, from: 0, to: 100)
    print(String(describing: scaledValue))
}

// snippet.end
doSomething()
