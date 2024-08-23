//
//  MockSettingsManager.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 23.08.2024.
//

import Foundation

class MockSettingsManager: SettingsManaging{
    var dataAndStorageManager: DataStorageManaging
    
    var notificationSettingsManager: NotificationSettingsManaging
    
    init(dataAndStorageManager: DataStorageManaging, notificationSettingsManager: NotificationSettingsManaging) {
        self.dataAndStorageManager = dataAndStorageManager
        self.notificationSettingsManager = notificationSettingsManager
    }
    
    func resetAllSettings() {
        notificationSettingsManager.resetAllSettings()
    }
}
