//
//  MockDataAndStorageManager.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 23.08.2024.
//

import Foundation

class MockDataAndStorageManager: DataStorageManaging {
    private var mockTodos: [Todo] = []
    
    var isArchiveAfterCompletionEnabled: Bool = true
    
    var archiveAfterDays: Int = 2
    
    init() {
        let context = PersistentController.shared.context
        let todo1 = Todo(context: context)
        
        todo1.title = "Sample Todo 1"
        todo1.isArchived = true

        let todo2 = Todo(context: context)
        todo2.title = "Sample Todo 2"
        todo2.isRemoved = true

        let todo3 = Todo(context: context)
        todo3.title = "Sample Todo 3"

        mockTodos = [todo1, todo2, todo3]
    }
    
    func resetDataAndStorageSettings() {
        isArchiveAfterCompletionEnabled = true
        archiveAfterDays = 2
    }
    
    func fetchArchivedTodos() -> [Todo] {
        return mockTodos.filter { $0.isArchived }
    }
    
    func fetchDeletedTodos() -> [Todo] {
        return mockTodos.filter { $0.isRemoved }
    }
    
    func clearCache() {
        print("Cleared the cache")
    }
    
    func archiveTodos() {
        mockTodos.forEach { $0.isArchived = true }
    }
    
    func deleteTodos() {
        mockTodos.forEach { $0.isRemoved = true }
    }
}
