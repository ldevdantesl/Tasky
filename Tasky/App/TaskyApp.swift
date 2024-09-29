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
    @StateObject var settingsManagerVM: SettingsManagerViewModel = SettingsManagerViewModel (
        settingsManager: SettingsManager(
            notificationSettingsManager: NotificationSettingsManager(),
            dataAndStorageManager: DataAndStorageManager(),
            privacyAndSecurityManager: PrivacyAndSecuritySettingsManager(),
            appearanceSettingsManager: AppearanceSettingsManager()
        )
    )
    
    var body: some Scene {
        WindowGroup {
            MainView(todoVM: todoVM, settingsManagerVM: settingsManagerVM, tagVM: tagVM)
                .environment(\.managedObjectContext, PersistentController.shared.context)
                .onAppear {
                    todoVM.configureSettings(settingsManagerVM)
                }
        }
    }
}
