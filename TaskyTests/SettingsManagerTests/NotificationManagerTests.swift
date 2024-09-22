//
//  NotificationManagerTests.swift
//  TaskyTests
//
//  Created by Buzurg Rakhimzoda on 20.09.2024.
//

import Testing
import SwiftUICore
@testable import Tasky

struct NotificationSettingsManagerTests {
    var mockNotificationManager: NotificationSettingsManaging = MockNotificationSettingsManager()
    var realNotificationManager: NotificationSettingsManaging = NotificationSettingsManager()
    
    @Test func propertiesGetter() throws {
        #expect(realNotificationManager.isPaused == UserDefaults.standard.bool(forKey: "isPaused"))
        #expect(realNotificationManager.dailyReminder == UserDefaults.standard.bool(forKey: "dailyReminder"))
        #expect(realNotificationManager.isAuthorized == UserDefaults.standard.bool(forKey: "isAuthorized"))
        #expect(realNotificationManager.remindedHoursBefore == UserDefaults.standard.integer(forKey: "reminderHoursBefore"))
    }
    
    @Test mutating func propertiesSetter() throws {
        UserDefaults.standard.set(true, forKey: "isPaused")
        UserDefaults.standard.set(false, forKey: "dailyReminder")
        UserDefaults.standard.set(12, forKey: "reminderHoursBefore")
        UserDefaults.standard.set(false, forKey: "isAuthorized")
        
        #expect(realNotificationManager.isPaused)
        #expect(!realNotificationManager.dailyReminder)
        #expect(!realNotificationManager.isAuthorized)
        #expect(realNotificationManager.remindedHoursBefore == 12)
    }
    
    @Test func resetSettings() throws {
        realNotificationManager.resetAllSettings()
        #expect(realNotificationManager.remindedHoursBefore == 21)
        #expect(!realNotificationManager.isPaused)
        #expect(realNotificationManager.dailyReminder)
    }
    
    @Test func scheduleNotificationForTodo() async throws {
        await mockNotificationManager.scheduleNotificationFor(TodoViewModel.mockToDo(), at: TodoViewModel.mockToDo().dueDate ?? .now)
        #expect(true)
    }
    
    @Test func removeScheduledNotficationForTodo() async throws {
        await mockNotificationManager.removeScheduledNotificationFor(TodoViewModel.mockToDo())
        #expect(true)
    }
    
    @Test func requestAuthorizationStatus() async throws {
        mockNotificationManager.requestAuthorizationPermission()
        #expect(mockNotificationManager.isAuthorized)
    }
    
    @Test func sendEverydayNotification() async throws {
        mockNotificationManager.sendEverydayNotification()
        #expect(true)
    }
}
