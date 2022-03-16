//
//  NAMedia.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 01/03/2021.
//  Copyright © 2021 IBM Inc. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//
//  swiftlint:disable function_body_length

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
    /// Boolean value that define if the video player must auto play. Default: false
    private(set) var autoplay: Bool = false
    /// Auto play delay for video resources. Default: 1 second
    private(set) var autoplayDelay: Int = 1

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
                NALogger.shared.log("Unable to load image from %{public}@", [string])
                return nil
            }
        case .video:
            func setupPlayer(with resource: String) -> Bool {
                if FileManager.default.fileExists(atPath: resource) {
                    let url = URL(fileURLWithPath: resource)
                    let plr = AVPlayer(url: url)
                    if let res = resolutionForVideo(at: url) {
                        self.videoResolution = res
                    } else {
                        NALogger.shared.log("Unable to load video resolution from resource %{public}@", [resource])
                        self.videoResolution = CGSize(width: 1280, height: 1080)
                    }
                    self.player = plr
                    return true
                } else if resource.isValidURL, let url = URL(string: resource) {
                    let plr = AVPlayer(url: url)
                    if let res = resolutionForVideo(at: url) {
                        self.videoResolution = res
                    } else {
                        NALogger.shared.log("Unable to load video resolution from resource %{public}@", [resource])
                        self.videoResolution = CGSize(width: 1280, height: 1080)
                    }
                    self.player = plr
                    return true
                } else {
                    NALogger.shared.log("Unable to load video from resource %{public}@", [resource])
                    return false
                }
            }
            guard !setupPlayer(with: string) else {
                NALogger.shared.deprecationLog(since: AppVersion(major: 3, release: 0, fix: 0), deprecatedArgument: "video accessory view payload without payload keys ex. '/url'")
                return
            }
            var splittedStrings = string.split(separator: "/")
            guard splittedStrings.count > 0 else {
                NALogger.shared.log("Unable to load video resolution from payload %{public}@", [string])
                return nil
            }
            splittedStrings.reverse()
            for index in 0..<splittedStrings.count {
                guard let argument = splittedStrings[index].split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true).first?.lowercased() else { continue }
                let value = splittedStrings[index].split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true).last?.trimmingCharacters(in: CharacterSet.whitespaces)
                switch argument {
                case "url":
                    guard let value = value else {
                        NALogger.shared.log("Unable to load video from payload %{public}@", [string])
                        return nil
                    }
                    var checkedValue = value
                    if value.contains("https:/") {
                        checkedValue = value.replacingOccurrences(of: "https:/", with: "https://")
                    } else if value.contains("http:/") {
                        checkedValue = value.replacingOccurrences(of: "http:/", with: "http://")
                    }
                    guard setupPlayer(with: checkedValue) else {
                        return nil
                    }
                case "autoplay":
                    self.autoplay = true
                case "delay":
                    guard let value = value, let delay = Int(value) else {
                        continue
                    }
                    self.autoplayDelay = delay
                default:
                    if index < splittedStrings.count-1 {
                        splittedStrings[index+1] = Substring(splittedStrings[index+1].appending("/\(splittedStrings[index])"))
                    }
                }
            }
            guard player != nil else {
                NALogger.shared.log("Unable to load video from payload %{public}@", [string])
                return nil
            }
        }
    }

    convenience init?(type: String, from string: String) {
        if let mediaType = MediaType(rawValue: type) {
            self.init(type: mediaType, from: string)
        } else {
            NALogger.shared.log("Unable to identify media type of kind: %{public}@", [string])
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
