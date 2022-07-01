//
//  SwiftUI+snapshot.swift
//

import SwiftUI

extension View {
    #if os(macOS)
        func snapshot() -> NSImage? {
            let controller = NSHostingController(rootView: self)
            let targetSize = controller.view.intrinsicContentSize
            let contentRect = NSRect(origin: .zero, size: targetSize)

            let window = NSWindow(
                contentRect: contentRect,
                styleMask: [.borderless],
                backing: .buffered,
                defer: false
            )
            window.contentView = controller.view

            guard
                let bitmapRep = controller.view.bitmapImageRepForCachingDisplay(in: contentRect)
            else { return nil }

            controller.view.cacheDisplay(in: contentRect, to: bitmapRep)
            let image = NSImage(size: bitmapRep.size)
            image.addRepresentation(bitmapRep)
            return image
        }
    #endif

    #if os(iOS)
        func snapshot() -> UIImage {
            let controller = UIHostingController(rootView: self)
            let view = controller.view

            let targetSize = controller.view.intrinsicContentSize
            view?.bounds = CGRect(origin: .zero, size: targetSize)
            view?.backgroundColor = .clear

            let renderer = UIGraphicsImageRenderer(size: targetSize)

            return renderer.image { _ in
                view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
            }
        }
    #endif
}
