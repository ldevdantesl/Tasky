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
    
    @State private var resetAlert: Bool = false
    
    var body: some View {
        Form{
            // MARK: - PAUSE ALL AND DAILY REMINDER TOGGLE
            Section{
                Toggle(isOn: $settingsMgrVM.settingsManager.notificationSettingsManager.isPaused){
                    VStack(alignment:.leading){
                        Text("Pause All")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                        Text("Temporarily pause all notifications")
                            .font(.system(.caption, design: .rounded, weight: .light))
                            .foregroundStyle(.secondary)
                    }
                }
                Toggle(isOn: $settingsMgrVM.settingsManager.notificationSettingsManager.dailyReminder){
                    VStack(alignment:.leading){
                        Text("Daily Reminder")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                        Text("Send total todos notification at 9 am everyday")
                            .font(.system(.caption, design: .rounded, weight: .light))
                            .foregroundStyle(.secondary)
                    }
                }
            }
        
            // MARK: - SEND REMINDER BEFORE
            Section{
                Stepper(value: $settingsMgrVM.settingsManager.notificationSettingsManager.remindedHoursBefore, in: 1...5) {
                    VStack(alignment:.leading) {
                        Text("Send Reminder: \(settingsMgrVM.settingsManager.notificationSettingsManager.remindedHoursBefore)")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                        Text("Send a reminder \(settingsMgrVM.settingsManager.notificationSettingsManager.remindedHoursBefore) hours before scheduled")
                            .font(.system(.caption, design: .rounded, weight: .light))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            // MARK: - RESET BUTTON
            Section{
                Button(action: {resetAlert.toggle()}){
                    VStack(alignment:.leading) {
                        Text("Reset all")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .foregroundStyle(.red)
                        Text("Reset all settings")
                            .font(.system(.caption, design: .rounded, weight: .light))
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Notification and Sounds")
        .alert("Reset the settings?", isPresented: $resetAlert) {
            Button(role:.destructive,action: settingsMgrVM.settingsManager.resetAllSettings){
                Text("Reset")
            }
        } message: {
            Text("This action will reset all settings!")
        }

    }
}

#Preview {
    NavigationStack{
        NotificationAndSoundsView(settingsMgrVM: MockPreviews.viewModel)
    }
}
