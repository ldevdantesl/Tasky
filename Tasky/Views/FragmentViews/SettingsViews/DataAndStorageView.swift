//
//  DataAndStorageView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 22.08.2024.
//

import SwiftUI

struct DataAndStorageView: View {
    @StateObject var settingsManagerVM: SettingsManagerViewModel

    var body: some View {
        Form{
            Section{
                NavigationLink{
                    List{
                        ForEach(settingsManagerVM.settingsManager.dataAndStorageManager.fetchArchivedTodos(), id: \.self){ todo in
                            Text(todo.title ?? "No title")
                        }
                    }
                } label: {
                    rowLabel(imageName: "archivebox", title: "Archived Todos", headline: "All todos that have been archived", color: .purple)
                }
                NavigationLink{
                    List{
                        ForEach(settingsManagerVM.settingsManager.dataAndStorageManager.fetchDeletedTodos(), id: \.self){ todo in
                            Text(todo.title ?? "No title")
                        }
                    }
                } label: {
                    rowLabel(imageName: "trash", title: "Removed Todos", headline: "All todos that have been removed", color: .red)
                }
            }
            Section {
                Button(action: settingsManagerVM.settingsManager.dataAndStorageManager.clearCache){
                    rowLabel(imageName: "doc.zipper", title: "Clear Cache", headline: "Clean up cache storage", color: .cyan)
                }
            }
            Section{
                Button(action: settingsManagerVM.settingsManager.dataAndStorageManager.archiveTodos){
                    rowLabel(imageName: "archivebox.circle", title: "Archive Todos", headline: "Archive all current todos", color: .brown)
                }
                
                Button(action: settingsManagerVM.settingsManager.dataAndStorageManager.deleteTodos){
                    rowLabel(imageName: "trash.circle", title: "Delete Todos", headline: "Delete all current todos", color: .red)
                }
            }
            Section{
                Toggle(isOn: $settingsManagerVM.settingsManager.dataAndStorageManager.isArchiveAfterCompletionEnabled){
                    rowLabel(imageName: "autostartstop", title: "Archive Todos after completion", headline: "Archive todo after completion", color: .blue)
                }
            }
        }
        .navigationTitle("Data and Storage")
        .toolbarTitleDisplayMode(.inline)
    }
    @ViewBuilder
    func rowLabel(imageName: String, title: String, headline: String, color: Color) -> some View{
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
        DataAndStorageView(settingsManagerVM: MockPreviews.viewModel)
    }
}
