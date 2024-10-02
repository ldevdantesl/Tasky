//
//  TaskyApp.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import SwiftUI

@main
struct TaskyApp: App {
    @StateObject var todoVM = TodoViewModel()
    @StateObject var tagVM: TagViewModel = TagViewModel()
    @StateObject var settingsMgrVM: SettingsManagerViewModel = SettingsManagerViewModel (
        settingsManager: SettingsManager(
            notificationSettingsManager: NotificationSettingsManager(),
            dataAndStorageManager: DataAndStorageManager(),
            privacyAndSecurityManager: PrivacyAndSecuritySettingsManager(),
            appearanceSettingsManager: AppearanceSettingsManager()
        )
    )
    @StateObject var navpath: NavPathManager = NavPathManager()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, PersistentController.shared.context)
                .environmentObject(todoVM)
                .environmentObject(tagVM)
                .environmentObject(settingsMgrVM)
                .environmentObject(navpath)
                .onAppear {
                    todoVM.configureSettings(settingsMgrVM)
                }
        }
    }
}
