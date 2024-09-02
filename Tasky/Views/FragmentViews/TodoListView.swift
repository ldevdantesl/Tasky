//
//  TodoListView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 30.08.2024.
//

import SwiftUI

struct TodoListView: View {
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    @ObservedObject var todoVM: TodoViewModel
    @ObservedObject var tagVM: TagViewModel

    @Binding var path: NavigationPath

    @Binding var isShowingActive: Bool
    
    var doneTodos: [Todo]{
        return todoVM.todos.filter { $0.isDone }
    }
    var activeTodos: [Todo] {
        todoVM.todos.filter { $0.isDone == false }
    }
    
    var todos: [Todo]{
        isShowingActive ? activeTodos : doneTodos
    }
    
    var body: some View {
        if todoVM.todos.isEmpty, #available(iOS 17.0, *) {
            Text("You don't have any tasks.")
        } else {
            ScrollView{
                ForEach(todos, id: \.self){ todo in
                    TodoRowView(todo: todo, settingsManagerVM: settingsMgrVM, todoVM: todoVM)
                        .onTapGesture {
                            path.append(todo)
                        }
                }
            }
            .navigationDestination(for: Todo.self){ todo in
                TodoDetailView(observedTodo: todo, todoVM: todoVM, tagVM: tagVM, settingsManagerVM: settingsMgrVM)
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    NavigationStack{
        TodoListView(settingsMgrVM: MockPreviews.viewModel, todoVM: TodoViewModel(), tagVM: TagViewModel(), path: .constant(NavigationPath()), isShowingActive: .constant(true))
    }
}
