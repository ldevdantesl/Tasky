//
//  AppearanceSettingsManagerTests.swift
//  TaskyTests
//
//  Created by Buzurg Rakhimzoda on 20.09.2024.
//

import Testing
import SwiftUICore
@testable import Tasky

struct AppearanceSettingsManagerTests {
    let appearanceSettingsManger = AppearanceSettingsManager()
    
    @Test func propertiesGetter() throws {
        #expect(appearanceSettingsManger.colorTheme == UserDefaults.standard.object(forKey: "colorTheme") as? Color ?? Color(uiColor: .systemGreen))
        #expect(appearanceSettingsManger.colorScheme == UserDefaults.standard.object(forKey: "colorScheme") as? ColorScheme)
    }
    
    @Test func propertiesSetter() async throws {
        UserDefaults.standard.set(Color.yellow.toData(), forKey: "colorTheme")
        UserDefaults.standard.set("dark", forKey: "colorScheme")
        
        #expect(appearanceSettingsManger.colorTheme == Color(uiColor: .systemYellow))
        #expect(appearanceSettingsManger.colorScheme == .dark)
    }
    
    @Test func resetSettings() throws {
        appearanceSettingsManger.reset()
        #expect(appearanceSettingsManger.colorTheme == Color(uiColor:.systemGreen))
        #expect(appearanceSettingsManger.colorScheme == nil)
    }
}
