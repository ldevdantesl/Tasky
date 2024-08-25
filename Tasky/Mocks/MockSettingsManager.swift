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
    
    init(dataAndStorageManager: DataStorageManaging, notificationSettingsManager: NotificationSettingsManaging, privacyAndSecurityManager: PrivacyAndSecurityManaging) {
        self.dataAndStorageManager = dataAndStorageManager
        self.notificationSettingsManager = notificationSettingsManager
        self.privacyAndSecurityManager = privacyAndSecurityManager
    }
    
    func resetAllSettings() {
        notificationSettingsManager.resetAllSettings()
    }
}
