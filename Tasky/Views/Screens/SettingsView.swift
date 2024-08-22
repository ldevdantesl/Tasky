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
            header()
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets.init(top: -10, leading: 10, bottom: 10, trailing: 10))
        
            Section{
                rowSettings(name: "Tags", imageName: "number", color: .green) {
                    Text("Tags")
                }
            }
            
            Section{
                rowSettings(name: "Data and Storage", imageName: "folder.fill.badge.gearshape", color: .mint){
                    Text("Data Management")
                }
                rowSettings(name: "Notification and Sounds", imageName: "bell.badge.fill", color: .red){
                    Text("Notification Settings")
                }
                rowSettings(name: "Privacy and Security", imageName: "lock.shield.fill", color: .gray){
                    Text("Notification Settings")
                }
            }
            Section{
                rowSettings(name: "Language", imageName: "globe", color: .purple){
                    Text("Notification Settings")
                }
                rowSettings(name: "Appearance", imageName: "circle.lefthalf.filled", color: .brown){
                    Text("Notification Settings")
                }
            }
            Section{
                rowSettings(name: "FAQ", imageName: "questionmark.circle", color: .teal) {
                    Text("")
                }
            }
        }
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
