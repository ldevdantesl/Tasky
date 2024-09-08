//
//  DataAndStorageView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 22.08.2024.
//

import SwiftUI

struct DataAndStorageView: View {
    @ObservedObject var settingsManagerVM: SettingsManagerViewModel
    @ObservedObject var todoVM: TodoViewModel
    
    @Binding var path: NavigationPath
    
    @State private var archiveAllTodosAlert: Bool = false
    @State private var deleteAllTodosAlert: Bool = false
    @State private var clearCacheAlert: Bool = false
    
    var colorTheme: Color {
        settingsManagerVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    var autoArchiveAfter: Int {
        settingsManagerVM.settingsManager.dataAndStorageManager.archiveAfterDays
    }
    
    var body: some View {
        ScrollView{
            SettingsRowComponent(title: "Archived Todos", subtitle: "Show all Archived Todos", image: "archivebox.fill", color: .blue.opacity(0.8), link: "ArchivedTodosView", path: $path)
                .padding(.top, 10)
            
            SettingsRowComponent(title: "Removed Todos", subtitle: "Show all Removed Todos", image: "trash.fill", color: .red.opacity(0.8), link: "RemovedTodosView", path: $path)
            SettingsRowComponent(title: "Clear Cache", subtitle: "Clear all the Cache", image: "doc.zipper", color: .pink, toggler: $clearCacheAlert)
                
            SettingsRowComponent(title: "Auto-Archive After: \(autoArchiveAfter)", subtitle: "Arvchive completed Todos after: \(autoArchiveAfter) days", image: "autostartstop", color: .green.opacity(0.8), isDropDown: $settingsManagerVM.settingsManager.dataAndStorageManager.archiveAfterDays, dropDownVariations: [5,10,15,20])
                
        }
        
        .navigationTitle("Data & Storage")
        .navigationBarTitleDisplayMode(.inline)
        .background(Constants.backgroundColor)
        .alert("Clear the Cache", isPresented: $clearCacheAlert) {
            Button("Clear", role: .destructive, action: settingsManagerVM.settingsManager.dataAndStorageManager.clearCache)
        } message: {
            Text("Do you want to clear all the cache?")
        }

    }
}

#Preview {
    NavigationStack{
        DataAndStorageView(settingsManagerVM: MockPreviews.viewModel, todoVM: TodoViewModel(), path: .constant(NavigationPath()))
    }
}
