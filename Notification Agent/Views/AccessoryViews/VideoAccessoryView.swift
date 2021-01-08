//
//  VideoAccessoryView.swift
//  Notification Agent
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

    private let logger = Logger.shared

    // MARK: - Initializers

    init() {
        super.init(frame: .zero)
        playerView = AVPlayerView()
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.videoGravity = .resizeAspect
        self.addSubview(playerView)
        playerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        playerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        playerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: - Instance methods

    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        self.adjustViewSize()
    }

    // MARK: - Public methods

    /// Load the video from the given file path or URL string.
    /// - Parameter string: a file path or an URL string.
    func loadVideo(from string: String) {
        if FileManager.default.fileExists(atPath: string) {
            let url = URL(fileURLWithPath: string)
            let player = AVPlayer(url: url)
            playerView.player = player
            videoResolution = resolutionForVideo(at: url)
        } else if let url = URL(string: string) {
            let player = AVPlayer(url: url)
            playerView.player = player
            videoResolution = resolutionForVideo(at: url)
        } else {
            logger.log(.error, "Unable to load video from %@", string)
            EFCLController.shared.applicationExit(withReason: .unableToLoadResources)
        }
        adjustViewSize()
    }

    // MARK: - Private methods

    /// Adjust the view size based on the superview width and on the video height.
    private func adjustViewSize() {
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

    private func resolutionForVideo(at url: URL) -> CGSize? {
        guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
}
