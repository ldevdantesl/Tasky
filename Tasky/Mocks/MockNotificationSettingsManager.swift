//
//  MockNotificationManager.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 23.08.2024.
//

import Foundation

class MockNotificationSettingsManager: NotificationSettingsManaging {
    func requestAuthorizationPermission() {}
    
    func removeScheduledNotificationFor(_ todo: Todo) {}
    
    func sendEverydayNotification() {}
    
    func scheduleNotificationFor(_ todo: Todo, at taskDate: Date) {}
    
    var isPaused: Bool = false
    
    var dailyReminder: Bool = true
    
    var remindedHoursBefore: Int = 21
    
    var isAuthorized: Bool = true
    
    func checkAuthorizationStatus() {}
    
    func resetAllSettings() {
        isPaused = false
        dailyReminder = true
        remindedHoursBefore = 2
    }
}
