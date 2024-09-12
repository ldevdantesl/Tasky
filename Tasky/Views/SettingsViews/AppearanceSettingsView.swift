//
//  AppearanceView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 25.08.2024.
//

import SwiftUI

struct AppearanceSettingsView: View {
    @ObservedObject var settingsManagerVM: SettingsManagerViewModel
    @Binding var path: NavigationPath
    
    @State private var resetAlert: Bool = false
    
    var colorTheme: Color {
        settingsManagerVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    var body: some View {
        ScrollView{
            SettingsRowComponent(title: "Appearance", subtitle: "Choose  a theme for the app", image: "paintpalette.fill", color: colorTheme, selectedColor: $settingsManagerVM.settingsManager.appearanceSettingsManager.colorTheme)
                .padding(.top, 10)
            
            SettingsRowComponent(title: "Language", subtitle: "Language of the app", image: "globe", color: .blue.opacity(0.8), rightSideText: Locale(identifier: settingsManagerVM.currentLanguage).localizedString(forIdentifier: settingsManagerVM.currentLanguage)?.capitalized, action: openSettings)
            
            SettingsRowComponent(title: "Reset", subtitle: "Reset all the custom Settings", image: "arrow.triangle.2.circlepath", color: .red, toggler: $resetAlert)
            
        }
        .alert("Reset Settings", isPresented: $resetAlert) {
            Button("Reset", role:.destructive, action:settingsManagerVM.settingsManager.appearanceSettingsManager.reset)
        } message: {
            Text("Reset all the custom Settings?")
        }
        .navigationTitle("Privacy & Security")
        .navigationBarTitleDisplayMode(.inline)
        .background(Constants.backgroundColor)
    }
    
    func openSettings() {
        guard let settingsURL: URL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL){
            UIApplication.shared.open(settingsURL)
        }
    }
}

#Preview {
    NavigationStack{
        AppearanceSettingsView(settingsManagerVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
    }
}
