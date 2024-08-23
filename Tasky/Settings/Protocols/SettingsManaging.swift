//
//  SettingsManaging.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 23.08.2024.
//

import Foundation

protocol SettingsManaging {
    var notificationSettingsManager: NotificationSettingsManaging { get set }
    var dataAndStorageManager: DataStorageManaging { get set }
    
    func resetAllSettings() 
}
