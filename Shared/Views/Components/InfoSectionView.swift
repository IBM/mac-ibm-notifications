//
//  InfoSectionView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 04/04/2023.
//  Copyright © 2023 IBM. All rights reserved.
//  SPDX-License-Identifier: Apache2.0
//

import SwiftUI

/// InfoSectionView is a view used to display and InfoSection object.
struct InfoSectionView: View {
    
    // MARK: - Variables
    
    var section: InfoSection
    var idealSizeForSection: CGSize {
        var size: CGSize = .zero
        if section.fields.count == 1 {
            if let description = section.fields[0].description {
                let text = section.fields[0].label + description
                size.height = max(70, (text.heightThatFitsWidth(400)+30))
                size.width = 400
            } else {
                size.height = max(50, section.fields[0].label.heightThatFitsWidth(400))
                size.width = 400
            }
        }
        return size
    }
    
    // MARK: - Views
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(section.fields) { field in
                    HStack {
                        if let description = field.description {
                            Text(field.label)
                                .font(.body)
                                .frame(maxWidth: 80, maxHeight: .infinity, alignment: .leading)
                            Divider()
                                .padding(.horizontal)
                            Text(description)
                                .font(.body)
                        } else {
                            Text(field.label)
                                .font(.body)
                                .frame(alignment: .leading)
                        }
                    }
                }
            }
            .padding()
        }
        .frame(width: calculateIdealSize().width, height: calculateIdealSize().height)
    }
    
    func calculateIdealSize() -> CGSize {
        let maxWidth: CGFloat = 450
        let maxHeight: CGFloat = 450
        let dividerWidth: CGFloat = 30
        let fixedLabelWidth: CGFloat = 80

        let font = NSFont.preferredFont(forTextStyle: .body)
        
        var totalHeight: CGFloat = 50
        var currentMaxWidth: CGFloat = 0
        
        for field in section.fields {
            let labelSize = field.label.size(withAttributes: [.font: font])
            let descriptionSize = field.description?.size(withAttributes: [.font: font]) ?? .zero
            
            let fieldWidth: CGFloat
            let fieldHeight: CGFloat
            
            if field.description != nil {
                fieldWidth = fixedLabelWidth + dividerWidth + descriptionSize.width
                fieldHeight = max(labelSize.height, descriptionSize.height)
            } else {
                fieldWidth = labelSize.width+50
                fieldHeight = labelSize.height+2.5
            }
            
            if fieldWidth > maxWidth {
                if field.description != nil {
                    let adjustedDescriptionWidth = maxWidth - fixedLabelWidth - dividerWidth
                    let descriptionHeight = ceil(descriptionSize.width / adjustedDescriptionWidth) * descriptionSize.height
                    totalHeight += max(labelSize.height, descriptionHeight)
                    currentMaxWidth = maxWidth
                } else {
                    let adjustedLabelWidth = maxWidth
                    let labelHeight = ceil(labelSize.width / adjustedLabelWidth) * labelSize.height
                    totalHeight += labelHeight
                    currentMaxWidth = maxWidth
                }
            } else {
                totalHeight += fieldHeight
                currentMaxWidth = max(currentMaxWidth, fieldWidth)
            }
        }
        
        return CGSize(width: min(maxWidth, currentMaxWidth), height: min(totalHeight, maxHeight))
    }
}
struct InfoSectionView_Previews: PreviewProvider {
    static var previews: some View {
        InfoSectionView(section: InfoSection(fields: [InfoField(label: "First", description: "First First First FirstFirst First First First First First First FirstvFirstFirstFirstFirstFirst FirstFirstFirst First First"),
                                                          InfoField(label: "Second", description: "Second Second Second Second"),
                                                          InfoField(label: "Third", description: "Third"),
                                                          InfoField(label: "Fourth", description: "Fourth Fourth Fourth")]))
    }
}
