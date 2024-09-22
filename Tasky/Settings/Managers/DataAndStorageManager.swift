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
    
    private let isArchiveAfterCompletionEnabledKey = "isArchiveAfterCompletionEnabled"
    private let archiveAfterDaysKey = "archiveAfterDays"
    
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
    
    func resetDataAndStorageSettings() {
        isArchiveAfterCompletionEnabled = true
        archiveAfterDays = 20
    }
}
