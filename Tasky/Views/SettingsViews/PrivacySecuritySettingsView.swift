//
//  PrivacySecuritySettingsView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 24.08.2024.
//

import SwiftUI

struct PrivacySecuritySettingsView: View {
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    @State private var resetAlert: Bool = false
    
    var body: some View {
        Form{
            Section{
                Toggle(isOn: $settingsMgrVM.settingsManager.privacyAndSecurityManager.lockWhenBackgrounded){
                    rowLabel(imageName: "lock.rectangle.on.rectangle", title: "Lock in Background", headline: "Blur the app when it is backgrounded", color: .brown)
                }
            }
            Section{
                Toggle(isOn: $settingsMgrVM.settingsManager.privacyAndSecurityManager.useBiometrics){
                    rowLabel(imageName: "lock.ipad", title: "Use Biometrics", headline: "Open only with Face ID or Touch ID", color: .red)
                }
            }
            Section{
                Button(action: {resetAlert.toggle()}){
                    rowLabel(title: "Reset", headline: "Reset custom settings", color: .red)
                }
            }
            .alert("Reset Settings", isPresented: $resetAlert) {
                Button("Reset", role:.destructive){
                    settingsMgrVM.settingsManager.privacyAndSecurityManager.resetSettings()
                }
            } message: {
                Text("Do you want to reset the privacy and security settings?")
            }

        }
        .navigationTitle("Privacy and Security")
        .navigationBarTitleDisplayMode(.inline)
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
        PrivacySecuritySettingsView(settingsMgrVM: MockPreviews.viewModel)
    }
}
