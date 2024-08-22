//
//  SettingsView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 21.08.2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
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
                    DataAndStorageView()
                }
                rowSettings(name: "Notification and Sounds", imageName: "bell.badge.fill", color: .red){
                    NotificationAndSoundsView()
                }
                rowSettings(name: "Privacy and Security", imageName: "lock.shield.fill", color: .gray){
                    Text("Notification Settings")
                }
            }
            
            // MARK: - LANGUAGE AND APPEARANCE
            Section{
                rowSettings(name: "Language", imageName: "globe", color: .purple){
                    Text("Notification Settings")
                }
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
    func rowSettings(name: String, imageName: String,color: Color, destination: () -> some View) -> some View {
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
}

#Preview {
    NavigationStack{
        SettingsView()
    }
}
