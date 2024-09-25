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
    
    var body: some Scene {
        WindowGroup {
            MainView(todoVM: todoVM)
                .environment(\.managedObjectContext, PersistentController.shared.context)
        }
        .backgroundTask(.appRefresh("com.TaskyManage.everydayNotifcation")) { task in
            
        }
    }
}
