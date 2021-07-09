//
//  ImageAccessoryView.swift
//  IBM Notifier
//
//  Created by Simone Martorelli on 9/28/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

/// This view show an image loaded from a file or an URL.
final class ImageAccessoryView: NSView {

    // MARK: - Private variables

    private var imageView: NSImageView!
    private var containerWidth: CGFloat {
        return self.superview?.bounds.width ?? 0
    }
    private var imageViewWidthAnchor: NSLayoutConstraint!
    private var imageViewHeightAnchor: NSLayoutConstraint!
    private let needsFullWidth: Bool

    private let logger = Logger.shared

    // MARK: - Initializers

    init(with media: NAMedia, needsFullWidth: Bool = true) {
        self.needsFullWidth = needsFullWidth
        super.init(frame: .zero)
        imageView = NSImageView()
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        imageView.image = media.image!
    }

    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: - Instance methods

    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        self.adjustViewSize()
    }

    // MARK: - Private methods

    /// Adjust the view size based on the superview width and on the image height.
    private func adjustViewSize() {
        guard needsFullWidth else { return }
        let imageSize = imageView.intrinsicContentSize
        guard containerWidth != 0 && imageSize != .zero else { return }
        let scaleFactor = containerWidth/imageSize.width

        imageViewWidthAnchor?.isActive = false
        imageViewHeightAnchor?.isActive = false
        imageViewWidthAnchor = imageView.widthAnchor.constraint(equalToConstant: containerWidth)
        imageViewHeightAnchor = imageView.heightAnchor.constraint(equalToConstant: imageSize.height*scaleFactor)
        imageViewWidthAnchor.isActive = true
        imageViewHeightAnchor.isActive = true
    }
}
