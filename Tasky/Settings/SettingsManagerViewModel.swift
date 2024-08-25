//
//  SettingsManagerViewModel.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 23.08.2024.
//

import Foundation
import UIKit

class SettingsManagerViewModel: ObservableObject {
    @Published var settingsManager: SettingsManaging
    @Published var currentLanguage: String
    
    init(settingsManager: SettingsManaging) {
        self.settingsManager = settingsManager
        self.currentLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc private func languageDidChange(){
        self.currentLanguage = Locale.current.language.languageCode?.identifier ?? "en"
    }
}

extension String {
    func localizeLanguageCode() -> String? {
        return Locale.current.localizedString(forLanguageCode: self)
    }
}
