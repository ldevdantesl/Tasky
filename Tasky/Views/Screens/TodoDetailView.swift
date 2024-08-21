//
//  TodoDetailView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import SwiftUI

struct TodoDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject private var todoVM = TodoViewModel()
    
    @State private var showAlert: Bool = false
    @State private var showEditView: Bool = false
    
    let todo: Todo
    
    var body: some View {
        ScrollView{
            HStack{
                Image(systemName: "flag.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 25)
                    .frame(maxHeight: 25)
                    .foregroundStyle(TodoViewHelpers(todo: todo).priorityColor)
                
                Text(todo.title ?? "No title")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .frame(maxWidth: Constants.screenWidth - 30, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                Spacer()
            }
            
            showTodo()
                .padding(.vertical,10)
            
            showDueDate()
                .padding(.vertical, 10)
            
            showPriority()
                .padding(.vertical,10)
            
            showStatus()
                .padding(.vertical, 10)
        }
        .scrollIndicators(.never)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            Button(action: {showEditView.toggle()}){
                Text("Edit")
            }
            
            Button{
                showAlert.toggle()
            } label: {
                Image(systemName: "trash")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 25)
                    .frame(maxHeight: 25)
            }
            .tint(.red)
        }
        .padding(.horizontal)
        .alert("Delete To-Do? ", isPresented: $showAlert) {
            Button(role:.destructive){
                todoVM.deleteTodo(todo)
                todoVM.fetchTodos()
                dismiss()
            } label: {
                Text("Delete")
            }
            Button(role:.cancel, action: {}){
                Text("Cancel")
            }
        } message: {
            Text("Do you really want to delete this Todo?")
        }
        .sheet(isPresented: $showEditView, onDismiss: todoVM.fetchTodos){
            ToDoEditView(todo: todo)
                .presentationDetents([.medium, .large])
        }
    }
    
    @ViewBuilder
    func showTodo() -> some View {
        HStack{
            VStack(alignment:.leading){
                Text("Description:")
                    .font(.system(.callout, design: .rounded, weight: .semibold))
                    .foregroundStyle(.secondary)
                
                Text(todo.desc ?? "No description")
                    .font(.system(.title2, design: .rounded, weight: .semibold))
                    .frame(maxWidth: Constants.screenWidth - 10, alignment: .leading)
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    func showPriority() -> some View {
        HStack{
            VStack(alignment:.leading){
                Text("Priority:")
                    .font(.system(.callout, design: .rounded, weight: .semibold))
                    .foregroundStyle(.secondary)
                HStack{
                    Text(TodoViewHelpers(todo: todo).priorityName)
                        .font(.system(.title3, design: .rounded, weight: .semibold))
                        .foregroundStyle(.white)
                    Image(systemName: "exclamationmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 20)
                        .frame(maxHeight: 20)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: Constants.screenWidth / 3)
                .frame(minHeight: 40)
                .background(TodoViewHelpers(todo: todo).priorityColor, in:.capsule)
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    func showStatus() -> some View {
        HStack{
            VStack(alignment:.leading){
                Text("Status: ")
                    .font(.system(.callout, design: .rounded, weight: .semibold))
                    .foregroundStyle(.secondary) +
                Text("Click to change the status")
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                    .foregroundStyle(.secondary)
                HStack{
                    Text(TodoViewHelpers(todo: todo).statusName)
                        .font(.system(.title3, design: .rounded, weight: .semibold))
                        .foregroundStyle(.white)
                    Image(systemName: todo.isDone ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 20)
                        .frame(maxHeight: 20)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: Constants.screenWidth / 3)
                .frame(minHeight: 40)
                .background(TodoViewHelpers(todo: todo).statusColor, in:.capsule)
                .onTapGesture {
                    withAnimation {
                        todoVM.toggleCompletion(todo)
                    }
                }
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    func showDueDate() -> some View {
        HStack{
            VStack(alignment:.leading){
                Text("Due Date:")
                    .font(.system(.callout, design: .rounded, weight: .semibold))
                    .foregroundStyle(.secondary)
                
                Text(TodoViewHelpers(todo: todo).formatDate())
                    .font(.system(.title2, design: .rounded, weight: .semibold))
                    .frame(maxWidth: Constants.screenWidth - 10, alignment: .leading)
            }
            Spacer()
        }
    }
}

#Preview {
    NavigationStack{
        TodoDetailView(todo: TodoViewModel.mockToDo())
    }
}
