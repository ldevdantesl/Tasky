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
    
    var privacyAndSecurityManager: PrivacyAndSecurityManaging
    
    var appearanceSettingsManager: AppearanceSettingsManaging
    
    init(dataAndStorageManager: DataStorageManaging, notificationSettingsManager: NotificationSettingsManaging, privacyAndSecurityManager: PrivacyAndSecurityManaging, appearanceSettingsManager: AppearanceSettingsManaging) {
        self.dataAndStorageManager = dataAndStorageManager
        self.notificationSettingsManager = notificationSettingsManager
        self.privacyAndSecurityManager = privacyAndSecurityManager
        self.appearanceSettingsManager = appearanceSettingsManager
    }
    
    func resetAllSettings() {
        notificationSettingsManager.resetAllSettings()
        dataAndStorageManager.resetDataAndStorageSettings()
        privacyAndSecurityManager.resetSettings()
    }
}
