//
//  PrivacyAndSecuritySettingsManager.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 24.08.2024.
//

import Foundation
import CoreData

class PrivacyAndSecuritySettingsManager: PrivacyAndSecurityManaging{
    private let context: NSManagedObjectContext
    let userDefaults = UserDefaults.standard
    
    private let useBiometricsKey: String = "useBiometrics"
    private let lockWhenBackgroundedKey: String = "lockWhenBackgrounded"
    
    init() {
        self.context = PersistentController.shared.context
        self.useBiometrics = userDefaults.object(forKey: useBiometricsKey) == nil ? false : userDefaults.bool(forKey: useBiometricsKey)
        self.lockWhenBackgrounded = userDefaults.object(forKey: lockWhenBackgroundedKey) == nil ? true : userDefaults.bool(forKey: lockWhenBackgroundedKey)
    }
    
    var useBiometrics: Bool {
        didSet{
            userDefaults.set(useBiometrics, forKey: useBiometricsKey)
        }
    }
    
    var lockWhenBackgrounded: Bool {
        didSet{
            userDefaults.set(lockWhenBackgrounded, forKey: lockWhenBackgroundedKey)
        }
    }
    
    func resetSettings() {
        useBiometrics = false
        lockWhenBackgrounded = true
    }
}
