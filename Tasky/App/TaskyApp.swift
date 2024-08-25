//
//  TaskyApp.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import SwiftUI
import BackgroundTasks

@main
struct TaskyApp: App {
    @StateObject var persistentController = PersistentController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistentController.context)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "Dantes.Tasky.archiveTodos", using: nil) { task in
            self.handleArchiveTodosTask(task: task as! BGProcessingTask)
        }
    }
    func handleArchiveTodosTask(task: BGProcessingTask) {
        scheduleArchiveTodoTask()
        
        let dataAndStorageManager = DataAndStorageManager(todoVM: nil)
        
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        dataAndStorageManager.archiveOldCompletedTodos()
        
        task.setTaskCompleted(success: true)
    }
    
    func scheduleArchiveTodoTask() {
        let request = BGProcessingTaskRequest(identifier: "Dantes.Tasky.archiveTodos")
        request.requiresNetworkConnectivity = false // No need to be connected to the internet to make this background proccess
        request.requiresExternalPower = false // No need to be powering to make this background process
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Failed to tschedule todo archiving task: \(error.localizedDescription)")
        }
    }
}
