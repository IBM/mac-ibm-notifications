//
//  SlideShowView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 19/07/2023.
//  © Copyright IBM Corp. 2021, 2024
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI
import Combine

/// SlideShowView is a struct that define a view able to display multiple images as a slideshow.
struct SlideShowView: View {

    // MARK: - Support Enums
    
    enum SlideShowCodingKeys: String, AVCIterable {
        case images
        case autoplay
        case delay
    }
    
    // MARK: - Variables
    
    /// Boolean value to enable or disable the automatic images scrolling.
    var autoplay: Bool
    /// The array of images to be shown.
    var images: [NAMedia]
    /// Delay for the autoplay in seconds.
    var delay: Int
    /// The lower aspect ration between the loaded media.
    var minAspectRatio: Double
    /// The autoplay timer.
    var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
    
    // MARK: - State variables
    
    /// Current selection.
    @State private var selection: Int = 0
    
    // MARK: - Initializers
    
    init(_ payload: String) throws {
        let decoder = ACVDecoder(codingKeys: SlideShowCodingKeys.self)
        let imagesURLRaw = try decoder.decode(key: SlideShowCodingKeys.images, ofType: String.self, from: payload)
        autoplay = try decoder.decode(key: SlideShowCodingKeys.autoplay, ofType: Bool.self, from: payload)
        delay = try decoder.decode(key: SlideShowCodingKeys.delay, ofType: Int.self, from: payload)
        let imagesURL = imagesURLRaw.lines
        images = []
        minAspectRatio = 1
        for imageURL in imagesURL {
            if let media = NAMedia(type: .image, from: imageURL) {
                images.append(media)
                minAspectRatio = min(minAspectRatio, max(media.aspectRatioForMedia(), 1))
            }
        }
        guard images.count != 0 else {
            throw NAError.dataFormat(type: .invalidSlideShowPayload)
        }
        if autoplay {
            timer = Timer.publish(every: Double(max(delay, 3)), on: .main, in: .default).autoconnect()
        }
    }
    
    // MARK: - Views
    
    var body: some View {
        ZStack {
            if let image = images[selection].image {
                if AppComponent.current == .popup {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(images[selection].aspectRatioForMedia(), contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityIdentifier("accessory_view_slideshow_image")
                } else {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(images[selection].aspectRatioForMedia(), contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        .accessibilityIdentifier("accessory_view_slideshow_image")
                }
            }
            HStack(alignment: .center) {
                if selection != 0 {
                    Button {
                        selection -= 1
                        invalidateTimer()
                    } label: {
                        Image(systemName: "chevron.left.square.fill")
                            .resizable()
                    }
                    .buttonStyle(.borderless)
                    .disabled(selection == 0)
                    .frame(width: 30, height: 30)
                    .shadow(color: Utils.currentInterfaceStyle == .light ? .white : .black, radius: 16)
                    .padding()
                    .accessibilityIdentifier("accessory_view_slideshow_backward_button")
                    .accessibilityLabel("accessory_view_slideshow_backward_button".localized)
                    .accessibilityHint("accessory_view_slideshow_backward_button_hint".localized)
                }
                Spacer()
                if selection != images.count-1 {
                    Button {
                        selection += 1
                        invalidateTimer()
                    } label: {
                        Image(systemName: "chevron.right.square.fill")
                            .resizable()
                    }
                    .buttonStyle(.borderless)
                    .disabled(selection == images.count-1)
                    .frame(width: 30, height: 30)
                    .shadow(color: Utils.currentInterfaceStyle == .light ? .white : .black, radius: 16)
                    .padding()
                    .accessibilityIdentifier("accessory_view_slideshow_forward_button")
                    .accessibilityLabel("accessory_view_slideshow_forward_button".localized)
                    .accessibilityHint("accessory_view_slideshow_forward_button_hint".localized)
                }
            }
            if images.count > 1 {
                VStack(alignment: .center) {
                    Spacer()
                    HStack(alignment: .center) {
                        ForEach(0..<images.count, id: \.self) { index in
                            Button {
                                selection = index
                                invalidateTimer()
                            } label: {
                                Circle()
                                    .frame(width: 8, height: 8)
                                    .foregroundColor(index == selection ? .white : .gray)
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                    .padding()
                    .shadow(color: Utils.currentInterfaceStyle == .light ? .white : .black, radius: 12)
                }
                .accessibilityHidden(true)
            }
        }
        .animation(.default, value: selection)
        // This is needed since the timer might be nil.
        if timer != nil {
            EmptyView()
                .onReceive(timer!) { _ in
                    if selection < images.count-1 {
                        selection += 1
                    } else {
                        selection = 0
                    }
                }
        }
    }
    
    // MARK: - Methods
    
    /// Invalidate the timer for the autoplay.
    func invalidateTimer() {
        if autoplay {
            timer?.upstream.connect().cancel()
        }
    }
}

struct SlideShowView_Previews: PreviewProvider {
    static var previews: some View {
        try? SlideShowView("/images https://cdn.pixabay.com/photo/2015/04/19/08/32/rose-729509_960_720.jpg\nhttps://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg\nhttps://cdn.pixabay.com/photo/2015/04/19/08/32/rose-729509_960_720.jpg")
            .previewLayout(.fixed(width: 400, height: 300))
    }
}
