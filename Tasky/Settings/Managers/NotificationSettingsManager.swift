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
    
    init() {
        self.isPaused = userDefaults.bool(forKey: isPausedKey)
        self.dailyReminder = userDefaults.bool(forKey: dailyReminderKey)
        self.remindedHoursBefore = userDefaults.integer(forKey: reminderHoursBeforeKey)
    }
    
    var isPaused: Bool {
        didSet{
            userDefaults.set(isPaused, forKey: isPausedKey)
        }
    }
    
    var dailyReminder: Bool {
        didSet {
            userDefaults.set(dailyReminder, forKey: dailyReminderKey)
        }
    }
    
    var remindedHoursBefore: Int {
        didSet{
            userDefaults.set(remindedHoursBefore, forKey: reminderHoursBeforeKey)
        }
    }
    
    func resetAllSettings() {
        isPaused = false
        dailyReminder = true
        remindedHoursBefore = 2
    }
}
