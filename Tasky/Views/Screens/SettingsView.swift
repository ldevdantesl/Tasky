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
    @ObservedObject var tagVM: TagViewModel
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    @State private var showSettingsTag: Bool = false
    
    var body: some View {
        Form{
            // MARK: - TAGS
            Section{
                rowSettings(name: tagVM.tags.count > 0 ? "Tags" : "No tags yet", imageName: "number", color: .green) {
                    TagSettingsView(tagVM: tagVM, settingsManagerVM: settingsMgrVM)
                }
                .disabled(tagVM.tags.count > 0 ? false : true)
            }
            .sheet(isPresented: $showSettingsTag){
                TagSettingsView(tagVM: tagVM, settingsManagerVM: settingsMgrVM)
                    .presentationDetents([.medium, .large])
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
                rowWithAction(title: "Language", systemImage: "globe", color: .blue, rightSideKey: settingsMgrVM.currentLanguage.localizeLanguageCode(), action:openSettings)
                
                rowSettings(name: "Appearance", imageName: "circle.lefthalf.filled", color: .brown){
                    AppearanceView(settingsManagerVM: settingsMgrVM)
                }
            }
            
            // MARK: - FAQ
            Section{
                rowSettings(name: "FAQ", imageName: "questionmark.circle", color: .teal) {
                    FAQView()
                }
                rowWithAction(title: "Write a review", systemImage: "star", color: .pink, action: openAppStore)
            
                ShareLink(item: URL(string:"https://apps.apple.com/app/idMYAPP_ID")!, subject: Text("Hey checkout this app.")) {
                    HStack{
                        Image(systemName: "arrowshape.turn.up.right.fill")
                            .foregroundStyle(.yellow)
                        Text("Share").foregroundStyle(.black)
                    }
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
            }
        }
    }
    
    @ViewBuilder
    func rowWithAction(title: LocalizedStringKey, systemImage: String, color: Color, rightSideKey: String? = nil, action: @escaping () -> ()) -> some View{
        Button(action: action){
            HStack{
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 20, maxHeight: 20)
                    .foregroundStyle(color)
                Text(title)
                Spacer()
                if let rightSideKey{
                    Text("\(rightSideKey.capitalized)")
                        .font(.system(.subheadline, design: .rounded, weight: .light))
                }
            }
            .tint(.primary)
        }
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
        SettingsView(todoVM: TodoViewModel(), tagVM: TagViewModel(), settingsMgrVM: MockPreviews.viewModel)
    }
}
