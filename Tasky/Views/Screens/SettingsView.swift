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
                .padding(.top, 20)
            
            SettingsRowComponent(title: "Data & Storage", image: "folder.fill", color: .yellow, link: "DataStorageSettingsView")
            
            SettingsRowComponent(title: "Notification & Sound", image: "bell.fill", color: .blue.opacity(0.8), link: "NotificationSoundSettingsView")
            
            SettingsRowComponent(title: "Privacy & Security", image: "checkerboard.shield", color: .red.opacity(0.8), link: "PrivacySecuritySettingsView")
            
            SettingsRowComponent(title: "Appearance", image: "drop.degreesign.fill", color: .purple, link: "AppearanceSettingsView")
            
            ShareAndFAQFragmentView()
        }
        .safeAreaInset(edge: .top, spacing: 0){
            UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 25, bottomTrailing: 25))
                .fill(colorTheme.gradient)
                .overlay(alignment:.bottom) {
                    HStack{
                        Text("Settings")
                            .font(.system(.title, design: .rounded, weight: .bold))
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.white)
                            .onTapGesture {
                                showAlert.toggle()
                            }
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 10)
                }
                .shadow(color: .primary.opacity(0.2), radius: 10, x: 0, y: 5)
                .ignoresSafeArea(.container, edges: .top)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
        }
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
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationStack{
        SettingsView()
            .environmentObject(MockPreviews.viewModel)
            .environmentObject(TodoViewModel())
            .environmentObject(TagViewModel())
            .environmentObject(NavPathManager())
    }
}
