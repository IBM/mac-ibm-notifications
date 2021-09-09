//
//  VideoAccessoryView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 9/30/20.
//  Copyright © 2021 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//

import Cocoa
import AVKit

/// This view show a video loaded from a file or an URL.
final class VideoAccessoryView: AccessoryView {

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
    private let media: NAMedia

    // MARK: - Initializers

    init(with media: NAMedia, preferredSize: CGSize = .zero, needsFullWidth: Bool = true) {
        self.needsFullWidth = needsFullWidth
        self.preferredSize = preferredSize
        self.media = media
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
        playerView.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: CMTimeScale(1)), queue: .main, using: { _ in
            self.delegate?.accessoryViewStatusDidChange(self)
        })
        videoResolution = media.videoResolution ?? .zero
    }

    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: - Instance methods

    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        adjustViewSize()
        configureAccessibilityElements()
        if media.autoplay {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(media.autoplayDelay)) {
                self.playerView.player?.play()
            }
        }
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
    
    private func configureAccessibilityElements() {
        playerView.setAccessibilityLabel("accessory_view_accessibility_video_playerView".localized)
    }
}
