//
//  MockNotificationManager.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 23.08.2024.
//

import Foundation

class MockNotificationSettingsManager: NotificationSettingsManaging {
    var isPaused: Bool = false
    
    var dailyReminder: Bool = true
    
    var remindedHoursBefore: Int = 2
    
    func resetAllSettings() {
        isPaused = false
        dailyReminder = true
        remindedHoursBefore = 2
    }
}
