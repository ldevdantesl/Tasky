//
//  ArchivedOrRemovedView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 24.08.2024.
//

import SwiftUI

struct ArchivedTodosView: View {
    @ObservedObject var todoVM: TodoViewModel
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    
    @Binding var path: NavigationPath
    
    @State private var alertToggle: Bool = false
    @State private var searchText: String = ""
    
    var archivedTodos: [Todo] {
        return todoVM.archivedTodos
    }
    
    var body: some View {
        VStack{
            SettingsHeaderComponent(settingsMgrVM: settingsMgrVM, path: $path, title: "Archived Todos", buttonItems: [ButtonItem(systemImage: "archivebox", color: .blue, action: {
                alertToggle.toggle()
            })])
            .padding(.horizontal, 10)
            if !archivedTodos.isEmpty{
                ScrollView{
                    ForEach(archivedTodos){ todo in
                        TodoRowView(todo: todo, settingsManagerVM: settingsMgrVM, todoVM: todoVM)
                    }
                }
                .scrollIndicators(.hidden)
            } else {
                VStack{
                    Spacer()
                    Image(systemName: "archivebox.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.green)
                    Text("No archived Todos")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                    Text("You don't have archived Todos, archive any to see it here")
                        .font(.system(.caption, design: .rounded, weight: .light))
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
        }
        .alert("Unarchive All", isPresented: $alertToggle){
            Button("Unarchive", role:.destructive, action: todoVM.unArchiveAll)
        } message: {
            Text("Do you really want to Unarchive all?")
        }
    }
}

#Preview {
    NavigationStack{
        ArchivedTodosView(todoVM: TodoViewModel(), settingsMgrVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
    }
}
