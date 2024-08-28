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
    @State private var archiveAllTodosAlert: Bool = false
    @State private var deleteAllTodosAlert: Bool = false
    @State private var clearCacheAlert: Bool = false

    let archivedAfterArray = [10, 15, 20, 25, 30]
    
    var body: some View {
        Form{
            Section{
                NavigationLink(destination: ArchivedTodosView(todoVM: todoVM)) {
                    rowLabel(imageName: "archivebox", title: "Archived Todos", headline: "All todos that have been archived", color: .purple)
                }
                NavigationLink(destination: RemovedTodosView(todoVM: todoVM)){
                    rowLabel(imageName: "trash", title: "Removed Todos", headline: "All todos that have been removed", color: .red)
                }
            }
            
            Section {
                Button(action: {clearCacheAlert.toggle()}){
                    rowLabel(imageName: "doc.zipper", title: "Clear Cache", headline: "Clean up cache storage", color: .cyan)
                }
            }
            .alert("Clear Cache", isPresented: $clearCacheAlert) {
                Button("Clear",role:.destructive){
                    settingsManagerVM.settingsManager.dataAndStorageManager.clearCache()
                }
            } message: {
                Text("Do you really want to clear all the cache?")
            }

            
            Section{
                Button(action: {archiveAllTodosAlert.toggle()}){
                    rowLabel(imageName: "archivebox.circle", title: "Archive Todos", headline: "Archive all current todos", color: .brown)
                }
                
                Button(action: {deleteAllTodosAlert.toggle()}){
                    rowLabel(imageName: "trash.circle", title: "Remove Todos", headline: "Remove all current todos", color: .red)
                }
            }
            .alert("Archive all Todos", isPresented: $archiveAllTodosAlert) {
                Button("Archive", role: .destructive) {
                    settingsManagerVM.settingsManager.dataAndStorageManager.archiveTodos()
                }
            } message: {
                Text("Do you really want to archive all current Todos")
            }
            
            Section{
                Toggle(isOn: $settingsManagerVM.settingsManager.dataAndStorageManager.isArchiveAfterCompletionEnabled){
                    rowLabel(imageName: "autostartstop", title: "Archive Todos after completion", headline: "Archive todo after completion", color: .blue)
                }
                if settingsManagerVM.settingsManager.dataAndStorageManager.isArchiveAfterCompletionEnabled{
                    Picker(selection: $settingsManagerVM.settingsManager.dataAndStorageManager.archiveAfterDays) {
                        ForEach(archivedAfterArray, id: \.self) { day in
                            Text("\(day)")
                                .tag(day)
                        }
                    } label: {
                        rowLabel(imageName: "tray.and.arrow.down.fill", title: "Archive After: \(settingsManagerVM.settingsManager.dataAndStorageManager.archiveAfterDays) days", headline: "Archive todos that are done after \(settingsManagerVM.settingsManager.dataAndStorageManager.archiveAfterDays) days", color: .blue)
                    }
                    .pickerStyle(.navigationLink)

                }
            }
            .alert("Remove all Todos", isPresented: $deleteAllTodosAlert) {
                Button("Delete", role: .destructive) {
                    settingsManagerVM.settingsManager.dataAndStorageManager.deleteTodos()
                }
            } message: {
                Text("Do you really want to remove all current Todos?")
            }

        }
        .navigationTitle("Data and Storage")
        .navigationBarTitleDisplayMode(.inline)
    }
    @ViewBuilder
    func rowLabel(imageName: String, title: LocalizedStringKey, headline: LocalizedStringKey, color: Color) -> some View{
        HStack{
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 25, maxHeight: 25)
                .foregroundStyle(color)
            VStack(alignment: .leading){
                Text(title)
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                    .foregroundStyle(color)
                Text(headline)
                    .font(.system(.caption, design: .rounded, weight: .light))
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    NavigationStack{
        DataAndStorageView(settingsManagerVM: MockPreviews.viewModel, todoVM: TodoViewModel())
    }
}
