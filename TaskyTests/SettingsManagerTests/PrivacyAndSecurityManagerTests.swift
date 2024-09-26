//
//  PrivacyAndSecurityManagerTests.swift
//  TaskyTests
//
//  Created by Buzurg Rakhimzoda on 20.09.2024.
//

import Testing
import SwiftUICore
@testable import Tasky

struct PrivacyAndSecurityManagerTests {
    let privacySecurityManager: PrivacyAndSecurityManaging = PrivacyAndSecuritySettingsManager()
    
    @Test func propertiesGetter() throws {
        #expect(privacySecurityManager.lockWhenBackgrounded == UserDefaults.standard.bool(forKey: "lockWhenBackgrounded"))
        #expect(privacySecurityManager.useBiometrics == UserDefaults.standard.bool(forKey: "useBiometrics"))
    }
    
    @Test func propertiesSetter() throws {
        UserDefaults.standard.set(false, forKey: "lockWhenBackgrounded")
        UserDefaults.standard.set(true, forKey: "useBiometrics")
        
        #expect(!privacySecurityManager.lockWhenBackgrounded)
        #expect(privacySecurityManager.useBiometrics)
    }
    
    @Test func resetSettings() throws {
        privacySecurityManager.resetSettings()
        #expect(privacySecurityManager.lockWhenBackgrounded)
        #expect(!privacySecurityManager.useBiometrics)
    }
}
