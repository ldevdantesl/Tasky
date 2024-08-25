//
//  DataAndStorageManager.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 23.08.2024.
//

import Foundation
import CoreData

class DataAndStorageManager: DataStorageManaging {
    
    private let context: NSManagedObjectContext
    private let userDefaults = UserDefaults.standard
    private weak var todoVM: TodoViewModel?
    
    private let isArchiveAfterCompletionEnabledKey = "isArchiveAfterCompletionEnabled"
    private let archiveAfterDaysKey = "archiveAfterDaysKey"
    
    init(context: NSManagedObjectContext = PersistentController.shared.context, todoVM: TodoViewModel?) {
        self.context = context
        self.isArchiveAfterCompletionEnabled = userDefaults.bool(forKey: isArchiveAfterCompletionEnabledKey)
        self.archiveAfterDays = userDefaults.integer(forKey: archiveAfterDaysKey)
        self.todoVM = todoVM
    }
    
    var isArchiveAfterCompletionEnabled: Bool{
        didSet{
            userDefaults.set(isArchiveAfterCompletionEnabled, forKey: isArchiveAfterCompletionEnabledKey)
        }
    }
    
    var archiveAfterDays: Int{
        didSet{
            userDefaults.set(archiveAfterDays, forKey: archiveAfterDaysKey)
        }
    }
    
    func clearCache() {
        print("Clearing the cache")
    }
    
    func archiveTodos() {
        let request: NSFetchRequest = Todo.fetchRequest()
        let predicate1 = NSPredicate(format: "isArchived == %@", NSNumber(value: false))
        let predicate2 = NSPredicate(format: "isRemoved == %@", NSNumber(value: false))
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        
        do {
            let todos = try context.fetch(request)
            for todo in todos {
                todo.isArchived = true
                print("Archived: \(todo.title ?? "No title")")
            }
            try context.save()
            todoVM?.fetchAllTodos()
        } catch {
            print("Error Archiving Todos: \(error.localizedDescription)")
        }
    }
    
    func deleteTodos() {
        let request: NSFetchRequest = Todo.fetchRequest()
        let predicate1 = NSPredicate(format: "isRemoved == %@", NSNumber(value: false))
        let predicate2 = NSPredicate(format: "isArchived == %@", NSNumber(value: false))
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        
        do {
            let todos = try context.fetch(request)
            for todo in todos {
                todo.isRemoved = true
                print("Removed: \(todo.title ?? "No title")")
            }
            try context.save()
            todoVM?.fetchAllTodos()
        } catch  {
            print("Error deleting todos: \(error.localizedDescription)")
        }
    }
    
    func archiveOldCompletedTodos() {
        guard isArchiveAfterCompletionEnabled else { return }
        let request: NSFetchRequest = Todo.fetchRequest()
        let xDaysAgo = Calendar.current.date(byAdding: .day, value: -archiveAfterDays, to: Date())!
        let predicate1 = NSPredicate(format: "isDone == %@", NSNumber(value: true))
        let predicate2 = NSPredicate(format: "isArchived == %@", NSNumber(value: false))
        let predicate3 = NSPredicate(format: "comletionDate <= %@", xDaysAgo as NSDate)
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3])
        
        do {
            let todosToArchive = try context.fetch(request)
            todosToArchive.forEach { todo in
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
        archiveAfterDays = 25
    }
}
