//
//  SettingsView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 21.08.2024.
//

import SwiftUI
import UIKit

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var todoVM: TodoViewModel
    @ObservedObject private var settingsMgrVM: SettingsManagerViewModel
    
    init(todoVM: TodoViewModel, settingsMgrVM: SettingsManagerViewModel) {
        self.todoVM = todoVM
        self.settingsMgrVM = settingsMgrVM
    }
    
    var body: some View {
        Form{
            // MARK: - TAGS
            Section{
                rowSettings(name: "Tags", imageName: "number", color: .green) {
                    Text("Tags")
                }
            }
            
            // MARK: - DATA, NOTIFICATION AND PRIVACY
            Section{
                rowSettings(name: "Data and Storage", imageName: "folder.fill.badge.gearshape", color: .mint){
                    DataAndStorageView(settingsManagerVM: settingsMgrVM, todoVM: todoVM)
                }
                rowSettings(name: "Notification and Sounds", imageName: "bell.badge.fill", color: .red){
                    NotificationAndSoundsView(settingsMgrVM: settingsMgrVM)
                }
                rowSettings(name: "Privacy and Security", imageName: "lock.shield.fill", color: .gray){
                    PrivacySecuritySettingsView(settingsMgrVM: settingsMgrVM)
                }
            }
            
            // MARK: - LANGUAGE AND APPEARANCE
            Section{
                rowForLanguage()
                rowSettings(name: "Appearance", imageName: "circle.lefthalf.filled", color: .brown){
                    Text("Notification Settings")
                }
            }
            
            // MARK: - FAQ
            Section{
                rowSettings(name: "FAQ", imageName: "questionmark.circle", color: .teal) {
                    Text("")
                }
            }
        }
        .navigationTitle("Settings")
    }
    
    @ViewBuilder
    func header() -> some View {
        HStack{
            Text("Settings")
                .font(.system(.title, design: .rounded, weight: .semibold))
                .foregroundStyle(.primary)
            Spacer()
            Image(systemName: "xmark")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 20)
                .bold()
                .foregroundStyle(.red)
                .onTapGesture {
                    dismiss()
                }
        }
    }
    @ViewBuilder
    func rowSettings(name: LocalizedStringKey, imageName: String,color: Color, destination: () -> some View) -> some View {
        NavigationLink(destination: destination){
            HStack{
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 20)
                    .frame(maxHeight: 20)
                    .foregroundStyle(color)
                Text(name)
                Spacer()
                
            }
        }
    }
    @ViewBuilder
    func rowForLanguage() -> some View{
        HStack{
            Image(systemName: "globe")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 20, maxHeight: 20)
                .foregroundStyle(.blue)
            Text("Language")
            Spacer()
            Text(settingsMgrVM.currentLanguage.localizeLanguageCode()?.capitalized ?? "English")
                .font(.system(.subheadline, design: .rounded, weight: .light))
        }
        .onTapGesture(perform: openSettings)
    }
    
    func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}

#Preview {
    NavigationStack{
        SettingsView(todoVM: TodoViewModel(), settingsMgrVM: MockPreviews.viewModel)
    }
}
