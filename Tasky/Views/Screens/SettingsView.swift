//
//  SettingsView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 21.08.2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var todoVM: TodoViewModel
    @EnvironmentObject var tagVM: TagViewModel
    @EnvironmentObject var settingsMgrVM: SettingsManagerViewModel
    
    @State private var showAlert: Bool = false
    
    var colorTheme: Color {
        settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    var body: some View {
        ScrollView{
            SettingsRowComponent(title: "Tags", image: "number", color: .teal, link: "TagSettingsView")
            
            SettingsRowComponent(title: "Data & Storage", image: "folder.fill", color: .yellow, link: "DataStorageSettingsView")
            
            SettingsRowComponent(title: "Notification & Sound", image: "bell.fill", color: .blue.opacity(0.8), link: "NotificationSoundSettingsView")
            
            SettingsRowComponent(title: "Privacy & Security", image: "checkerboard.shield", color: .red.opacity(0.8), link: "PrivacySecuritySettingsView")
            
            SettingsRowComponent(title: "Appearance", image: "drop.degreesign.fill", color: .purple, link: "AppearanceSettingsView")
            
            ShareAndFAQFragmentView()
        }
        .padding(.top, 5)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("Settings")
                    .font(.system(.title, design: .rounded, weight: .bold))
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.red)
                    .onTapGesture{
                        withAnimation {
                            showAlert.toggle()
                        }
                    }
            }
        }
        .navigationBarBackButtonHidden()
        .alert("Reset All Settings", isPresented: $showAlert) {
            Button("Reset", role:.destructive) {
                settingsMgrVM.settingsManager.resetAllSettings()
            }
        } message: {
            Text("Do you want to reset all the custom settings?")
        }
        .background(Color.background)
        .safeAreaInset(edge: .bottom) {
            TabBarsComponent()
        }
        .onAppear(perform: settingsMgrVM.settingsManager.notificationSettingsManager.checkAuthorizationStatus)
    }
}

#Preview {
    NavigationStack{
        SettingsView()
    }
}
