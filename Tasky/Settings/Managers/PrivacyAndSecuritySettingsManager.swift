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
    private let setPasswordKey: String = "setPassword"
    private let lockWhenBackgroundedKey: String = "lockWhenBackgrounded"
    
    init() {
        self.context = PersistentController.shared.context
        self.useBiometrics = userDefaults.bool(forKey: useBiometricsKey)
        self.lockWhenBackgrounded = userDefaults.bool(forKey: lockWhenBackgroundedKey)
        self.setPassword = userDefaults.bool(forKey: setPasswordKey)
    }
    
    var useBiometrics: Bool {
        didSet{
            userDefaults.set(useBiometrics, forKey: useBiometricsKey)
        }
    }
    
    var setPassword: Bool {
        didSet {
            userDefaults.set(setPassword, forKey: setPasswordKey)
        }
    }
    
    var lockWhenBackgrounded: Bool {
        didSet{
            userDefaults.set(lockWhenBackgrounded, forKey: lockWhenBackgroundedKey)
        }
    }
    
}
