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
        let schemes: [String: any ColorInterpolator] = [
            "BrBG": ColorScheme.Diverging.BrBG,
            "PrGN": ColorScheme.Diverging.PrGN,
            "PiYG": ColorScheme.Diverging.PiYG,
            "PuOr": ColorScheme.Diverging.PuOr,
            "RdBu": ColorScheme.Diverging.RdBu,
            "RdGy": ColorScheme.Diverging.RdGy,
            "RdYlBu": ColorScheme.Diverging.RdYlBu,
            "RdYlGn": ColorScheme.Diverging.RdYlGn,
            "Spectral": ColorScheme.Diverging.Spectral,
            "BuGn": ColorScheme.SequentialMultiHue.BuGn,
            "BuPu": ColorScheme.SequentialMultiHue.BuPu,
            "GnBu": ColorScheme.SequentialMultiHue.GnBu,
            "OrRd": ColorScheme.SequentialMultiHue.OrRd,
            "PuBu": ColorScheme.SequentialMultiHue.PuBu,
            "PuBuGn": ColorScheme.SequentialMultiHue.PuBuGn,
            "PuRd": ColorScheme.SequentialMultiHue.PuRd,
            "RdPu": ColorScheme.SequentialMultiHue.RdPu,
            "YlGn": ColorScheme.SequentialMultiHue.YlGn,
            "YlGnBu": ColorScheme.SequentialMultiHue.YlGnBu,
            "YlOrBr": ColorScheme.SequentialMultiHue.YlOrBr,
            "YlOrRd": ColorScheme.SequentialMultiHue.YlOrRd,
            "Viridis": ColorScheme.SequentialMultiHue.Viridis,
            "Magma": ColorScheme.SequentialMultiHue.Magma,
            "Inferno": ColorScheme.SequentialMultiHue.Inferno,
            "Plasma": ColorScheme.SequentialMultiHue.Plasma,
            "Cividis": ColorScheme.SequentialMultiHue.Cividis,
            "Turbo": ColorScheme.SequentialMultiHue.Turbo,
            "Oranges": ColorScheme.SequentialSingleHue.Oranges,
            "Purples": ColorScheme.SequentialSingleHue.Purples,
            "Grays": ColorScheme.SequentialSingleHue.Grays,
            "Blues": ColorScheme.SequentialSingleHue.Blues,
            "Greens": ColorScheme.SequentialSingleHue.Greens,
            "Reds": ColorScheme.SequentialSingleHue.Reds,
            "Sinebow": ColorScheme.Cyclical.Sinebow,
        ]

        for (name, interpolator) in schemes {
            print("Creating color swatch for \(name)")

            let view = ColorInterpolatorView(steps: 128, interpolator: interpolator)
                .frame(width: 400, height: 40)
            let image = view.snapshot()!.cgImage(forProposedRect: nil, context: nil, hints: nil)!
            let newRepresentation = NSBitmapImageRep(cgImage: image)

            let path = FilePath("\(name)@2x.png")
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
