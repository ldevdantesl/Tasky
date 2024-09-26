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
    
    @State private var alertToggle: Bool = false
    @State private var searchText: String = ""
    
    var archivedTodos: [Todo] {
        return todoVM.archivedTodos
    }
    
    var body: some View {
        ScrollView{
            TodoListFragmentView(todoVM: todoVM, todos: archivedTodos, noFoundImage: "archivebox.fill", noFoundColor: .green, noFoundTitle: "No archived Todos", noFoundSubtitle: "You don't have archived Todos, archive any to see it here", noFoundAction: nil)
        }
        .toolbar {
            if !archivedTodos.isEmpty{
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Archive", systemImage: "archivebox.fill") {
                        alertToggle.toggle()
                    }
                }
            }
        }
        .alert("Unarchive All", isPresented: $alertToggle){
            Button("Unarchive", role:.destructive, action: todoVM.unArchiveAll)
        } message: {
            Text("Do you really want to Unarchive all?")
        }
        .background(Color.background)
        .scrollIndicators(.hidden)
        .navigationTitle("Archived Todos")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack{
        ArchivedTodosView(todoVM: TodoViewModel(), settingsMgrVM: MockPreviews.viewModel)
    }
}
