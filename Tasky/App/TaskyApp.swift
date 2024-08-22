//
//  TaskyApp.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import SwiftUI

@main
struct TaskyApp: App {
    @StateObject var persistentController = PersistentController.shared
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistentController.context)
                .onAppear(perform: NotificationManager.shared.requestPermission)
        }
    }
}
