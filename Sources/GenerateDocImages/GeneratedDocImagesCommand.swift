import ArgumentParser
import SwiftUI
import SystemPackage
import SwiftVizScale
import VisualTests

#if os(macOS)
    @main
    @available(macOS 12.0, *)
    struct GeneratedDocImagesCommand: ParsableCommand {
        @Argument(help: "The phrase to repeat.")
        var phrase: String

        @MainActor
        func run() throws {
            print("Hi, \(phrase)")
            
            for interpolator in ColorInterpolator.allCases {
                print("Says its a: \(interpolator)")
            }
            // damnit, I can't use this until macOS 13
//        if #available(macOS 13.0, *) {
//            let renderer = ImageRenderer(content: ColorInterpolatorView(steps: 128, interpolator: .Viridis))
//        } else {
            let view = ColorInterpolatorView(steps: 128, interpolator: .Viridis)
                .frame(width: 400, height: 40)
            let image = view.snapshot()!.cgImage(forProposedRect: nil, context: nil, hints: nil)!
            let newRepresentation = NSBitmapImageRep(cgImage: image)

            let path: FilePath = "fiddlesticks.png"
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
#endif
