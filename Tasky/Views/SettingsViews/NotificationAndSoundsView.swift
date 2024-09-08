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
    
    var body: some View {
        ScrollView{
            SettingsRowComponent(title: "Pause all Notifications", subtitle: "Temporarily pause all notifications", image: "bell.slash.fill", color: .gray.opacity(0.8), toggler: $settingsMgrVM.settingsManager.notificationSettingsManager.isPaused, showingToggleState: true)
                .padding(.top, 10)
            
            SettingsRowComponent(title: "Daily Reminder", subtitle: "Remind of total todos for today at 9 am",image: "alarm.fill", color: .yellow, toggler: $settingsMgrVM.settingsManager.notificationSettingsManager.dailyReminder, showingToggleState: true)
                
            SettingsRowComponent(title: "Send Reminder: \(dailyReminder)", subtitle: "Remind \(dailyReminder) hours before deadline ", image: "clock.arrow.2.circlepath", color: .pink, isDropDown: $settingsMgrVM.settingsManager.notificationSettingsManager.remindedHoursBefore, dropDownVariations: [2,3,4,5])
                
            SettingsRowComponent(title: "Reset", subtitle: "Reset all the custom Settings", image: "arrow.triangle.2.circlepath", color: .red, toggler: $resetAlert)
        
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
}

#Preview {
    NavigationStack{
        NotificationAndSoundsView(settingsMgrVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
    }
}
