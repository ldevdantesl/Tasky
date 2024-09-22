//
//  DataStorageSettingsManagerTests.swift
//  TaskyTests
//
//  Created by Buzurg Rakhimzoda on 20.09.2024.
//

import Testing
import SwiftUICore
@testable import Tasky

@MainActor
struct DataStorageSettingsManagerTests {
    var dataAndStorageSettingsManager: DataStorageManaging = DataAndStorageManager()
    
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
    
    @Test func reset() throws {
        dataAndStorageSettingsManager.resetDataAndStorageSettings()
        #expect(dataAndStorageSettingsManager.isArchiveAfterCompletionEnabled)
        #expect(dataAndStorageSettingsManager.archiveAfterDays == 20)
    }

}
