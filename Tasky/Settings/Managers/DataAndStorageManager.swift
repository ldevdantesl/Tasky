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
    
    private let isArchiveAfterCompletionEnabledKey = "isArchiveAfterCompletionEnabled"
    private let archiveAfterDaysKey = "archiveAfterDaysKey"
    
    init(context: NSManagedObjectContext = PersistentController.shared.context) {
        self.context = context
        self.isArchiveAfterCompletionEnabled = userDefaults.bool(forKey: isArchiveAfterCompletionEnabledKey)
        self.archiveAfterDays = userDefaults.integer(forKey: archiveAfterDaysKey)
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
    func fetchArchivedTodos() -> [Todo] {
        let request: NSFetchRequest = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "isArchived == %@", NSNumber(value: true))
        
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch archived todos: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchDeletedTodos() -> [Todo] {
        let request: NSFetchRequest = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "isRemoved == %@", NSNumber(value: true))
        
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch archived todos: \(error.localizedDescription)")
            return []
        }
    }
    
    func clearCache() {
        
    }
    
    func archiveTodos() {
        let request: NSFetchRequest = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "isArchived == %@", NSNumber(value: false))
        
        do {
            let todos = try context.fetch(request)
            for todo in todos {
                todo.isArchived = true
            }
            try context.save()
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
            }
            try context.save()
        } catch  {
            print("Error deleting todos: \(error.localizedDescription)")
        }
    }
    
    func resetDataAndStorageSettings() {
        isArchiveAfterCompletionEnabled = true
        archiveAfterDays = 30
    }
    
}
