//
//  ViewSpec.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 13/10/2023.
//  Copyright © 2023 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI

/// ViewSpec is an observable object used as environment object that stores common useful information about the main view.
class ViewSpec: ObservableObject {
    
    // MARK: - Published Variables
    
    @Published var mainViewWidth: CGFloat
    @Published var contentMode: ContentMode
    @Published var iconSize: CGSize
    
    var accessoryViewWidth: CGFloat {
        return mainViewWidth-iconSize.width-40
    }
    
    // MARK: - Initializers
    
    init(mainViewWidth: CGFloat, contentMode: ContentMode = .fill, iconSize: CGSize = CGSize(width: 60, height: 60)) {
        self.mainViewWidth = mainViewWidth
        self.contentMode = contentMode
        self.iconSize = iconSize
    }
}
