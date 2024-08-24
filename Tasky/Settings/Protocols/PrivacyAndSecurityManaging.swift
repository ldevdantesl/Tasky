//
//  PrivacyAndSecuritySettingsManaging.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 24.08.2024.
//

import Foundation

protocol PrivacyAndSecurityManaging {
    var setPassword: Bool { get set }
    var useBiometrics: Bool { get set }
    var lockWhenBackgrounded: Bool { get set }
}
