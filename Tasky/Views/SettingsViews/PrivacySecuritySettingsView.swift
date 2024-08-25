//
//  PrivacySecuritySettingsView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 24.08.2024.
//

import SwiftUI

struct PrivacySecuritySettingsView: View {
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    
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
                Button(action: settingsMgrVM.settingsManager.privacyAndSecurityManager.resetSettings){
                    rowLabel(title: "Reset", headline: "Reset custom settings", color: .red)
                }
            }
        }
        .navigationTitle("Privacy and Security")
        .toolbarTitleDisplayMode(.inline)
    }
    @ViewBuilder
    func rowLabel(imageName: String? = nil, title: String, headline: String, color: Color) -> some View{
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
