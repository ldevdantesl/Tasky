//
//  MockNotificationManager.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 23.08.2024.
//

import Foundation
import NotificationCenter

class MockNotificationSettingsManager: NotificationSettingsManaging {
    var isPaused: Bool = false
    
    var dailyReminder: Bool = true
    
    var remindedHoursBefore: Int = 21
    
    var isAuthorized: Bool = false
    
    func requestAuthorizationPermission() {
        logger.log("Permission is granted")
        self.isAuthorized = true
    }
    
    func removeScheduledNotificationFor(_ todo: Todo) {
        print("Removed notification for todo.")
    }
    
    func sendEverydayNotification() {
        logger.log("Scheduled notification for tomorrow.")
    }
    
    func scheduleNotificationFor(_ todo: Todo) {
        logger.log("Scheduled notification for todo: \(todo.title ?? "")")
    }
    
    func checkAuthorizationStatus() {
        logger.log("Checked notifcation settings.")
        isAuthorized = true
    }
    
    func resetAllSettings() {
        isPaused = false
        dailyReminder = true
        remindedHoursBefore = 21
    }
}
