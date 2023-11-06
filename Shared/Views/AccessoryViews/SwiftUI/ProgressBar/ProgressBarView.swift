//
//  ProgressBarView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 17/03/23.
//  Copyright © 2021 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI
import Combine

struct ProgressBarView: View {
    
    // MARK: - Observed Variables
    
    @ObservedObject var viewModel: ProgressBarViewModel
    
    init(viewModel: ProgressBarViewModel?) throws {
        guard let viewModel = viewModel else {
            throw NAError.dataFormat(type: .invalidJSONPayload)
        }
        self.viewModel = viewModel
    }
    
    // MARK: - Views
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.progressState.topMessage)
                .padding(.bottom, 0)
                .accessibilityIdentifier("progressbar_accessory_view_top_message")
            if viewModel.progressState.percent != -1 {
                ProgressView(value: viewModel.progressState.percent/100)
                    .progressViewStyle(.linear)
                    .padding(.top, -1)
                    .padding(.bottom, -3)
                    .accessibilityIdentifier("progressbar_accessory_view_progressview_determined")
            } else {
                ProgressView()
                    .progressViewStyle(.linear)
                    .padding(.top, 0)
                    .padding(.bottom, 0)
                    .accessibilityIdentifier("progressbar_accessory_view_progressview_indeterminate")
            }
            Text(viewModel.progressState.bottomMessage)
                .font(.system(.footnote))
                .opacity(0.7225)
                .padding(.top, 0)
                .accessibilityIdentifier("progressbar_accessory_view_bottom_message")
        }
        .onAppear {
            viewModel.setButtonsState(for: viewModel.progressState)
        }
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        try? ProgressBarView(viewModel: ProgressBarViewModel(progressState: ProgressState("/percent 50 /top_message Top /bottom_message Bottom"), mainButtonState: Binding(get: {
            return .enabled
        }, set: { _, _ in
            
        }), secondaryButtonState: Binding(get: {
            return .enabled
        }, set: { _, _ in
            
        })))
    }
}
