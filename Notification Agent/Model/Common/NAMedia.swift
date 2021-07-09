//
//  NAMedia.swift
//  IBM Notifier
//
//  Created by Simone Martorelli on 01/03/2021.
//  Copyright © 2021 IBM. All rights reserved.
//

import Cocoa
import AVFoundation

/// This class describe a media object used inside the agent.
public final class NAMedia {

    // MARK: - Enums

    /// The type of the available media:
    enum MediaType: String, Codable {
        case image
        case video
    }

    // MARK: - Variables

    /// The type of the media.
    var mediaType: MediaType
    /// The payload used to represent or retrieve the media.
    var mediaPayload: String
    /// Preloaded image
    private(set) var image: NSImage?
    /// Preloaded video player
    private(set) var player: AVPlayer?
    /// Preloaded video resolution
    private(set) var videoResolution: CGSize?

    // MARK: - Initializers

    init?(type: MediaType, from string: String) {
        self.mediaType = type
        self.mediaPayload = string
        switch mediaType {
        case .image:
            if FileManager.default.fileExists(atPath: string),
               let data = try? Data(contentsOf: URL(fileURLWithPath: string)) {
                let image = NSImage(data: data)
                self.image = image
            } else if string.isValidURL,
                      let url = URL(string: string),
                      let data = try? Data(contentsOf: url) {
                let image = NSImage(data: data)
                self.image = image
            } else if let imageData = Data(base64Encoded: string, options: .ignoreUnknownCharacters),
                      let image = NSImage(data: imageData) {
                self.image = image
            } else {
                Logger.shared.log(.error, "Unable to load image from %@", string)
                return nil
            }
        case .video:
            if FileManager.default.fileExists(atPath: string) {
                let url = URL(fileURLWithPath: string)
                let plr = AVPlayer(url: url)
                if let res = resolutionForVideo(at: url) {
                    self.videoResolution = res
                } else {
                    Logger.shared.log(.error, "Unable to load video resolution from %@", string)
                    self.videoResolution = .zero
                }
                self.player = plr
            } else if string.isValidURL, let url = URL(string: string) {
                let plr = AVPlayer(url: url)
                if let res = resolutionForVideo(at: url) {
                    self.videoResolution = res
                } else {
                    Logger.shared.log(.error, "Unable to load video resolution from %@", string)
                    self.videoResolution = .zero
                }
                self.player = plr
            } else {
                Logger.shared.log(.error, "Unable to load video from %@", string)
                return nil
            }
        }
    }

    convenience init?(type: String, from string: String) {
        if let mediaType = MediaType(rawValue: type) {
            self.init(type: mediaType, from: string)
        } else {
            Logger.shared.log(.error, "Unable to identify media type of kind: %@", string)
            return nil
        }
    }

    /// Get the resolution of the video.
    /// - Parameter url: url of the video.
    /// - Returns: the resolution of the video.
    private func resolutionForVideo(at url: URL) -> CGSize? {
        guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
}
