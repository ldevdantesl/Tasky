//
//  MockPreviews.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 23.08.2024.
//

import Foundation

struct MockPreviews{
    static let mockNotificationManager = MockNotificationSettingsManager()
    static let mockDataAndStorageManager = MockDataAndStorageManager()
    static let mockPrivacyAndSecurityManager = MockPrivacySecurityManager()
    static let mockSettingsManager = MockSettingsManager(dataAndStorageManager: mockDataAndStorageManager, notificationSettingsManager: mockNotificationManager, privacyAndSecurityManager: mockPrivacyAndSecurityManager)
    static let viewModel = SettingsManagerViewModel(settingsManager: mockSettingsManager)
}
