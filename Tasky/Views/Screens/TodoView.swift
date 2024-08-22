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
    @State private var searchText: String = ""
    
    var filteredTodos: [Todo]{
        if searchText.isEmpty{
            return todoVM.todos
        } else {
            return todoVM.todos.filter { todo in
               todo.title!.localizedStandardContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(filteredTodos, id: \.id){ todo in
                    NavigationLink(value: todo) {
                        Text(todo.title ?? "Uknown title")
                            .strikethrough(todo.isDone)
                    }
                    .swipeActions(edge:.leading, allowsFullSwipe: true){
                        if !todo.isDone{
                            Button("Done", systemImage: "checkmark.circle"){
                                todoVM.toggleCompletion(todo)
                            }
                            .tint(.green)
                        } else {
                            Button("Undone", systemImage: "xmark.circle"){
                                todoVM.toggleCompletion(todo)
                            }
                            .tint(.gray)
                        }
                    }
                }
                .onDelete(perform: todoVM.deleteTodoByIndex)
            }
            .navigationDestination(for: Todo.self){ todo in
                TodoDetailView(todo: todo)
            }
            .onAppear(perform: todoVM.fetchTodos)
            .navigationTitle("To-Do")
            .searchable(text: $searchText)
            .toolbar{
                ToolbarItemGroup(placement: .topBarTrailing) {
                    toolbarSortButton()
                    EditButton()
                }
                ToolbarItem(placement:.topBarLeading){
                    NavigationLink{
                        SettingsView()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .overlay(alignment: .bottomTrailing){
                Button(action: {onAddSheet.toggle()}){
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .frame(minWidth: 30, maxWidth: 40)
                        .frame(height: 30)
                        .padding(20)
                        .background(Color.blue, in:.circle)
                }
                .shadow(radius: 5)
                .padding()
            }
            .fullScreenCover(isPresented: $onAddSheet, onDismiss: todoVM.fetchTodos) {
                AddTodoView()
            }
        }
    }
    
    func sortBy(sortKey: String, ascending: Bool){
        todoVM.sortDescriptor = NSSortDescriptor(key: sortKey, ascending: ascending)
        todoVM.fetchTodos()
    }
    
    @ViewBuilder
    func toolbarSortButton() -> some View{
        Menu("Sort", systemImage: "arrow.up.and.down.text.horizontal"){
            Text("Sort By")
            Button("Priority"){
                sortBy(sortKey: "priority", ascending: false)
            }
            Button("First Done"){
                sortBy(sortKey: "isDone", ascending: false)
            }
            Button("First Undone"){
                sortBy(sortKey: "isDone", ascending: true)
            }
            Button("Time added"){
                sortBy(sortKey: "addedOn", ascending: true)
            }
            Button("Due date"){
                sortBy(sortKey: "dueDate", ascending: true)
            }
            Button("Title"){
                sortBy(sortKey: "title", ascending: true)
            }
        }
    }
    
}

#Preview {
    NavigationStack{
        TodoView()
    }
}
