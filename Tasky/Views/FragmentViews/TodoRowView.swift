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
            ZStack(alignment:.topLeading){
                RoundedRectangle(cornerRadius: 25)
                    .fill(TodoViewHelpers(todo: todo).priorityColor.gradient.opacity(0.8))
                
                VStack(alignment:.leading){
                    
                    Text(todo.title ?? "Uknown title")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .lineLimit(1)
                    
                    Text(todo.desc ?? "No description")
                        .font(.system(.subheadline, design: .rounded, weight: .regular))
                    Spacer()
                    
                    HStack{
                        Group{
                            Text(todo.isDone ? "Done" : "Not Done")
                                .font(.system(.headline, design: .rounded, weight: .bold))
                            Image(systemName: todo.isDone ? "checkmark.circle.fill" : "xmark.circle.fill")
                        }
                        .padding(10)
                        .background(TodoViewHelpers(todo: todo).priorityColor.opacity(0.4), in:.capsule)

                        Spacer()
                        Text(TodoViewHelpers(todo: todo).formatDate())
                            .font(.system(.caption, design: .rounded, weight: .light))
                    }
                }
                .padding()
                .foregroundStyle(.white)
            
            }
            .frame(width: Constants.screenWidth - 20)
            .frame(minHeight: 130, maxHeight: 130)
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
