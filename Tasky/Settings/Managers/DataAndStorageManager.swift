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
    private let todoVM: TodoViewModel
    
    private let isArchiveAfterCompletionEnabledKey = "isArchiveAfterCompletionEnabled"
    private let archiveAfterDaysKey = "archiveAfterDaysKey"
    
    init(context: NSManagedObjectContext = PersistentController.shared.context, todoVM: TodoViewModel) {
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
        request.predicate = NSPredicate(format: "isArchived == %@", NSNumber(value: false))
        
        do {
            let todos = try context.fetch(request)
            for todo in todos {
                todo.isArchived = true
                print("Archived: \(todo.title ?? "No title")")
            }
            try context.save()
            todoVM.fetchAllTodos()
        } catch {
            print("Error Archiving Todos: \(error.localizedDescription)")
        }
    }
    
    func deleteTodos() {
        let request: NSFetchRequest = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "isRemoved == %@", NSNumber(value: false))
        
        do {
            let todos = try context.fetch(request)
            for todo in todos {
                todo.isRemoved = true
                print("Removed: \(todo.title ?? "No title")")
            }
            try context.save()
            todoVM.fetchAllTodos()
        } catch  {
            print("Error deleting todos: \(error.localizedDescription)")
        }
    }
    
    func resetDataAndStorageSettings() {
        isArchiveAfterCompletionEnabled = true
        archiveAfterDays = 30
    }
    
}
