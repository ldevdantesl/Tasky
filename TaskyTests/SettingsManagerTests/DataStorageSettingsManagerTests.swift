//
//  DataStorageSettingsManagerTests.swift
//  TaskyTests
//
//  Created by Buzurg Rakhimzoda on 20.09.2024.
//

import Testing
import SwiftUICore
@testable import Tasky

struct DataStorageSettingsManagerTests {
    let todoVM = TodoViewModel()
    var dataAndStorageSettingsManager: DataStorageManaging
    
    init() {
        self.dataAndStorageSettingsManager = DataAndStorageManager(todoVM: todoVM)
    }
    
    @Test func propertyGetter() throws {
        let storedArchiveAfterDays: Int = UserDefaults.standard.object(forKey: "archiveAfterDays") == nil ? 20 : UserDefaults.standard.integer(forKey: "archiveAfterDays")
        let storedIsArchiveAfterCompletionEnabled: Bool = UserDefaults.standard.object(forKey: "isArchiveAfterCompletionEnabled") == nil ? true : UserDefaults.standard.bool(forKey: "isArchiveAfterCompletionEnabled")
        
        #expect(dataAndStorageSettingsManager.archiveAfterDays == storedArchiveAfterDays)
        #expect(dataAndStorageSettingsManager.isArchiveAfterCompletionEnabled == storedIsArchiveAfterCompletionEnabled)
    }
    
    @Test func propertySetter() throws {
        UserDefaults.standard.set(false, forKey: "isArchiveAfterCompletionEnabled")
        UserDefaults.standard.set(15, forKey: "archiveAfterDays")
        
        #expect(dataAndStorageSettingsManager.archiveAfterDays == 15)
        #expect(!dataAndStorageSettingsManager.isArchiveAfterCompletionEnabled)
    }
    
    @Test mutating func archiveOldCompletedTodos() throws {
        dataAndStorageSettingsManager.isArchiveAfterCompletionEnabled = true
        let context = PersistentController.shared.context
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: .now)
        let todo = Todo(context: context)
        todo.id = UUID()
        todo.title = "Test Title"
        todo.desc = nil
        todo.dueDate = thirtyDaysAgo
        todo.isDone = true
        todo.isArchived = false
        todo.isRemoved = false
        todo.tags = NSSet(array: [])
        todo.completionDate = thirtyDaysAgo
        logger.log("Todo:\(todo)")
        dataAndStorageSettingsManager.archiveOldCompletedTodos()
        #expect(todoVM.archivedTodos.count > 0)
    }
    
    @Test func reset() throws {
        dataAndStorageSettingsManager.resetDataAndStorageSettings()
        #expect(dataAndStorageSettingsManager.isArchiveAfterCompletionEnabled)
        #expect(dataAndStorageSettingsManager.archiveAfterDays == 20)
    }

}
