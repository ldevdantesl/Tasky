//
//  MockPrivacySecurityManager.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 24.08.2024.
//

import Foundation

class MockPrivacySecurityManager: PrivacyAndSecurityManaging {
    var useBiometrics: Bool = false
    var lockWhenBackgrounded: Bool = true
    
    func resetSettings() {
        useBiometrics = false
        lockWhenBackgrounded = false
    }
}
