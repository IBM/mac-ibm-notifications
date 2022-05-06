//
//  ImageAccessoryView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 9/28/20.
//  Copyright © 2021 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa

/// This view show an image loaded from a file or an URL.
final class ImageAccessoryView: AccessoryView {

    // MARK: - Private variables

    private var imageView: NSImageView!
    private var _containerWidth: CGFloat?
    private var containerWidth: CGFloat {
        return _containerWidth ?? (self.superview?.bounds.width ?? 0)
    }
    private var imageViewWidthAnchor: NSLayoutConstraint!
    private var imageViewHeightAnchor: NSLayoutConstraint!
    private let needsFullWidth: Bool
    private let maxImageHeight: CGFloat = 300
    private let preferredSize: CGSize

    // MARK: - Initializers

    init(with media: NAMedia,
         preferredSize: CGSize = .zero,
         needsFullWidth: Bool = true,
         containerWidth: CGFloat? = nil) {
        self.needsFullWidth = needsFullWidth
        self.preferredSize = preferredSize
        self._containerWidth = containerWidth
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
    
    override func adjustViewSize() {
        guard needsFullWidth else {
            if preferredSize != .zero {
                imageView.heightAnchor.constraint(equalToConstant: preferredSize.height).isActive = true
                imageView.widthAnchor.constraint(equalToConstant: preferredSize.width).isActive = true
            }
            return
        }
        let imageSize = imageView.intrinsicContentSize
        guard containerWidth != 0 && imageSize != .zero else { return }
        imageViewWidthAnchor?.isActive = false
        imageViewWidthAnchor = imageView.widthAnchor.constraint(equalToConstant: containerWidth)
        imageViewWidthAnchor.isActive = true
        guard imageSize.width > imageSize.height else { return }
        let scaleFactor = containerWidth/imageSize.width
        imageViewHeightAnchor?.isActive = false
        imageViewHeightAnchor = imageView.heightAnchor.constraint(equalToConstant: min(imageSize.height*scaleFactor, maxImageHeight))
        imageViewHeightAnchor.isActive = true
    }
    
    override func configureAccessibilityElements() {
        imageView.setAccessibilityLabel("accessory_view_accessibility_image_imageview".localized)
    }
}
