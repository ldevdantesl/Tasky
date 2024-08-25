//
//  PrivacyAndSecuritySettingsManaging.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 24.08.2024.
//

import Foundation

protocol PrivacyAndSecurityManaging {
    var useBiometrics: Bool { get set }
    var lockWhenBackgrounded: Bool { get set }
    
    func resetSettings()
}
