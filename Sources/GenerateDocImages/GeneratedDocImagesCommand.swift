import ArgumentParser
import SwiftUI
import SwiftVizScale
import SystemPackage
import VisualTests

#if os(macOS)
    @main
    @available(macOS 12.0, *)
    struct GeneratedDocImagesCommand: ParsableCommand {
        @MainActor
        func run() throws {
            for interpolator in ColorInterpolator.allCases {
                print("Says its a: \(interpolator)")

                let view = ColorInterpolatorView(steps: 128, interpolator: interpolator)
                    .frame(width: 400, height: 40)
                let image = view.snapshot()!.cgImage(forProposedRect: nil, context: nil, hints: nil)!
                let newRepresentation = NSBitmapImageRep(cgImage: image)

                let path = FilePath("\(interpolator).png")
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
#endif
