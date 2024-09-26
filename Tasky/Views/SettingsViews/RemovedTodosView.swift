//
//  RemovedTodosView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 24.08.2024.
//

import SwiftUI

struct RemovedTodosView: View {
    @ObservedObject var todoVM: TodoViewModel
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    
    @Binding var path: NavigationPath
    
    @State private var alertToggle: Bool = false
    @State private var deleteToggle = false
    
    var removedTodos: [Todo] {
        todoVM.removedTodos
    }
    
    var body: some View {
        ScrollView{
            TodoListFragmentView(todoVM: todoVM, todos: removedTodos, noFoundImage: "trash.fill", noFoundColor: .red, noFoundTitle: "No deleted todos", noFoundSubtitle: "You don't have deleted Todos, delete any to see it here")
        }
        .scrollIndicators(.hidden)
        .toolbar{
            if !removedTodos.isEmpty{
                ToolbarItem(placement: .topBarTrailing) {
                    HStack{
                        Button("Unremove All", systemImage: "trash.slash.fill", action: {alertToggle.toggle()})
                        Button("Delete All", systemImage: "trash.fill", action: {deleteToggle.toggle()})
                            .tint(.red)
                    }
                }
            }
        }
        .alert("Unremove All", isPresented: $alertToggle){
            Button("Unremove", role:.destructive, action: todoVM.unRemoveAll)
        } message: {
            Text("Do you really want to Unremove all?")
        }
        .alert("Delete All", isPresented: $deleteToggle){
            Button("Delete all", role:.destructive, action: todoVM.deleteAllRemovedTodos)
        } message: {
            Text("Do you really want to delete all removed Todos?")
        }
        .background(Color.background)
        .navigationTitle("Removed Todos")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack{
        RemovedTodosView(todoVM: TodoViewModel(), settingsMgrVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
    }
}

