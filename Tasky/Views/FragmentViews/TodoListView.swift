//
//  TodoListView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 30.08.2024.
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject var settingsMgrVM: SettingsManagerViewModel
    @EnvironmentObject var todoVM: TodoViewModel
    @EnvironmentObject var tagVM: TagViewModel
    @EnvironmentObject var navpath: NavPathManager

    @Binding var isShowingActive: Bool
    
    var colorTheme: Color {
        settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    var doneTodos: [Todo] {
        return todoVM.todayTodos.filter { $0.isDone }
    }
    
    var activeTodos: [Todo] {
        todoVM.todayTodos.filter { $0.isDone == false }
    }
    
    var body: some View {
        if !todoVM.todayTodos.isEmpty{
            if isShowingActive {
                TodoListFragmentView(todos: activeTodos, tapAction: tapAction, doubleTapAction: doubleTapAction, noFoundImage: "checkmark.circle.fill", noFoundColor: colorTheme, noFoundTitle: "No active todos for this day", noFoundSubtitle: "You don't have any active todos for this day. Tap to see done") {
                    isShowingActive = false
                }
            } else {
                TodoListFragmentView(todos: doneTodos, tapAction: tapAction, doubleTapAction: doubleTapAction, noFoundImage: "checklist", noFoundColor: colorTheme, noFoundTitle: "Nothing is done for this day", noFoundSubtitle: "You don't have done todos for this day. Tap to see active") {
                    isShowingActive = true
                }
            }
        } else {
            NoFoundComponentView(image: "plus.circle.fill", color: colorTheme, title: "No todos for this day", subtitle: "You don't have any todos for this day. Tap to add") {
                navpath.path.append("AddTodoView")
            }
            .padding(.top, Constants.screenHeight / 5)
        }
    }
    
    func tapAction(todo: Todo) {
        navpath.path.append(todo)
    }
    
    func doubleTapAction(todo: Todo){
        withAnimation {
            todo.isDone ? todoVM.uncompleteTodo(todo) : todoVM.completeTodo(todo)
        }
    }
}

#Preview {
    NavigationStack{
        TodoListView(isShowingActive: .constant(true))
    }
}
