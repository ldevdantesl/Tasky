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
            HStack{
                Text("No todos for this day.")
                    .font(.system(.headline, design: .rounded, weight: .regular))
                Text("Add Todo")
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundStyle(colorTheme)
                    .onTapGesture {
                        path.append("AddTodoView")
                    }
                Spacer()
            }
        } else if isShowingActive && activeTodos.isEmpty {
            HStack{
                Text("No active todos for this day.")
                    .font(.system(.headline, design: .rounded, weight: .regular))
                Text("See Completed")
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundStyle(colorTheme)
                    .onTapGesture {
                        withAnimation {
                            isShowingActive = false
                        }
                    }
                Spacer()
            }
        } else if !isShowingActive && doneTodos.isEmpty {
            HStack{
                Text("Nothing is done for this day.")
                    .font(.system(.headline, design: .rounded, weight: .regular))
                Text("See Active")
                    .foregroundStyle(colorTheme)
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .onTapGesture {
                        withAnimation {
                            isShowingActive = true
                        }
                    }
                Spacer()
            }
            
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
