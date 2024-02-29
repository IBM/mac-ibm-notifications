//
//  Icon.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 22/11/22.
//  Copyright © 2021 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI

/// Icon is a struct that defines a view with an image and a give image size.
struct Icon: View {
    
    // MARK: - Variables
    
    var icon: NSImage?
    var iconSize: CGSize

    // MARK: - Views
    
    var body: some View {
        if let image = icon {
            Image(nsImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize.width, height: iconSize.height)
        } else {
            Image("default_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize.width, height: iconSize.height)
        }
    }
}

struct PopupIcon_Previews: PreviewProvider {
    static var previews: some View {
        Icon(iconSize: CGSize(width: 60, height: 60))
    }
}
