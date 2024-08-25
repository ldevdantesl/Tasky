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
    
    func resetDataAndStorageSettings() {
        isArchiveAfterCompletionEnabled = true
        archiveAfterDays = 2
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
    
    func archiveOldCompletedTodos() {
        
    }
}
