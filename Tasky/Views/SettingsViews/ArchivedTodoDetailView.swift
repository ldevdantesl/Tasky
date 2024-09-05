//
//  ArchivedTodoDetailView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 24.08.2024.
//

import SwiftUI

struct ArchivedOrRemovedTodoDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject private var todoVM: TodoViewModel
    @ObservedObject var todo: Todo
    
    @State private var showAlert: Bool = false
    
    let isArchive: Bool
    
    init(observedTodo: Todo, todoVM: TodoViewModel, isArchive: Bool){
        _todo = ObservedObject(wrappedValue: observedTodo)
        self.todoVM = todoVM
        self.isArchive = isArchive
    }
    
    var body: some View {
        ScrollView{
            Group{
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
            .padding(.horizontal)
            
            AllTagsFragmentView(todo: todo)
                .padding(.vertical, 10)
        }
        .scrollIndicators(.never)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            if isArchive{
                Button("Unarchive", action:{showAlert.toggle()})
            } else {
                Menu("Menu", systemImage: "ellipsis.circle"){
                    Button("Delete Todo", systemImage: "trash", action: {showAlert.toggle()})
                    Button("Unremove Todo", systemImage: "square.and.arrow.down", action:{todoVM.unRemoveTodo(todo); dismiss()})
                }
                .tint(.red)
            }
        }
        .alert(isArchive ? "Unarchive To-Do":"Delete To-Do", isPresented: $showAlert) {
            Button(isArchive ? "Unarchive" : "Delete", role:.destructive){
                isArchive ? todoVM.unArchive(todo) : todoVM.deleteTodo(todo)
                dismiss()
            }
        } message: {
            Text("Do you really want to \(isArchive ? "unarchive" : "delete") this Todo?")
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
                .frame(maxWidth: Constants.screenWidth / 3 + 30)
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
                Text("Status:")
                    .font(.system(.callout, design: .rounded, weight: .semibold))
                    .foregroundStyle(.secondary)
                HStack{
                    Text(todo.isDone ? "done_key" : "undone_key")
                        .font(.system(.title3, design: .rounded, weight: .semibold))
                        .foregroundStyle(.white)
                    Image(systemName: todo.isDone ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 20)
                        .frame(maxHeight: 20)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: Constants.screenWidth / 3 + 30)
                .frame(minHeight: 40)
                .background(TodoViewHelpers(todo: todo).statusColor, in:.capsule)
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
                
                Text(TodoViewHelpers(todo: todo).formatDate)
                    .font(.system(.title2, design: .rounded, weight: .semibold))
                    .frame(maxWidth: Constants.screenWidth - 10, alignment: .leading)
            }
            Spacer()
        }
    }

}

#Preview {
    NavigationStack{
        ArchivedOrRemovedTodoDetailView(observedTodo: TodoViewModel.mockToDo(), todoVM: TodoViewModel(), isArchive: true)
    }
}
