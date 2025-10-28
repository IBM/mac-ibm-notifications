//
//  ImageViewRepresentable.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 06/12/2023.
//  © Copyright IBM Corp. 2021, 2025
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI

struct ImageViewRepresentable: NSViewRepresentable {
    var image: NSImage
    var width: CGFloat
    var aspectRatio: Double
    var contentMode: ContentMode

    func makeNSView(context: NSViewRepresentableContext<ImageViewRepresentable>) -> NSImageView {
        let imageView = NSImageView()
        imageView.image = image
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.translatesAutoresizingMaskIntoConstraints = false
        switch contentMode {
        case .fit:
            imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
            imageView.widthAnchor.constraint(lessThanOrEqualToConstant: width).isActive = true
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: width/aspectRatio).isActive = true
        case .fill:
            imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            imageView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
            imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: width/aspectRatio).isActive = true
        }
        return imageView
    }

    func updateNSView(_ nsView: NSImageView, context: NSViewRepresentableContext<ImageViewRepresentable>) {
        nsView.image = image
    }
}
