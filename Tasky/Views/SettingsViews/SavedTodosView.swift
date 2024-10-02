//
//  SavedTodosView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 11.09.2024.
//

import SwiftUI

struct SavedTodosView: View {
    @EnvironmentObject var todoVM: TodoViewModel
    @EnvironmentObject var settingsMgrVM: SettingsManagerViewModel
    @EnvironmentObject var navpath: NavPathManager
    
    @State private var alertToggle: Bool = false
    @State private var searchText: String = ""
    
    var savedFilteredTodos: [Todo] {
        if searchText.isEmpty{
            return todoVM.savedTodos
        } else {
            return todoVM.savedTodos.filter { $0.title!.localizedStandardContains(searchText) }
        }
    }
    
    var body: some View {
        ScrollView{
            TodoListFragmentView(todos: savedFilteredTodos, tapAction: tapAction, noFoundImage: "bookmark.fill", noFoundColor: .green, noFoundTitle: "No Saved Todos", noFoundSubtitle: "You don't have saved Todos, save any to see it here")
        }
        .searchable(text: $searchText)
        .background(Color.background)
        .scrollIndicators(.hidden)
        .navigationTitle("Saved Todos")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func tapAction(todo: Todo) {
        navpath.path.append(todo)
    }
}

#Preview {
    NavigationStack{
        SavedTodosView()
    }
}
