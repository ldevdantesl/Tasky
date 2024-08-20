//
//  TodoView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import SwiftUI

struct TodoView: View {
    @StateObject var todoVM = TodoViewModel()
    @State private var onAddSheet = false
    var body: some View {
        NavigationStack{
            List {
                ForEach(todoVM.todos, id: \.id){ todo in
                    NavigationLink(value: todo) {
                        Text(todo.title ?? "Uknown title")
                    }
                }
                .onDelete(perform: todoVM.deleteTodoByIndex)
            }
            .navigationDestination(for: Todo.self){ todo in
                TodoDetailView(todo: todo)
            }
            .navigationTitle("To-Do")
            .toolbar{
                ToolbarItemGroup(placement: .topBarTrailing) {
                    EditButton()
                    Button(action: {onAddSheet.toggle()}){
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
            .onAppear(perform: todoVM.fetchTodos)
            .fullScreenCover(isPresented: $onAddSheet, onDismiss: todoVM.fetchTodos) {
                AddTodoView(toggleView: $onAddSheet)
            }
        }
    }
    
}

#Preview {
    NavigationStack{
        TodoView()
    }
}
