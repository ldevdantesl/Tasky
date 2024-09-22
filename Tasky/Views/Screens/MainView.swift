//
//  ContentView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import SwiftUI
import LocalAuthentication

struct MainView: View {
    @AppStorage("isFirstEntry") var isFirstEntry: Bool = true
    
    @Environment(\.scenePhase) var scenePhase
    
    @ObservedObject var todoVM: TodoViewModel
    
    @StateObject var settingsManagerVM: SettingsManagerViewModel
    @StateObject var tagVM: TagViewModel = TagViewModel()
    
    @State var showAutenticationView: Bool = false
    @State var showLaunchScreen: Bool = true
    
    init(todoVM: TodoViewModel){
        self.todoVM = todoVM
        
        let settingsManager = SettingsManager(
            notificationSettingsManager: NotificationSettingsManager(),
            dataAndStorageManager: DataAndStorageManager(),
            privacyAndSecurityManager: PrivacyAndSecuritySettingsManager(),
            appearanceSettingsManager: AppearanceSettingsManager()
        )
        
        _settingsManagerVM = StateObject(wrappedValue: SettingsManagerViewModel(settingsManager: settingsManager))
    }
    
    var body: some View {
        if showLaunchScreen{
            LaunchScreen()
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            self.showLaunchScreen = false
                        }
                    }
                }
        } else if isFirstEntry {
            AppIntroScreen()
                .onAppear{
                    Task{
                        do {
                            try tagVM.createTag("Work", color: .purple, systemImage: "bag.fill")
                            try tagVM.createTag("Personal", color: .yellow, systemImage: "person")
                            let _ = try await todoVM.createTodo(title: "Explore the app", description: "Explore the Tasky app for myself. Be excited.", priority: 1, dueDate: .now, tags: tagVM.tags)
                            
                            let _ = try await todoVM.createTodo(title: "Create CV", description: nil, priority: 2, dueDate: .now, tags: [tagVM.tags[0]], isSaved: true)
                        } catch {
                            print("Error creating new todos for the new user.")
                        }
                    }
                }
        } else {
            TodoView(todoVM: todoVM, tagVM: tagVM, settingsMgrVM: settingsManagerVM)
                .blur(radius: blurView() ? 10 : 0)
                .blur(radius: showAutenticationView ? 20 : 0)
                .preferredColorScheme(settingsManagerVM.settingsManager.appearanceSettingsManager.colorScheme)
                .onAppear {
                    if settingsManagerVM.settingsManager.privacyAndSecurityManager.useBiometrics {
                        showAutenticationView.toggle()
                    }
                    Task{
                        await todoVM.archiveOldCompletedTodos()
                    }
                }
                .sheet(isPresented: $showAutenticationView) {
                    AuthenticateUserFragmentView(settingsManagerViewModel: settingsManagerVM, isAuthenticated: $showAutenticationView)
                        .presentationDetents([.medium])
                        .interactiveDismissDisabled()
                }
                .tint(settingsManagerVM.settingsManager.appearanceSettingsManager.colorTheme)
                .onAppear {
                    settingsManagerVM.settingsManager.notificationSettingsManager.requestAuthorizationPermission()
                }
        }
    }
    
    func blurView() -> Bool {
        return settingsManagerVM.settingsManager.privacyAndSecurityManager.lockWhenBackgrounded && scenePhase == .inactive
    }
}

#Preview {
    MainView(todoVM: TodoViewModel())
}
