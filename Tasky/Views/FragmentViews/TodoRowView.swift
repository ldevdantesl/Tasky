//
//  TodoListView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 30.08.2024.
//

import SwiftUI

struct TodoRowView: View {
    
    @State var todo: Todo
    @AppStorage("isBoxStyle") var isBoxStyle: Bool = false
    
    @ObservedObject var settingsManagerVM: SettingsManagerViewModel
    @ObservedObject var todoVM: TodoViewModel
    
    var body: some View {
        if !isBoxStyle{
            VStack(alignment:.leading, spacing:5){
                Text(todo.title ?? "Uknown title")
                    .foregroundStyle(todo.isDone ? .gray : .primary)
                TagsForTodoView(todo: todo, settingsManagerVM: settingsManagerVM)
                
            }
            .swipeActions(edge:.leading, allowsFullSwipe: true){
                if !todo.isDone{
                    Button("Done", systemImage: "checkmark.circle"){
                        withAnimation {
                            todoVM.completeTodo(todo)
                        }
                    }
                    .tint(.green)
                } else {
                    Button("Undone", systemImage: "xmark.circle"){
                        withAnimation {
                            todoVM.uncompleteTodo(todo)
                        }
                    }
                    .tint(.gray)
                }
                Button("Archive", systemImage: "archivebox"){
                    withAnimation {
                        todoVM.archive(todo)
                    }
                }
                    .tint(.purple)
            }
        } else {
            ZStack{
                RoundedRectangle(cornerRadius: 25)
                    .fill(TodoViewHelpers(todo: todo).priorityColor.gradient.opacity(0.8))
                    .frame(width: Constants.screenWidth / 2 - 30, alignment: .topLeading)
                    .frame(minHeight: 80, maxHeight: 100)
                
                VStack(alignment:.leading){
                    HStack{
                        Text(todo.title ?? "Uknown title")
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .lineLimit(2)
                        Spacer()
                        Image(systemName: todo.isDone ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 20, maxHeight: 30)
                    }
                    
                    Text(TodoViewHelpers(todo: todo).formatDate())
                        .font(.system(.caption, design: .rounded, weight: .light))
                    
                }
                .padding(.horizontal, 10)
                .foregroundStyle(.white)
            
            }
            .frame(width: Constants.screenWidth / 2 - 30, alignment: .topLeading)
            .frame(minHeight: 80, maxHeight: 100)
            .contextMenu {
                Button(todo.isDone ? "Uncomplete" : "Complete", systemImage: todo.isDone ? "xmark.circle.fill" : "checkmark.circle.fill"){
                    withAnimation {
                        todo.isDone ? todoVM.uncompleteTodo(todo) : todoVM.completeTodo(todo)
                    }
                }
                Button("Delete", systemImage: "trash"){
                    withAnimation {
                        todoVM.removeTodo(todo)
                    }
                }
                Button("Archive", systemImage:"archivebox"){
                    withAnimation {
                        todoVM.archive(todo)
                    }
                }
            }
        }
    }
}

#Preview {
    TodoRowView(todo: TodoViewModel.mockToDo(), settingsManagerVM: MockPreviews.viewModel, todoVM: TodoViewModel())
}
