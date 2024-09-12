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
    let context: NSManagedObjectContext
    
    private let colorThemeKey: String = "colorThemeKey"
    private let colorSchemeKey: String = "colorSchemeKey"
    
    var colorTheme: Color {
        didSet {
            if let data = colorTheme.toData(){
                userDefaults.set(data, forKey: colorThemeKey)
            }
        }
    }
    
    var colorScheme: ColorScheme? {
        didSet{
            if let colorScheme {
                userDefaults.set(colorScheme == .dark ? "dark" : "light", forKey: colorSchemeKey)
            } else {
                userDefaults.removeObject(forKey: colorSchemeKey)
            }
        }
    }
    
    func reset() {
        colorTheme = .green
    }
    
    init() {
        self.context = PersistentController.shared.context
        if let data = userDefaults.data(forKey: colorThemeKey), let color = Color.fromData(data){
            self.colorTheme = color
        } else {
            self.colorTheme = .blue
        }
        
        if let schemeString = userDefaults.string(forKey: colorSchemeKey) {
            self.colorScheme = schemeString == "dark" ? .dark : .light
        } else {
            self.colorScheme = nil
        }
    }
}
