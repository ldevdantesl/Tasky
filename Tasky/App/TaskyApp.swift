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
    @StateObject var todoVM = TodoViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView(todoVM: todoVM)
                .environment(\.managedObjectContext, persistentController.context)
        }
    }
}
