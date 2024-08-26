//
//  AppearanceView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 25.08.2024.
//

import SwiftUI

struct AppearanceView: View {
    @ObservedObject var settingsManagerVM: SettingsManagerViewModel
    var body: some View {
        Form{
            Picker(selection: $settingsManagerVM.settingsManager.appearanceSettingsManager.colorTheme) {
                ForEach(ColorThemes.allCases, id: \.self) { theme in
                    HStack{
                        Image(systemName: "circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 20)
                            .foregroundStyle(theme.color)
                        Text(theme.rawValue.capitalized)
                    }
                    .tag(theme.color)
                }
            } label: {
                rowLabel(imageName: "paintpalette", title: "Color Theme", headline: "Choose a theme for the app", color: settingsManagerVM.settingsManager.appearanceSettingsManager.colorTheme)
            }
            .pickerStyle(.navigationLink)
            
            Picker(selection: $settingsManagerVM.settingsManager.appearanceSettingsManager.colorScheme) {
                Text("Light")
                    .tag(ColorScheme.light as ColorScheme?)
                Text("Dark")
                    .tag(ColorScheme.dark as ColorScheme?)
                Text("System")
                    .tag(nil as ColorScheme?)
            } label: {
                rowLabel(imageName: "capsule.lefthalf.filled", title: "Mode", headline: "Define your app mode", color: .indigo)
            }
        }
        .toolbarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    func rowLabel(imageName: String? = nil, title: LocalizedStringKey, headline: LocalizedStringKey, color: Color) -> some View{
        HStack{
            if let imageName{
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 25, maxHeight: 25)
                    .foregroundStyle(color)
            }
            VStack(alignment: .leading){
                Text(title)
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                    .foregroundStyle(color)
                Text(headline)
                    .font(.system(.caption, design: .rounded, weight: .light))
                    .foregroundStyle(.gray)
            }
        }
    }
    
}

#Preview {
    NavigationStack{
        AppearanceView(settingsManagerVM: MockPreviews.viewModel)
    }
}
