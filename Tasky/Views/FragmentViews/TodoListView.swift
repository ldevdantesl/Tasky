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
    
    var colorTheme: Color {
        settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    var doneTodos: [Todo]{
        return todoVM.todayTodos.filter { $0.isDone }
    }
    var activeTodos: [Todo] {
        todoVM.todayTodos.filter { $0.isDone == false }
    }
    
    var todos: [Todo]{
        isShowingActive ? activeTodos : doneTodos
    }
    
    var body: some View {
        if todoVM.todayTodos.isEmpty{
            NoFoundComponentView(image: "plus.circle.fill", color: colorTheme, title: "No todos for this day", subtitle: "You don't have any todos for this day. Tap to add") {
                path.append("AddTodoView")
            }
            .padding(.top, Constants.screenHeight / 6)
        
        } else if isShowingActive && activeTodos.isEmpty {
            NoFoundComponentView(image: "checkmark.circle.fill", color: colorTheme, title: "No active todos for this day", subtitle: "You don't have any active todos for this day. Tap to see done") {
                isShowingActive = false
            }
            .padding(.top, Constants.screenHeight / 6)
        } else if !isShowingActive && doneTodos.isEmpty {
            NoFoundComponentView(image: "checklist", color: colorTheme, title: "Nothing is done for this day", subtitle: "You don't have done todos for this day. Tap to see active") {
                isShowingActive = true
            }
            .padding(.top, Constants.screenHeight / 6)
        } else {
            LazyVStack{
                ForEach(todos, id: \.self){ todo in
                    TodoRowView(todo: todo, settingsManagerVM: settingsMgrVM, todoVM: todoVM)
                    .onTapGesture {
                        path.append(todo)
                    }
                }
            }
            .navigationDestination(for: Todo.self){ todo in
                TodoDetailView(observedTodo: todo, todoVM: todoVM, tagVM: tagVM, settingsManagerVM: settingsMgrVM, path: $path)
            }
        }
    }
}

#Preview {
    NavigationStack{
        TodoListView(settingsMgrVM: MockPreviews.viewModel, todoVM: TodoViewModel(), tagVM: TagViewModel(), path: .constant(NavigationPath()), isShowingActive: .constant(true))
    }
}
