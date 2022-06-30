//
//  CGImage+pngData.swift
//  
//
//  Created by Joseph Heck on 6/30/22.
//

//import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

@available(macOS 11.0, *)
public extension CGImage {
    func pngData() -> Data? {
        let cfdata: CFMutableData = CFDataCreateMutable(nil, 0)
        if let destination = CGImageDestinationCreateWithData(cfdata, UTType.png as! CFString, 1, nil) {
            CGImageDestinationAddImage(destination, self, nil)
            if CGImageDestinationFinalize(destination) {
                return cfdata as Data
            }
        }
        return nil
    }
}
