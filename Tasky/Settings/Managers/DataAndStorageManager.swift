//
//  DataAndStorageManager.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 23.08.2024.
//

import Foundation
import CoreData

class DataAndStorageManager: DataStorageManaging {
    
    private let context: NSManagedObjectContext = PersistentController.shared.context
    private let userDefaults = UserDefaults.standard
    private weak var todoVM: TodoViewModel?
    
    private let isArchiveAfterCompletionEnabledKey = "isArchiveAfterCompletionEnabled"
    private let archiveAfterDaysKey = "archiveAfterDays"
    
    init(todoVM: TodoViewModel?) {
        self.todoVM = todoVM
    }
    
    var isArchiveAfterCompletionEnabled: Bool{
        get {
            return userDefaults.object(forKey: isArchiveAfterCompletionEnabledKey) == nil ? true : userDefaults.bool(forKey: isArchiveAfterCompletionEnabledKey)
        }
        set{
            userDefaults.set(newValue, forKey: isArchiveAfterCompletionEnabledKey)
        }
    }
    
    var archiveAfterDays: Int{
        get {
            return userDefaults.integer(forKey: archiveAfterDaysKey) == 0 ? 20 : userDefaults.integer(forKey: archiveAfterDaysKey)
        }
        set {
            userDefaults.set(newValue, forKey: archiveAfterDaysKey)
        }
    }
    
    func clearCache() {
        print("Clearing the cache")
    }
    
    func archiveOldCompletedTodos() {
        guard isArchiveAfterCompletionEnabled else { return }
        let request: NSFetchRequest = Todo.fetchRequest()
        logger.log("Archive completed todos after: \(self.archiveAfterDays)")
        let xDaysAgo = Calendar.current.date(byAdding: .day, value: -self.archiveAfterDays, to: Date())!
        logger.log("Xdays Ago: \(xDaysAgo)")
        let predicate1 = NSPredicate(format: "isDone == %@", NSNumber(value: true))
        let predicate2 = NSPredicate(format: "isArchived == %@", NSNumber(value: false))
        let predicate3 = NSPredicate(format: "isRemoved == %@", NSNumber(value: false))
        let predicate4 = NSPredicate(format: "completionDate <= %@", xDaysAgo as NSDate)
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3, predicate4])
        
        do {
            let todosToArchive = try context.fetch(request)
            todosToArchive.forEach { todo in
                logger.log("Found old completed todo: \(todo.title ?? "Test Title")")
                todo.isArchived = true
            }
            try context.save()
            todoVM?.fetchAllTodos()
        } catch {
            print("Failed to archive old completed Todo:\(error.localizedDescription)")
        }
    }
    
    func resetDataAndStorageSettings() {
        isArchiveAfterCompletionEnabled = true
        archiveAfterDays = 20
    }
}
