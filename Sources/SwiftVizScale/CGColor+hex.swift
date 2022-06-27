//
//  CGColor+hex.swift
//

import CoreGraphics
import Foundation

extension CGColor {
    func fromHex(_ hex: String) -> Self? {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xFF00_0000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00FF_0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000_FF00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x0000_00FF) / 255

                    return type(of: self).init(srgbRed: r, green: g, blue: b, alpha: a)
                }
            }
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0x00FF_0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x0000_FF00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000_00FF) / 255

                    return type(of: self).init(srgbRed: r, green: g, blue: b, alpha: 1.0)
                }
            }
        }
        return nil
    }

    static func fromHexSequence(_ hex: String) -> [CGColor] {
        var colors: [CGColor] = []

        var start = hex.startIndex
        while start <= hex.endIndex {
            if let end = hex.index(start, offsetBy: 5, limitedBy: hex.endIndex) {
                let slice = String(hex[start ... end])
                let scanner = Scanner(string: slice)
                var hexNumber: UInt64 = 0
                if scanner.scanHexInt64(&hexNumber) {
                    let r, g, b: CGFloat
                    r = CGFloat((hexNumber & 0x00FF_0000) >> 16) / 255
                    // print(CGFloat((hexNumber & 0x00ff0000) >> 16))
                    g = CGFloat((hexNumber & 0x0000_FF00) >> 8) / 255
                    // print(CGFloat((hexNumber & 0x0000ff00) >> 8))
                    b = CGFloat(hexNumber & 0x0000_00FF) / 255
                    // print(CGFloat(hexNumber & 0x000000ff))
                    colors.append(CGColor(srgbRed: r, green: g, blue: b, alpha: 1.0))
                }
                start = hex.index(start, offsetBy: 6)
            } else {
                // The index increment to get the next slice wasn't able to get an additional
                // 6 characters, so quit and be done with what we've captured.
                break
            }
        }
        return colors
    }

    // MARK: - Computed Properties

    var toHex: String? {
        toHex()
    }

    // MARK: - From CGColor to String

    func toHex(alpha: Bool = false) -> String? {
        guard let components = components, components.count >= 3 else {
            return nil
        }

        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}
