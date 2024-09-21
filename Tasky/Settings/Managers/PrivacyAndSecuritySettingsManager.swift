//
//  PrivacyAndSecuritySettingsManager.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 24.08.2024.
//

import Foundation
import CoreData

class PrivacyAndSecuritySettingsManager: PrivacyAndSecurityManaging {
    private let context: NSManagedObjectContext = PersistentController.shared.context
    let userDefaults = UserDefaults.standard
    
    private let useBiometricsKey: String = "useBiometrics"
    private let lockWhenBackgroundedKey: String = "lockWhenBackgrounded"
    
    var useBiometrics: Bool{
        get{
            return userDefaults.object(forKey: useBiometricsKey) == nil ? false : userDefaults.bool(forKey: useBiometricsKey)
        } set{
            userDefaults.set(newValue, forKey: useBiometricsKey)
        }
    }
    
    var lockWhenBackgrounded: Bool {
        get {
            return userDefaults.object(forKey: lockWhenBackgroundedKey) == nil ? true : userDefaults.bool(forKey: lockWhenBackgroundedKey)
        } set{
            userDefaults.set(newValue, forKey: lockWhenBackgroundedKey)
        }
    }
    
    func resetSettings() {
        useBiometrics = false
        lockWhenBackgrounded = true
    }
}
