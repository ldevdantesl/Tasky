//
//  NotificationManager.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 21.08.2024.
//

import Foundation
import SwiftUI
import UserNotifications

class NotificationManager{
    
    static let shared = NotificationManager()
    let notificationCenter = UNUserNotificationCenter.current()
    
    func scheduleNotificationIfNeeded(for todos: [Todo]){
        let calendar = Calendar.current
        let today = Date()
        
        let todayComponents = calendar.dateComponents([.year,.month,.day], from: today)
        
        let hasTodosForToday = todos.filter { todo in
            guard let dueDate = todo.dueDate else { return false }
            let todoDateComponents = calendar.dateComponents([.year,.month,.day], from: dueDate)
            return todoDateComponents == todayComponents
        }
        
        if hasTodosForToday.count > 0{
            scheduleDailyNotification(totalTodos: hasTodosForToday.count)
        }
    }
    
    private func scheduleDailyNotification(totalTodos: Int){
        let content = UNMutableNotificationContent()
        content.title = "Today's To-Dos"
        content.body = "You have totally \(totalTodos) tasks scheduled for today, Don't forget to check them!"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error{
                print("Can't send the daily message: \(error.localizedDescription)")
            }
        }
    }
    
    func requestPermission(){
        let hasRequestedNotificationPermission = UserDefaults.standard.bool(forKey: "hasRequestedNotificationPermission")
        
        if !hasRequestedNotificationPermission{
            notificationCenter.requestAuthorization(options: [.alert,.badge, .sound]) { success, error in
                if let error = error{
                    print("Permission is not granted: \(error.localizedDescription)")
                } else {
                    UserDefaults.standard.set(true, forKey: "hasRequestedNotificationPermission")
                    print("Notification Permission is granted: \(success)")
                }
            }
        }
    }
}

#if DEBUG
extension NotificationManager{
    func scheduleMockNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Today's To-Dos"
        content.body = "You have task scheduled for today, Don't forget to check them!"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error{
                print("Can't send the daily message: \(error.localizedDescription)")
            }
        }
    }
}
#endif
