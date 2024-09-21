//
//  AppearanceSettingsManager.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 26.08.2024.
//

import Foundation
import SwiftUI
import CoreData

class AppearanceSettingsManager: AppearanceSettingsManaging {
    let userDefaults = UserDefaults.standard
    let context: NSManagedObjectContext = PersistentController.shared.context
    
    private let colorThemeKey: String = "colorTheme"
    private let colorSchemeKey: String = "colorScheme"
    
    var colorTheme: Color {
        get {
            guard let data = userDefaults.data(forKey: colorThemeKey), let color = Color.fromData(data) else { return .blue }
            return color
        } set {
            guard let data = newValue.toData() else { return }
            userDefaults.set(data, forKey: colorThemeKey)
        }
    }
    
    var colorScheme: ColorScheme? {
        get {
            guard let schemeString = userDefaults.string(forKey: colorSchemeKey) else { return nil }
            return schemeString == "dark" ? .dark : .light
        } set {
            guard let newValue else { userDefaults.removeObject(forKey: colorSchemeKey); return }
            userDefaults.set(newValue == .dark ? "dark" : "light", forKey: colorSchemeKey)
        }
    }
    
    func reset() {
        colorTheme = .green
        colorScheme = nil
    }
}
