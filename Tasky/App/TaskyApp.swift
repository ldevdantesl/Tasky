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
    @StateObject var todoVM = TodoViewModel()

    var body: some Scene {
        WindowGroup {
            MainView(todoVM: todoVM)
                .environment(\.managedObjectContext, persistentController.context)
        }
        .backgroundTask(.appRefresh("Dantes.Tasky.archiveTodos")) { task in
            scheduleArchiveTodoTask()
            await todoVM.fetchCompletedTodos()
        }
    }
}

func scheduleArchiveTodoTask() {
    print("Scheduling background task for archiving todos")
    
    let request = BGAppRefreshTaskRequest(identifier: "Dantes.Tasky.archiveTodos")
    request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 minutes from now
    
    do {
        try BGTaskScheduler.shared.submit(request)
        print("Scheduling succeeded")
        
        // Check pending tasks
        BGTaskScheduler.shared.getPendingTaskRequests { requests in
            if requests.isEmpty {
                print("No pending task requests found.")
            } else {
                print("Pending task requests after scheduling: \(requests)")
            }
        }
    } catch let error as BGTaskScheduler.Error {
        print("Failed to schedule todo archiving task: \(error.localizedDescription)")
        
        switch error.code {
        case .unavailable:
            print("BGTaskScheduler unavailable: \(error.localizedDescription)")
        case .tooManyPendingTaskRequests:
            print("Too many pending tasks: \(error.localizedDescription)")
        case .notPermitted:
            print("Not permitted to schedule tasks: \(error.localizedDescription)")
        default:
            print("Unknown error: \(error.localizedDescription)")
        }
    } catch {
        print("Unexpected error: \(error.localizedDescription)")
    }
}
