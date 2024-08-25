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
    var privacyAndSecurityManager: PrivacyAndSecurityManaging
    
    init(notificationSettingsManager: NotificationSettingsManaging, dataAndStorageManager: DataStorageManaging, privacyAndSecurityManager: PrivacyAndSecurityManaging) {
        self.notificationSettingsManager = notificationSettingsManager
        self.dataAndStorageManager = dataAndStorageManager
        self.privacyAndSecurityManager = privacyAndSecurityManager
    }
    
    func resetAllSettings() {
        notificationSettingsManager.resetAllSettings()
        dataAndStorageManager.resetDataAndStorageSettings()
        privacyAndSecurityManager.resetSettings()
    }
}
