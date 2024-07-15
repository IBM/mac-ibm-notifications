//
//  PlayerView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 10/05/2023.
//  © Copyright IBM Corp. 2021, 2024
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI

struct PlayerView: NSViewRepresentable {

    var media: NAMedia

    func makeNSView(context: NSViewRepresentableContext<PlayerView>) -> VideoAccessoryView {
        let accessoryView = VideoAccessoryView(with: media)

        return accessoryView
    }

    func updateNSView(_ nsView: VideoAccessoryView, context: NSViewRepresentableContext<PlayerView>) {}
}
