//
//  UserReplyType.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 17/06/2021.
//  Copyright © 2021 IBM Inc. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import Foundation

/// All the different kind of response that the UI could receive from the user.
enum UserReplyType: String {
    case main // Click on the main button (or on the notification banner for "banner" UI type).
    case secondary // Click on the secondary button.
    case tertiary // Click on the tertiary button.
    case help // Click on the help button. Help button type "infoPopup" is managed in the viewController itself.
    case warning // Click on the warning button. Warning button type "infoPopup" is managed in the viewController itself.
    case dismiss // "banner" UI type UI dismissed.
    case cancel // "Cancel" button pressed on popup.
    case timeout // Timeout.
}
