//
//  NotificationManager.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 23.08.2024.
//

import Foundation

class NotificationSettingsManager: NotificationSettingsManaging {
    private let userDefaults = UserDefaults.standard
    
    private let isPausedKey = "isPaused"
    private let dailyReminderKey = "dailyReminder"
    private let reminderHoursBeforeKey = "reminderHoursBefore"
    
    var isPaused: Bool {
        get {
            return userDefaults.object(forKey: isPausedKey) == nil ? false : userDefaults.bool(forKey: isPausedKey)
        }
        set{
            userDefaults.set(newValue, forKey: isPausedKey)
        }
    }
    
    var dailyReminder: Bool {
        get {
            return userDefaults.object(forKey: dailyReminderKey) == nil ? true : userDefaults.bool(forKey: dailyReminderKey)
        }
        set{
            userDefaults.set(newValue, forKey: dailyReminderKey)
        }
    }
    
    var remindedHoursBefore: Int {
        get {
            return userDefaults.integer(forKey: reminderHoursBeforeKey) == 0 ? 2 : userDefaults.integer(forKey: reminderHoursBeforeKey)
        }
        set{
            userDefaults.set(newValue, forKey: reminderHoursBeforeKey)
        }
    }
    
    func resetAllSettings() {
        isPaused = false
        dailyReminder = true
        remindedHoursBefore = 2
    }
}
