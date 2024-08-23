//
//  NotificationSettingsManaging.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 23.08.2024.
//

import Foundation

protocol NotificationSettingsManaging {
    var isPaused: Bool { get set }
    var dailyReminder: Bool { get set }
    var remindedHoursBefore: Int { get set }
    
    func resetAllSettings()
}
