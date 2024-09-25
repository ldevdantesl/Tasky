//
//  NotificationManager.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 23.08.2024.
//

import Foundation
import UserNotifications
import CoreData

class NotificationSettingsManager: NotificationSettingsManaging {
    private var previouslyScheduledTodosCount: Int = 0
    private let userDefaults = UserDefaults.standard
    
    private let isPausedKey = "isPaused"
    private let dailyReminderKey = "dailyReminder"
    private let reminderHoursBeforeKey = "reminderHoursBefore"
    private let isAuthorizedKey = "isAuthorized"
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: .NSManagedObjectContextObjectsDidChange, object: PersistentController.shared.context)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func contextObjectsDidChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        // Check if todos were inserted or updated
        let insertedTodos = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> ?? []
        let updatedTodos = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> ?? []
        
        // Filter only Todo objects
        let insertedTodoObjects = insertedTodos.compactMap { $0 as? Todo }
        let updatedTodoObjects = updatedTodos.compactMap { $0 as? Todo }
        
        // Filter updated todos to only those whose dueDate was changed
        let calendar = Calendar.current
        let startOfTomorrow = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
        let endOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfTomorrow)!
        
        let isTodoForTomorrow: (Todo) -> Bool = { todo in
            guard let todoDate = todo.dueDate else { return false }
            return todoDate >= startOfTomorrow && todoDate < endOfTomorrow
        }
        
        // Check if any inserted or updated todos are for tomorrow
        let todosForTomorrow = insertedTodoObjects.filter(isTodoForTomorrow) +
        updatedTodoObjects.filter(isTodoForTomorrow)
        
        // If there are any todos for tomorrow, re-call sendEverydayNotification()
        if !todosForTomorrow.isEmpty {
            sendEverydayNotification()
            logger.log("Updated everyday notifications. Total: \(todosForTomorrow.count)")
        } else {
            logger.log("No changes in tomorrow's todos. Notification not updated.")
        }
    }
    
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
            return userDefaults.integer(forKey: reminderHoursBeforeKey) == 0 ? 21 : userDefaults.integer(forKey: reminderHoursBeforeKey)
        }
        set{
            userDefaults.set(newValue, forKey: reminderHoursBeforeKey)
        }
    }
    
    var isAuthorized: Bool {
        get {
            return userDefaults.object(forKey: isAuthorizedKey) == nil ? false : userDefaults.bool(forKey: isAuthorizedKey)
        } set {
            userDefaults.set(newValue, forKey: isAuthorizedKey)
        }
    }
    
    func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                self.isAuthorized = true
            } else {
                self.isAuthorized = false
            }
        }
    }
    
    func requestAuthorizationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined{
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                    if granted {
                        self.isAuthorized = true
                        print("Authorization is granted.")
                    } else if let error{
                        print("Error requesting permission: \(error.localizedDescription)")
                    } else {
                        self.isAuthorized = false
                        print("Permission denied.")
                    }
                }
            } else if settings.authorizationStatus == .denied {
                print("Notifications are denied by the user. Guide them to settings.")
                self.checkAuthorizationStatus()
            } else {
                print("Notifications are already authorized.")
            }
        }
    }
    
    func sendEverydayNotification() {
        guard isAuthorized else { return }
        guard !isPaused else { return }
        guard dailyReminder else { return }
        
        let context = PersistentController.shared.context
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        
        let calendar = Calendar.current
        let startOfTomorrow = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
        let endOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfTomorrow)!
        
        // Set predicate for date range (inclusive of start, exclusive of end)
        fetchRequest.predicate = NSPredicate(format: "dueDate >= %@ AND dueDate < %@", startOfTomorrow as NSDate, endOfTomorrow as NSDate)
        
        do {
            let tomorrowTodos = try context.fetch(fetchRequest)
            
            // Only reschedule if the count of tomorrow's todos has changed
            if tomorrowTodos.count != previouslyScheduledTodosCount {
                // Cancel previous notification
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyReminder"])
                
                // If there are todos for tomorrow, schedule a notification
                if !tomorrowTodos.isEmpty {
                    let content = UNMutableNotificationContent()
                    content.title = "Good Morning."
                    content.subtitle = "You have \(tomorrowTodos.count) todos for tomorrow."
                    content.sound = .default
                    
                    // Set the time for 9 AM on the day before the task date
                    var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: startOfTomorrow)
                    dateComponents.hour = 9 // Set to 9 AM
                    dateComponents.minute = 0
                    
                    // Create a notification trigger for tomorrow at 9 AM
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
                    
                    // Add the new notification request
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Error scheduling notification: \(error.localizedDescription)")
                        } else {
                            print("Notification scheduled for tomorrow reminder.")
                            self.previouslyScheduledTodosCount = tomorrowTodos.count // Update the scheduled count
                        }
                    }
                } else {
                    // No todos for tomorrow, update count to 0
                    previouslyScheduledTodosCount = 0
                }
            } else {
                print("No changes in tomorrow's todos. Notification not rescheduled.")
            }
        } catch {
            print("Error fetching tomorrow todos: \(error.localizedDescription)")
        }
    }
    
    func removeScheduledNotificationFor(_ todo: Todo) {
        guard isAuthorized else {
            print("Can't remove the notification because the app is not authorized for the notifications")
            self.checkAuthorizationStatus()
            return
        }
        
        guard let id = todo.id?.uuidString else { return }
        print("Trying to remove notification with id: \(id)")
        
        // Check delivered notifications
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            if notifications.contains(where: { $0.request.identifier == id }) {
                print("Notification with id \(id) has already been delivered.")
                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
                print("Removed delivered notification for \(todo.title ?? "Todo").")
                return
            }
            
            // If not delivered, check pending notifications
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                let found = requests.contains { $0.identifier == id }
                guard found else {
                    print("Notification with id \(id) not found in pending notifications.")
                    return
                }
                
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
                print("Removed pending notification for \(todo.title ?? "Todo") with id: \(id).")
            }
        }
    }
    
    func scheduleNotificationFor(_ todo: Todo, at taskDate: Date) {
        // Ensure the task is not paused
        guard isAuthorized else {
            self.checkAuthorizationStatus()
            return
        }
        
        guard self.isPaused == false else {
            print("Notifications are paused.")
            return
        }
        
        guard taskDate.getDayAndMonth != Date().getDayAndMonth else {
            print("Can't schedule notification for today \(todo.title ?? "Todo")")
            return
        }
        
        guard let identifier = todo.id?.uuidString else {
            print("Cant get id of todo: \(todo.title ?? "Todo")")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = todo.title ?? "Todo"
        content.subtitle = String(localized: "notification_subtitle")
        content.sound = .default
        
        // Subtract one day from the taskDate to schedule the notification for the day before
        guard let dayBeforeTaskDate = Calendar.current.date(byAdding: .day, value: -1, to: taskDate) else { return }
        
        // Set the time for 9 PM on the day before the task date
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dayBeforeTaskDate)
        dateComponents.hour = remindedHoursBefore // Set to 9 PM
        dateComponents.minute = 0
        
        // Create a notification trigger for the day before
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // Add the notification request
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(todo.title ?? "Todo") at \(dateComponents), with id: \(identifier)")
            }
        }
    }
    
    func resetAllSettings() {
        isPaused = false
        dailyReminder = true
        remindedHoursBefore = 21
    }
}
