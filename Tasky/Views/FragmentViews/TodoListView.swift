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
            VStack{
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(colorTheme)
                Text("No todos for this day")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                Text("You don't have any todos for this day. Tap to add")
                    .font(.system(.caption, design: .rounded, weight: .light))
                    .foregroundStyle(.secondary)
            }
            .padding(.top, Constants.screenHeight / 6)
            .onTapGesture {
                path.append("AddTodoView")
            }
        } else if isShowingActive && activeTodos.isEmpty {
            VStack{
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(colorTheme)
                Text("No active todos for this day")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                Text("You don't have any active todos for this day. Tap to see done")
                    .font(.system(.caption, design: .rounded, weight: .light))
                    .foregroundStyle(.secondary)
            }
            .padding(.top, Constants.screenHeight / 6)
            .onTapGesture {
                withAnimation {
                    isShowingActive = false
                }
            }
        } else if !isShowingActive && doneTodos.isEmpty {
            VStack{
                Image(systemName: "checklist")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(colorTheme)
                Text("Nothing is done for this day.")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                Text("You don't have done todos for this day. Tap to see active")
                    .font(.system(.caption, design: .rounded, weight: .light))
                    .foregroundStyle(.secondary)
            }
            .onTapGesture {
                withAnimation {
                    isShowingActive = true
                }
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
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    NavigationStack{
        TodoListView(settingsMgrVM: MockPreviews.viewModel, todoVM: TodoViewModel(), tagVM: TagViewModel(), path: .constant(NavigationPath()), isShowingActive: .constant(true))
    }
}
