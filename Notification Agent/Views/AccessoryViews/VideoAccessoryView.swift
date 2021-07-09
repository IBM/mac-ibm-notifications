//
//  VideoAccessoryView.swift
//  IBM Notifier
//
//  Created by Simone Martorelli on 9/30/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa
import AVKit

/// This view show a video loaded from a file or an URL.
final class VideoAccessoryView: NSView {

    // MARK: - Private variables

    private var playerView: AVPlayerView!
    private var videoResolution: CGSize!
    private var containerWidth: CGFloat {
        return self.superview?.bounds.width ?? 0
    }
    private var playerViewWidthAnchor: NSLayoutConstraint!
    private var playerViewHeightAnchor: NSLayoutConstraint!
    private var playerAspectRatio: NSLayoutConstraint!
    private let needsFullWidth: Bool
    private let preferredSize: CGSize
    
    private let logger = Logger.shared

    // MARK: - Initializers

    init(with media: NAMedia, preferredSize: CGSize = .zero, needsFullWidth: Bool = true) {
        self.needsFullWidth = needsFullWidth
        self.preferredSize = preferredSize
        super.init(frame: .zero)
        playerView = AVPlayerView()
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.videoGravity = .resizeAspect
        self.addSubview(playerView)
        playerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        playerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        playerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        playerView.player = media.player!
        videoResolution = media.videoResolution ?? .zero
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

    /// Adjust the view size based on the superview width and on the video height.
    private func adjustViewSize() {
        guard needsFullWidth else {
            if preferredSize != .zero {
                playerView.heightAnchor.constraint(equalToConstant: preferredSize.height).isActive = true
            }
            playerView.widthAnchor.constraint(equalTo: playerView.heightAnchor, multiplier: videoResolution.width/videoResolution.height).isActive = true
            return
        }
        guard containerWidth > 0 else { return }
        var videoHeight: CGFloat = 0
        if let res = videoResolution {
            videoHeight = containerWidth*res.height/res.width
        } else {
            videoHeight = containerWidth/16*9
        }
        playerViewWidthAnchor?.isActive = false
        playerViewHeightAnchor?.isActive = false
        playerViewWidthAnchor = playerView.widthAnchor.constraint(equalToConstant: containerWidth)
        playerViewHeightAnchor = playerView.heightAnchor.constraint(equalToConstant: videoHeight)
        playerViewWidthAnchor?.isActive = true
        playerViewHeightAnchor?.isActive = true
    }
}
