//
//  SettingsManagerViewModel.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 23.08.2024.
//

import Foundation

class SettingsManagerViewModel: ObservableObject {
    @Published var settingsManager: SettingsManaging
    
    init(settingsManager: SettingsManaging) {
        self.settingsManager = settingsManager
    }
}
