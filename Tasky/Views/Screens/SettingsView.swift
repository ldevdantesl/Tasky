//
//  SettingsView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 21.08.2024.
//

import SwiftUI
import UIKit

struct SettingsView: View {
    @ObservedObject var todoVM: TodoViewModel
    @ObservedObject var tagVM: TagViewModel
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    
    @Binding var path: NavigationPath
    
    var colorTheme: Color {
        settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    var body: some View {
        VStack{
            HStack{
                Text("Settings")
                    .font(.system(.title, design: .rounded, weight: .bold))
                Spacer()
            }
            .padding(.horizontal)
            
            SettingsRowComponent(title: "Tags", image: "number", color: .teal, link: "TagSettingsView", path: $path)
            
            SettingsRowComponent(title: "Data & Storage", image: "folder.fill", color: .yellow, link: "DataStorageSettingsView", path: $path)
            
            SettingsRowComponent(title: "Notification & Sound", image: "bell.fill", color: .blue.opacity(0.8), link: "NotificationSoundSettingsView", path: $path)
            
            SettingsRowComponent(title: "Privacy & Security", image: "checkerboard.shield", color: .red.opacity(0.8), link: "PrivacySecuritySettingsView", path: $path)
            
            SettingsRowComponent(title: "Appearance", image: "drop.degreesign.fill", color: .purple, link: "AppearanceSettingsView", path: $path)
            
            ShareAndFAQFragmentView()
            Spacer()
        }
        .background(Color.background)
        .safeAreaInset(edge: .bottom) {
            TabBarsComponent(settingsMgrVM: settingsMgrVM, todoVM: todoVM, tagVM:tagVM, path: $path)
        }
    }
}

#Preview {
    NavigationStack{
        SettingsView(todoVM: TodoViewModel(), tagVM: TagViewModel(), settingsMgrVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
    }
}
