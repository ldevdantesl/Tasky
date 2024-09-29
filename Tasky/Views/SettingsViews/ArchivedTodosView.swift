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
    
    var archivedFilteredResults: [Todo] {
        if searchText.isEmpty{
            return todoVM.archivedTodos
        } else {
            return todoVM.archivedTodos.filter { $0.title!.localizedStandardContains(searchText)}
        }
    }
    
    var body: some View {
        ScrollView{
            TodoListFragmentView(todoVM: todoVM, todos: archivedFilteredResults, tapAction: onTapAction, doubleTapAction: onDoubleTapAction, noFoundImage: "archivebox.fill", noFoundColor: .green, noFoundTitle: "No archived Todos", noFoundSubtitle: "You don't have archived Todos, archive any to see it here")
        }
        .searchable(text: $searchText)
        .toolbar {
            if !todoVM.archivedTodos.isEmpty{
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
    
    func onTapAction(todo: Todo) {
        path.append(todo)
    }
    func onDoubleTapAction(todo: Todo){
        todoVM.unArchive(todo)
    }
}

#Preview {
    NavigationStack{
        ArchivedTodosView(todoVM: TodoViewModel(), settingsMgrVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
    }
}
