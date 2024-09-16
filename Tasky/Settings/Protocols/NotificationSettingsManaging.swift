//
//  NotificationSettingsManaging.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 23.08.2024.
//

import Foundation
import UserNotifications

protocol NotificationSettingsManaging {
    var isPaused: Bool { get set }
    var dailyReminder: Bool { get set }
    var remindedHoursBefore: Int { get set }
    var isAuthorized: Bool { get set }
    
    func checkAuthorizationStatus()
    func scheduleNotificationFor(_ todo: Todo, at taskDate: Date)
    func sendEverydayNotification()
    func removeScheduledNotificationFor(_ todo: Todo)
    func requestAuthorizationPermission()
    func resetAllSettings()
}
