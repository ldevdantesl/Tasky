//
//  MockPreviews.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 23.08.2024.
//

import Foundation

struct MockPreviews{
    static let mockNotificationManager = MockNotificationSettingsManager()
    static let mockDataAndStorageManager = DataAndStorageManager(todoVM: nil)
    static let mockPrivacyAndSecurityManager = PrivacyAndSecuritySettingsManager()
    static let mockAppearanceSettingsManager = AppearanceSettingsManager()
    static let mockSettingsManager = MockSettingsManager(dataAndStorageManager: mockDataAndStorageManager, notificationSettingsManager: mockNotificationManager, privacyAndSecurityManager: mockPrivacyAndSecurityManager, appearanceSettingsManager: mockAppearanceSettingsManager)
    static let viewModel = SettingsManagerViewModel(settingsManager: mockSettingsManager)
}
