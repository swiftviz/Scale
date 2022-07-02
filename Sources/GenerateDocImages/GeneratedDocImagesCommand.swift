import ArgumentParser
import SwiftUI
import SwiftVizScale
import SystemPackage
import VisualTests

#if os(macOS) && swift(>=5.7)
    @main
    @available(macOS 12.0, *)
    struct GeneratedDocImagesCommand: ParsableCommand {
        @MainActor
        func run() throws {
            let schemes: [ColorInterpolator: String] = [
                .BrBG: "BrBG",
                .PrGN: "PrGN",
                .PiYG: "PiYG",
                .PuOR: "PuOR",
                .RdBu: "RdBu",
                .RdGy: "RdGy",
                .RdYlBu: "RdYlBu",
                .RdYlGn: "RdYlGn",
                .Spectral: "Spectral",
                .BuGn: "BuGn",
                .BuPu: "BuPu",
                .GnBu: "GnBu",
                .OrRd: "OrRd",
                .PuBu: "PuBu",
                .PuBuGn: "PuBuGn",
                .PuRd: "PuRd",
                .RdPu: "RdPu",
                .YlGn: "YlGn",
                .YlGnBu: "YlGnBu",
                .YlOrBr: "YlOrBr",
                .YlOrRd: "YlOrRd",
                .Viridis: "Viridis",
                .Magma: "Magma",
                .Inferno: "Inferno",
                .Plasma: "Plasma",
                .Oranges: "Oranges",
                .Purples: "Purples",
                .Grays: "Grays",
                .Blues: "Blues",
                .Greens: "Greens",
                .Reds: "Reds",
            ]

            for (interpolator, name) in schemes {
                print("Creating color swatch for \(name)")

                let view = ColorInterpolatorView(steps: 128, interpolator: interpolator)
                    .frame(width: 400, height: 40)
                let image = view.snapshot()!.cgImage(forProposedRect: nil, context: nil, hints: nil)!
                let newRepresentation = NSBitmapImageRep(cgImage: image)

                let path = FilePath("\(name).png")
                let fd = try FileDescriptor.open(path, .writeOnly,
                                                 options: [.append, .create],
                                                 permissions: .ownerReadWrite)
                try fd.closeAfter {
                    if let pngData = newRepresentation.representation(using: .png, properties: [:]) {
                        _ = try fd.writeAll(pngData)
                    }
                }
            }
            // damnit, I can't use this until macOS 13
//        if #available(macOS 13.0, *) {
//            let renderer = ImageRenderer(content: ColorInterpolatorView(steps: 128, interpolator: .Viridis))
//        } else {
        }
    }
#else
    @main
    struct GeneratedDocImagesCommand: ParsableCommand {
        func run() throws {
            print("NOT IMPLEMENTED for Swift < 5.7")
        }
    }
#endif
