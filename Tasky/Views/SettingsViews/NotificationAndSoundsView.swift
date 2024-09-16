//
//  NotificationAndSoundsView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 21.08.2024.
//

import SwiftUI
import UserNotifications

struct NotificationAndSoundsView: View {
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    
    @Binding var path: NavigationPath
    
    @State private var resetAlert: Bool = false
    
    var dailyReminder: Int {
        settingsMgrVM.settingsManager.notificationSettingsManager.remindedHoursBefore
    }
    
    var isAuthorized: Bool {
        return settingsMgrVM.settingsManager.notificationSettingsManager.isAuthorized
    }
    
    var body: some View {
        ScrollView{
            if !isAuthorized {
                SettingsRowComponent(title: "Notifications are disabled ", subtitle: "Tap to open the settings.", image: "bell.slash.circle.fill", color: .red, action: openSettings)
                    .padding(.top, 10)
            }
            
            SettingsRowComponent(title: "Pause all Notifications", subtitle: "Temporarily pause all notifications", image: "bell.slash.fill", color: .gray.opacity(0.8), toggler: $settingsMgrVM.settingsManager.notificationSettingsManager.isPaused, showingToggleState: true)
                .disabled(!isAuthorized)
            
            SettingsRowComponent(title: "Daily Reminder", subtitle: "Remind of total todos for today at 9 am",image: "alarm.fill", color: .yellow, toggler: $settingsMgrVM.settingsManager.notificationSettingsManager.dailyReminder, showingToggleState: true)
                .disabled(!isAuthorized)
                
            SettingsRowComponent(title: "Send Reminder at: \(dailyReminder):00", subtitle: "Notify one day prior to the scheduled todo", image: "clock.arrow.2.circlepath", color: .indigo, isDropDown: $settingsMgrVM.settingsManager.notificationSettingsManager.remindedHoursBefore, dropDownVariations: [9,12,18,21])
                .disabled(!isAuthorized)
            
            SettingsRowComponent(title: "Reset", subtitle: "Reset all the custom Settings", image: "arrow.triangle.2.circlepath", color: .red, toggler: $resetAlert)
                .disabled(!isAuthorized)
        
        }
        .refreshable{
            settingsMgrVM.settingsManager.notificationSettingsManager.checkAuthorizationStatus()
        }
        .frame(width: Constants.screenWidth)
        .navigationTitle("Notification & Sounds")
        .navigationBarTitleDisplayMode(.inline)
        .background(Constants.backgroundColor)
        .alert("Reset the settings?", isPresented: $resetAlert) {
            Button("Reset", role:.destructive,action: settingsMgrVM.settingsManager.notificationSettingsManager.resetAllSettings)
        } message: {
            Text("This action will reset all settings!")
        }
    }
    
    func openSettings() {
        guard let settingsURL = URL(string:UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

#Preview {
    NavigationStack{
        NotificationAndSoundsView(settingsMgrVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
    }
}
