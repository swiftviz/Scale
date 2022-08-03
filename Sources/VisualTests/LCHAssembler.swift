//
//  LCHAssembler.swift
//
#if canImport(SwiftUI)
    import SwiftUI
    @testable import SwiftVizScale

    /// Displays the Luminance, Chroma, Hue, and gamma values for LCH components of the color you provide.
    @available(watchOS 6.0, *)
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

    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    struct LCHAssembler: View {
        static let red = CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)
        static let blue = CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 1)
        static let green = CGColor(srgbRed: 0, green: 1, blue: 0, alpha: 1)
        static let white = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        static let black = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)

        static let yellow = CGColor(srgbRed: 1, green: 1, blue: 0, alpha: 1)
        static let purple = CGColor(srgbRed: 1, green: 0, blue: 1, alpha: 1)
        static let teal = CGColor(srgbRed: 0, green: 1, blue: 1, alpha: 1)
        @State private var L: CGFloat = 100 // luminance ( 0 - 100 )
        @State private var C: CGFloat = 130 // chroma ( 0 - 130 )
        @State private var H: CGFloat = 0 // hue ( iterations of 2*.pi )

        let decimal: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()

        var tau: CGFloat {
            CGFloat(Double.pi * 2)
        }

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
                    LCHValues(color: LCHAssembler.teal, name: "teal")
                }
                Form {
                    TextField("L", value: $L, formatter: decimal)
                    TextField("C", value: $C, formatter: decimal)
                    TextField("H", value: $H, formatter: decimal)
                    #if !os(tvOS)
                        Slider(value: $H, in: -tau ... tau, step: 0.1)
                    #endif
                }
                Text("\(L), \(C), \(H)")
                Color(cgColor: colorFromLCHComponents(L, C, H))
                    .frame(width: 40, height: 40)
            }
            .padding()
        }
    }

    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    struct LCHAssembler_Previews: PreviewProvider {
        static var previews: some View {
            LCHAssembler()
        }
    }
#endif
