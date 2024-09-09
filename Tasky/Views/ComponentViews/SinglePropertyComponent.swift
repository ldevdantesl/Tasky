//
//  SinglePropertyView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 9.09.2024.
//

import SwiftUI

struct SinglePropertyComponent: View {
    let title: String
    let property: String?
    let fontStyle: Font.TextStyle
    let fontWeight: Font.Weight?
    
    init(title: String, property: String?, fontStyle: Font.TextStyle, fontWeight: Font.Weight? = nil) {
        self.title = title
        self.property = property
        self.fontStyle = fontStyle
        self.fontWeight = fontWeight
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .font(.system(.subheadline, design: .rounded, weight: .bold))
                .foregroundStyle(.customSecondary)
            
            Text(property ?? "No description")
                .font(.system(fontStyle, design: .rounded, weight: fontWeight ?? .medium))
                .frame(maxWidth: Constants.screenWidth - 20, alignment:.leading)
        }
        .padding([.horizontal,.bottom], 15)
    }
}

#Preview {
    SinglePropertyComponent(title: "Title", property: "Title", fontStyle: .title3, fontWeight: .bold)
}
