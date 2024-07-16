//
//  MediaView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 27/01/23.
//  © Copyright IBM Corp. 2021, 2024
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI
import AVKit
import AppKit

/// MediaView is a struct that defines a view to display media such as image or video.
struct MediaView: View {
 
    // MARK: - Variables
    
    /// Defines the type of media view to be displayed, either image or video.
    var type: NotificationAccessoryElement.ViewType
    /// An object that holds the actual media content.
    var media: NAMedia
    /// The desired content mode for the media.
    var contentMode: ContentMode
    /// The width of the container view.
    var containerWidth: CGFloat
    
    // MARK: - Binded Variables
    
    /// A binding to a String that is used to keep track of the accessory view output.
    @Binding var output: String
    /// A binding to a SwiftUIButtonState that is used to keep track of the main button state.
    @Binding var mainButtonState: SwiftUIButtonState
    /// A binding to a SwiftUIButtonState that is used to keep track of the secondary button state.
    @Binding var secondaryButtonState: SwiftUIButtonState
    
    // MARK: - Intializers
    
    init(_ payload: String,
         output: Binding<String>,
         mainButtonState: Binding<SwiftUIButtonState>,
         secondaryButtonState: Binding<SwiftUIButtonState>,
         legacyType: NotificationAccessoryElement.ViewType,
         contentMode: ContentMode = .fill,
         containerWidth: CGFloat) throws {
        
        /// Initialize the binded variables.
        _output = output
        _mainButtonState = mainButtonState
        _secondaryButtonState = secondaryButtonState
        self.contentMode = contentMode
        self.containerWidth = containerWidth

        /// Set the media view type.
        type = legacyType
        
        /// Determine the type of media to be displayed and create the NAMedia instance accordingly.
        switch legacyType {
        case .image:
            guard let media = NAMedia(type: .image, from: payload) else {
                throw NAError.efclController(type: .invalidAccessoryViewPayload)
            }
            self.media = media
        case .video:
            guard let media = NAMedia(type: .video, from: payload) else {
                throw NAError.efclController(type: .invalidAccessoryViewPayload)
            }
            self.media = media
        default:
            throw NAError.efclController(type: .invalidAccessoryViewPayload)
        }
    }
    
    // MARK: - Views
    
    var body: some View {
        switch type {
        case .image:
            /// If the media is an image, display the image using an Image view.
            if let image = media.image {
                if media.isGIF {
                    ImageViewRepresentable(image: image,
                                           width: containerWidth,
                                           aspectRatio: aspectRatioForMedia(media),
                                           contentMode: contentMode)
                } else {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(aspectRatioForMedia(media), contentMode: contentMode)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                EmptyView()
            }
        case .video:
            /// If the media is a video, display the video using a PlayerView.
            if media.player != nil {
                PlayerView(media: media)
                    .aspectRatio(aspectRatioForMedia(media), contentMode: contentMode)
            } else {
                EmptyView()
            }
        default:
            EmptyView()
        }
    }
    
    // MARK: - Private Methods
    
    /// Returns the resolution size of the media
    private func resolutionForMedia(_ media: NAMedia) -> CGSize {
        switch media.mediaType {
        case .image:
            guard let image = media.image else { return .zero }
            return image.size
        case .video:
            guard let size = media.videoResolution else { return .zero }
            return size
        }
    }
    
    /// Returns the aspect ratio of the media
    private func aspectRatioForMedia(_ media: NAMedia) -> Double {
        let resolution = resolutionForMedia(media)
        return resolution != .zero ? resolution.width/resolution.height : 16/9
    }
}

struct MediaView_Previews: PreviewProvider {
    static var previews: some View {
        try? MediaView("/Users/simonemartorelli.max/Desktop/test.png", output: Binding(get: {
            return ""
        }, set: { _, _ in
            
        }), mainButtonState: Binding(get: {
            return .enabled
        }, set: { _, _ in
            
        }), secondaryButtonState: Binding(get: {
            return .enabled
        }, set: { _, _ in
            
        }), legacyType: .image, containerWidth: 420)
    }
}
