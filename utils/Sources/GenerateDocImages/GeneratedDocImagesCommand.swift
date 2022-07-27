import ArgumentParser
import SwiftUI
import SwiftVizScale
import SystemPackage
import VisualTests

@main
@available(macOS 12.0, *)
struct GeneratedDocImagesCommand: ParsableCommand {
    @MainActor
    func run() throws {
        let schemes: [IndexedColorInterpolator: String] = [
            ColorScheme.Diverging.BrBG: "BrBG",
            ColorScheme.Diverging.PrGN: "PrGN",
            ColorScheme.Diverging.PiYG: "PiYG",
            ColorScheme.Diverging.PuOR: "PuOR",
            ColorScheme.Diverging.RdBu: "RdBu",
            ColorScheme.Diverging.RdGy: "RdGy",
            ColorScheme.Diverging.RdYlBu: "RdYlBu",
            ColorScheme.Diverging.RdYlGn: "RdYlGn",
            ColorScheme.Diverging.Spectral: "Spectral",
            ColorScheme.SequentialMultiHue.BuGn: "BuGn",
            ColorScheme.SequentialMultiHue.BuPu: "BuPu",
            ColorScheme.SequentialMultiHue.GnBu: "GnBu",
            ColorScheme.SequentialMultiHue.OrRd: "OrRd",
            ColorScheme.SequentialMultiHue.PuBu: "PuBu",
            ColorScheme.SequentialMultiHue.PuBuGn: "PuBuGn",
            ColorScheme.SequentialMultiHue.PuRd: "PuRd",
            ColorScheme.SequentialMultiHue.RdPu: "RdPu",
            ColorScheme.SequentialMultiHue.YlGn: "YlGn",
            ColorScheme.SequentialMultiHue.YlGnBu: "YlGnBu",
            ColorScheme.SequentialMultiHue.YlOrBr: "YlOrBr",
            ColorScheme.SequentialMultiHue.YlOrRd: "YlOrRd",
            ColorScheme.SequentialMultiHue.Viridis: "Viridis",
            ColorScheme.SequentialMultiHue.Magma: "Magma",
            ColorScheme.SequentialMultiHue.Inferno: "Inferno",
            ColorScheme.SequentialMultiHue.Plasma: "Plasma",
            ColorScheme.SequentialSingleHue.Oranges: "Oranges",
            ColorScheme.SequentialSingleHue.Purples: "Purples",
            ColorScheme.SequentialSingleHue.Grays: "Grays",
            ColorScheme.SequentialSingleHue.Blues: "Blues",
            ColorScheme.SequentialSingleHue.Greens: "Greens",
            ColorScheme.SequentialSingleHue.Reds: "Reds",
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
    }
}
