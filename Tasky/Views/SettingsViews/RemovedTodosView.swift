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
    @State private var searchText: String = ""
    
    var removedFilteredTodos: [Todo] {
        if searchText.isEmpty {
            return todoVM.removedTodos
        } else {
            return todoVM.removedTodos.filter { $0.title!.localizedStandardContains(searchText) }
        }
    }
    
    var body: some View {
        ScrollView{
            TodoListFragmentView(todoVM: todoVM, todos: removedFilteredTodos, tapAction: onTapAction, doubleTapAction: onDoubleTapAction, noFoundImage: "trash.fill", noFoundColor: .red, noFoundTitle: "No deleted todos", noFoundSubtitle: "You don't have deleted Todos, delete any to see it here")
        }
        .searchable(text: $searchText)
        .scrollIndicators(.hidden)
        .toolbar{
            if !todoVM.removedTodos.isEmpty {
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
    
    func onTapAction(todo: Todo) {
        path.append(todo)
    }
    
    func onDoubleTapAction(todo:Todo) {
        todoVM.unRemoveTodo(todo)
    }
}

#Preview {
    NavigationStack{
        RemovedTodosView(todoVM: TodoViewModel(), settingsMgrVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
    }
}

