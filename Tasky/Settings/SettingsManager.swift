//
//  SettingsManager.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 23.08.2024.
//

import Foundation

class SettingsManager: SettingsManaging {
    var notificationSettingsManager: NotificationSettingsManaging
    var dataAndStorageManager: DataStorageManaging
    var privacyAndSecurityManager: PrivacyAndSecurityManaging
    var appearanceSettingsManager: AppearanceSettingsManaging
    
    init(notificationSettingsManager: NotificationSettingsManaging, dataAndStorageManager: DataStorageManaging, privacyAndSecurityManager: PrivacyAndSecurityManaging, appearanceSettingsManager: AppearanceSettingsManaging) {
        self.notificationSettingsManager = notificationSettingsManager
        self.dataAndStorageManager = dataAndStorageManager
        self.privacyAndSecurityManager = privacyAndSecurityManager
        self.appearanceSettingsManager = appearanceSettingsManager
    }
    
    func resetAllSettings() {
        notificationSettingsManager.resetAllSettings()
        dataAndStorageManager.resetDataAndStorageSettings()
        privacyAndSecurityManager.resetSettings()
    }
}
