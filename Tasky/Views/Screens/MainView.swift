//
//  ContentView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import SwiftUI
import LocalAuthentication

struct MainView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var settingsManagerVM: SettingsManagerViewModel
    @StateObject var todoVM: TodoViewModel = TodoViewModel()
    @StateObject var tagVM: TagViewModel = TagViewModel()
    @State var showAutenticationView: Bool = false
    
    init(){
        let todoViewModel = TodoViewModel()
        let settingsManager = SettingsManager(
            notificationSettingsManager: NotificationSettingsManager(),
            dataAndStorageManager: DataAndStorageManager(todoVM: todoViewModel),
            privacyAndSecurityManager: PrivacyAndSecuritySettingsManager(), appearanceSettingsManager: AppearanceSettingsManager()
        )
        // Initialize settingsManagerVM with the constructed settingsManager
        _settingsManagerVM = StateObject(wrappedValue: SettingsManagerViewModel(settingsManager: settingsManager))
        // Initialize todoVM and tagVM separately
        _todoVM = StateObject(wrappedValue: todoViewModel)
        _tagVM = StateObject(wrappedValue: TagViewModel())
    }
    
    var body: some View {
        TodoView(todoVM: todoVM, tagVM: tagVM, settingsMgrVM: settingsManagerVM)
            .blur(radius: blurView() ? 10 : 0)
            .blur(radius: showAutenticationView ? 20 : 0)
            .preferredColorScheme(settingsManagerVM.settingsManager.appearanceSettingsManager.colorScheme)
            .onAppear{
                if settingsManagerVM.settingsManager.privacyAndSecurityManager.useBiometrics {
                    showAutenticationView.toggle()
                }
            }
            .sheet(isPresented: $showAutenticationView){
                AuthenticateUserFragmentView(settingsManagerViewModel: settingsManagerVM, isAuthenticated: $showAutenticationView)
                    .presentationDetents([.medium])
                    .interactiveDismissDisabled()
            }
            .tint(settingsManagerVM.settingsManager.appearanceSettingsManager.colorTheme)
    }
    
    func blurView() -> Bool {
        let result = settingsManagerVM.settingsManager.privacyAndSecurityManager.lockWhenBackgrounded && scenePhase == .inactive
        return result
    }
}

#Preview {
    MainView()
}
