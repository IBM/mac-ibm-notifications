//
//  InfoSectionView.swift
//  Notification Agent
//
//  Created by Simone Martorelli on 04/04/2023.
//  Copyright © 2021 IBM. All rights reserved.
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
    var contentSize: CGSize
    
    // MARK: - Initializers
    
    init(section: InfoSection) {
        self.section = section
        self.contentSize = Self.calculateIdealSize(for: section)
    }
    
    // MARK: - Views
    
    var body: some View {
        if contentSize.height >= 450 {
            ScrollView {
                infoSection
            }
            .frame(width: contentSize.width, height: contentSize.height)
        } else {
            HStack(alignment: .center, spacing: 0) {
                infoSection
            }
            .frame(width: contentSize.width, height: contentSize.height)
            .padding(0)
        }
    }
    
    var infoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(section.fields) { field in
                HStack(alignment: .center, spacing: 0) {
                    if let description = field.description {
                        Text(field.label)
                            .font(.body.bold())
                            .frame(width: 80, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                        Divider()
                            .padding(.horizontal)
                        Text(description)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
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
    
    // MARK: - Static Private Methods
    
    static private func calculateIdealSize(for section: InfoSection) -> CGSize {
        let maxWidth: CGFloat = 450
        let maxHeight: CGFloat = 450
        let dividerWidth: CGFloat = 30
        let fixedLabelWidth: CGFloat = 78

        let font = NSFont.preferredFont(forTextStyle: .body)
        
        var totalHeight: CGFloat = 22
        var currentMaxWidth: CGFloat = 0
        
        for field in section.fields {
            let labelSize = (field.label as NSString).boundingRect(with: .init(width: field.description == nil ? maxWidth : fixedLabelWidth, height: 0), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font]).size
            let descriptionSize = (field.description as? NSString)?.boundingRect(with: .init(width: 340, height: 0), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font]).size ?? .zero

            let fieldWidth: CGFloat
            let fieldHeight: CGFloat
            
            if field.description != nil {
                fieldWidth = fixedLabelWidth + dividerWidth + descriptionSize.width + 50
                let labelLines = ceil(labelSize.width / fixedLabelWidth)
                let labelHeight = labelLines > 1 ? labelLines * (labelSize.height+6) : labelSize.height
                fieldHeight = max(labelHeight, descriptionSize.height) + 10
            } else {
                fieldWidth = labelSize.width+50
                fieldHeight = labelSize.height+10
            }
            
            if fieldWidth > maxWidth {
                if field.description != nil {
                    let adjustedDescriptionWidth = maxWidth - fixedLabelWidth - dividerWidth - 50
                    let descriptionLines = ceil(descriptionSize.width / adjustedDescriptionWidth)
                    let descriptionHeight = descriptionLines * descriptionSize.height
                    let labelLines = ceil(labelSize.width / fixedLabelWidth)
                    let labelHeight = labelLines * labelSize.height
                    totalHeight += max(labelHeight, descriptionHeight)
                    currentMaxWidth = maxWidth
                } else {
                    let adjustedLabelWidth = maxWidth
                    let labelHeight = (ceil(fieldWidth / adjustedLabelWidth) * (labelSize.height+4)) + 10
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
        InfoSectionView(section: sectionnineth)
    }
}

let sectionone = InfoSection(fields: [InfoField(label: "First", description: "First First First FirstFirst First First First First First First FirstvFirstFirstFirstFirstFirst FirstFirstFirst First First"),
                                      InfoField(label: "Second", description: "Second Second Second Second"),
                                      InfoField(label: "Third", description: "Third"),
                                      InfoField(label: "Fourth", description: "Fourth Fourth Fourth")])

let sectiontwo = InfoSection(fields: [InfoField(label: "First label"),
                                      InfoField(label: "Second label"),
                                      InfoField(label: "Third label"),
                                      InfoField(label: "Fourth label")])

let sectionthree = InfoSection(fields: [InfoField(label: "First label"),
                                        InfoField(label: "Second label")])

let sectionfour = InfoSection(fields: [InfoField(label: "First label First label First lab\n First label First label First label First label\nFirst label First label First label First label\nFirst label First label First label First label")])

let sectionfifth = InfoSection(fields: [InfoField(label: "First label"),
                                        InfoField(label: "Second label"),
                                        InfoField(label: "Third label"),
                                        InfoField(label: "Fourth label"),
                                        InfoField(label: "First label"),
                                        InfoField(label: "Second label"),
                                        InfoField(label: "Third label"),
                                        InfoField(label: "Fourth label"),
                                        InfoField(label: "First label"),
                                        InfoField(label: "Second label"),
                                        InfoField(label: "Third label"),
                                        InfoField(label: "Fourth label")])

let sectionsixth = InfoSection(fields: [InfoField(label: "First First FirstFirst First", description: "First First First FirstFirst First First First First First First FirstvFirstFirstFirstFirstFirst FirstFirstFirst First First"),
                                        InfoField(label: "Second First First First First First First", description: "Second Second Second Second"),
                                        InfoField(label: "Third", description: "Third"),
                                        InfoField(label: "Fourth", description: "Fourth Fourth Fourth")])

let sectionseventh = InfoSection(fields: [InfoField(label: "First First FirstFirst First", description: "First First First FirstFirst First First First First First First FirstvFirstFirstFirstFirstFirst FirstFirstFirst First First"),
                                          InfoField(label: "Second First First First First First First", description: "First First First FirstFirst First First First First First First FirstvFirstFirstFirstFirstFirst FirstFirstFirst First First Second Second Second"),
                                          InfoField(label: "Third", description: "First First First FirstFirst First First First First First First FirstvFirstFirstFirstFirstFirst FirstFirstFirst First First"),
                                          InfoField(label: "Fourth", description: "First First First FirstFirst First First First First First First FirstvFirstFirstFirstFirstFirst FirstFirstFirst First First Fourth Fourth"),
                                          InfoField(label: "Fourth", description: "First First First FirstFirst First First First First First First FirstvFirstFirstFirstFirstFirst FirstFirstFirst First First Fourth Fourth"),
                                          InfoField(label: "Fourth", description: "First First First FirstFirst First First First First First First FirstvFirstFirstFirstFirstFirst FirstFirstFirst First First Fourth Fourth"),
                                          InfoField(label: "Fourth", description: "First First First FirstFirst First First First First First First FirstvFirstFirstFirstFirstFirst FirstFirstFirst First First Fourth Fourth"),
                                          InfoField(label: "Fourth", description: "First First First FirstFirst First First First First First First FirstvFirstFirstFirstFirstFirst FirstFirstFirst First First Fourth Fourth"),
                                          InfoField(label: "Fourth", description: "First First First FirstFirst First First First First First First FirstvFirstFirstFirstFirstFirst FirstFirstFirst First First Fourth Fourth")])

let sectioneight = InfoSection(fields: [InfoField(label: "First label only only only", description: "First description only"),
                                      InfoField(label: "Second label only only", description: "Second description only"),
                                      InfoField(label: "Third label only only only", description: "Third description only")])

let sectionnineth = InfoSection(fields: [InfoField(label: "First label only", description: "First description only"),
                                      InfoField(label: "Second label only", description: "Second description only"),
                                      InfoField(label: "Third label only", description: "Third description only")])
