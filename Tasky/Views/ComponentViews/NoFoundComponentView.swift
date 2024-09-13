//
//  NoFoundComponent.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 9.09.2024.
//

import SwiftUI

struct NoFoundComponentView: View {
    let image: String
    let color: Color
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let action: (() -> ())?
    
    init(image: String, color: Color, title: LocalizedStringKey, subtitle: LocalizedStringKey, action: (() -> Void)? = nil) {
        self.image = image
        self.color = color
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
    
    var body: some View {
        VStack{
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundStyle(color)
            Text(title)
                .font(.system(.title2, design: .rounded, weight: .bold))
            Text(subtitle)
                .font(.system(.caption, design: .rounded, weight: .light))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .onTapGesture {
            withAnimation {
                if let action{
                    action()
                }
            }
        }
    }
}

#Preview {
    NoFoundComponentView(image: "checkmark.circle.fill", color: .blue, title: "No active Todos", subtitle: "No active Todos. Tap to add", action: nil)
}
