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
    
    var priorityColor: Color{
        switch todo.priority{
        case 1:
            return .green
        case 2:
            return .blue
        default:
            return .red
        }
    }
    var priorityName: String{
        switch todo.priority{
        case 1:
            return "Trivial"
        case 2:
            return "Fair"
        default:
            return "Principal"
        }
    }
    
    var body: some View {
        ScrollView{
            HStack{
                Image(systemName: "flag.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 25)
                    .frame(maxHeight: 25)
                    .foregroundStyle(priorityColor)
                
                Text(todo.title ?? "No title")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .frame(maxWidth: Constants.screenWidth - 30, alignment: .leading)
                Spacer()
            }
            
            showTodo(text: "Description", bindText: todo.desc)
                .padding(.vertical,10)
            
            showPriority()
                .padding(.vertical,10)
        }
        .scrollIndicators(.never)
        .toolbarTitleDisplayMode(.inline)
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
    func showTodo(text: String, bindText: String?) -> some View {
        HStack{
            VStack(alignment:.leading){
                Text(text)
                    .font(.system(.callout, design: .rounded, weight: .semibold))
                    .foregroundStyle(.secondary)
                
                Text(bindText ?? "No Description")
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
                Text("Priority")
                    .font(.system(.callout, design: .rounded, weight: .semibold))
                    .foregroundStyle(.secondary)
                HStack{
                    Text(priorityName)
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
                .background(priorityColor, in:.capsule)
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
