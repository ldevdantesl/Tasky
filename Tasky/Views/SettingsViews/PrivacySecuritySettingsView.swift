//
//  PrivacySecuritySettingsView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 24.08.2024.
//

import SwiftUI

struct PrivacySecuritySettingsView: View {
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    @Binding var path: NavigationPath
    @State private var resetAlert: Bool = false
    
    var colorTheme: Color {
        settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    var body: some View {
        ScrollView{
            SettingsRowComponent(title: "Lock App", subtitle: "Lock the app when it is backgrounded", image: "lock.square.stack.fill", color: .purple.opacity(0.8), toggler: $settingsMgrVM.settingsManager.privacyAndSecurityManager.lockWhenBackgrounded, showingToggleState: true)
                .padding(.top, 10)
            
            SettingsRowComponent(title: "Use Biometrics", subtitle: "Open only with Face ID or Touch ID.", image: "faceid", color: .green, toggler: $settingsMgrVM.settingsManager.privacyAndSecurityManager.useBiometrics, showingToggleState: true)
            
            SettingsRowComponent(title: "Reset", subtitle: "Reset the custom settings", image: "arrow.triangle.2.circlepath", color: .red, toggler: $resetAlert)
            
        }
        .navigationTitle("Privacy & Security")
        .navigationBarTitleDisplayMode(.inline)
        .background(Constants.backgroundColor)
        .alert("Reset Settings", isPresented: $resetAlert) {
            Button("Reset", role:.destructive, action:settingsMgrVM.settingsManager.privacyAndSecurityManager.resetSettings)
        } message: {
            Text("Reset all the custom Settings?")
        }

    }
}

#Preview {
    NavigationStack{
        PrivacySecuritySettingsView(settingsMgrVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
    }
}
