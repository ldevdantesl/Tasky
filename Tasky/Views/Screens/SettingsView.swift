//
//  SettingsView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 21.08.2024.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var todoVM: TodoViewModel
    @ObservedObject var tagVM: TagViewModel
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    
    @Binding var path: NavigationPath
    
    @State private var showAlert: Bool = false
    
    var colorTheme: Color {
        settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    var body: some View {
        ScrollView{
            SettingsRowComponent(title: "Tags", image: "number", color: .teal, link: "TagSettingsView", path: $path)
            
            SettingsRowComponent(title: "Data & Storage", image: "folder.fill", color: .yellow, link: "DataStorageSettingsView", path: $path)
            
            SettingsRowComponent(title: "Notification & Sound", image: "bell.fill", color: .blue.opacity(0.8), link: "NotificationSoundSettingsView", path: $path)
            
            SettingsRowComponent(title: "Privacy & Security", image: "checkerboard.shield", color: .red.opacity(0.8), link: "PrivacySecuritySettingsView", path: $path)
            
            SettingsRowComponent(title: "Appearance", image: "drop.degreesign.fill", color: .purple, link: "AppearanceSettingsView", path: $path)
            
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
            TabBarsComponent(settingsMgrVM: settingsMgrVM, todoVM: todoVM, tagVM:tagVM, path: $path)
        }
        .onAppear(perform: settingsMgrVM.settingsManager.notificationSettingsManager.checkAuthorizationStatus)
    }
}

#Preview {
    NavigationStack{
        SettingsView(todoVM: TodoViewModel(), tagVM: TagViewModel(), settingsMgrVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
    }
}
