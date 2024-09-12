//
//  MockAppearanceSettingsManager.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 26.08.2024.
//

import Foundation
import SwiftUI

class MockAppearanceSettingsManager: AppearanceSettingsManaging {
    func reset() {}
    
    var colorScheme: ColorScheme? = nil

    var colorTheme: Color = .blue
    
}
