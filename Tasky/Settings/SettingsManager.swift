//
//  SettingsManager.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 23.08.2024.
//

import Foundation

class SettingsManager: SettingsManaging{
    var notificationSettingsManager: NotificationSettingsManaging
    var dataAndStorageManager: DataStorageManaging
    
    init(notificationSettingsManager: NotificationSettingsManaging, dataAndStorageManager: DataStorageManaging) {
        self.notificationSettingsManager = notificationSettingsManager
        self.dataAndStorageManager = dataAndStorageManager
    }
    
    func resetAllSettings() {
        notificationSettingsManager.resetAllSettings()
        dataAndStorageManager.resetDataAndStorageSettings()
    }
}
