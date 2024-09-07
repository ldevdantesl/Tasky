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
    @State private var showSettingsTag: Bool = false
    
    var colorTheme: Color {
        settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    var body: some View {
        VStack(spacing: 20){
            SettingsHeaderComponent(settingsMgrVM: settingsMgrVM, path: $path, title: "Settings", buttonItems: [.init(systemImage: "questionmark.circle", color: colorTheme, action: {})], showingBackButton: false)
            SettingsRowComponent(title: "Tags", image: "number", color: .teal, link: "TagSettingsView", path: $path)
            SettingsRowComponent(title: "Data & Storage", image: "folder.fill", color: .yellow, link: "DataStorageSettingsView", path: $path)
            SettingsRowComponent(title: "Notification & Sound", image: "bell.fill", color: .blue.opacity(0.8), link: "NotificationSoundSettingsView", path: $path)
            SettingsRowComponent(title: "Privacy & Security", image: "checkerboard.shield", color: .red.opacity(0.8), link: "PrivacySecuritySettingsView", path: $path)
            SettingsRowComponent(title: "Appearance", image: "drop.degreesign.fill", color: .purple, link: "AppearanceSettingsView", path: $path)
            
            HStack{
                Capsule().fill(Color.gray)
                    .frame(width: Constants.screenWidth / 2.7, height: 55)
                    .overlay{
                        HStack(spacing: 10){
                            Image(systemName: "paperplane")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.white)
                            Text("Share")
                                .font(.system(.title2, design: .rounded, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                Circle().fill(Color.gray)
                    .frame(width: 55, height: 55)
                    .overlay {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.yellow)
                    }
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                
                Spacer()
            }
            .padding(.top, 10)
            Spacer()
        }
        .toolbar{
            ToolbarItem(placement: .bottomBar) {
                TabBarsComponent(settingsMgrVM: settingsMgrVM, todoVM: todoVM, tagVM: tagVM, path: $path)
                    .padding(.horizontal,20)
            }
        }
        .padding(.horizontal, 20)
    }
    
    func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    func openAppStore() {
        let appID = "IDK_YET"
        if let url = URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                print("Cant open app store with provided url")
            }
        }
    }
}

#Preview {
    NavigationStack{
        SettingsView(todoVM: TodoViewModel(), tagVM: TagViewModel(), settingsMgrVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
    }
}
