//
//  TodoView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import SwiftUI

struct TodoView: View {
    @ObservedObject var todoVM: TodoViewModel
    @ObservedObject var tagVM: TagViewModel
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    
    @State private var onAddTodo = false
    @State private var onAddTag = false
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
            Group{
                if filteredTodos.isEmpty, #available(iOS 17.0, *){
                    ContentUnavailableView("No todos yet", systemImage: "questionmark.folder", description: Text("Add todos to get started"))
                } else {
                    List {
                        ForEach(filteredTodos, id: \.id){ todo in
                            NavigationLink(value: todo) {
                                rowForTodo(todo)
                            }
                            .swipeActions(edge:.leading, allowsFullSwipe: true){
                                if !todo.isDone{
                                    Button("Done", systemImage: "checkmark.circle"){
                                        todoVM.completeTodo(todo)
                                    }
                                    .tint(.green)
                                } else {
                                    Button("Undone", systemImage: "xmark.circle"){
                                        todoVM.uncompleteTodo(todo)
                                    }
                                    .tint(.gray)
                                }
                                Button("Archive", systemImage: "archivebox", action: {todoVM.archive(todo)})
                                    .tint(.purple)
                            }
                        }
                        .onDelete(perform: todoVM.removeTodoByIndex)
                    }
                }
            }
            .searchable(text: $searchText)
            .toolbar{
                ToolbarItemGroup(placement: .topBarTrailing) {
                    toolbarSortButton()
                    EditButton()
                }
                ToolbarItem(placement:.topBarLeading){
                    NavigationLink{
                        SettingsView(todoVM: todoVM, tagVM: tagVM, settingsMgrVM: settingsMgrVM)
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .overlay(alignment: .bottomTrailing){
                Menu{
                    Button("Todo", action: { onAddTodo.toggle() })
                    Button("Tag", action: { onAddTag.toggle() })
                } label:{
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .frame(minWidth: 30, maxWidth: 40)
                        .frame(height: 30)
                        .padding(20)
                        .background(settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme, in:.circle)
                        .shadow(radius: 5)
                        .padding()
                }
            }
            .navigationDestination(for: Todo.self){ todo in
                TodoDetailView(observedTodo: todo, todoVM: todoVM, tagVM: tagVM, settingsManagerVM: settingsMgrVM)
            }
            .fullScreenCover(isPresented: $onAddTodo) {
                AddTodoView(todoVM: todoVM, tagVM: tagVM)
            }
            .sheet(isPresented: $onAddTag) {
                AddingTagView(tagVM: tagVM)
                    .presentationDetents([.medium, .large])
            }
            
        }
    }
    
    func sortBy(sortKey: String, ascending: Bool){
        todoVM.sortDescriptor = NSSortDescriptor(key: sortKey, ascending: ascending)
        todoVM.fetchAllTodos()
    }
    
    @ViewBuilder
    func rowForTodo(_ todo: Todo) -> some View {
        VStack(alignment:.leading, spacing:5){
            Text(todo.title ?? "Uknown title")
                .strikethrough(todo.isDone, color: .primary)
            TagsForTodoView(todo: todo, settingsManagerVM: settingsMgrVM)
        }
    }
    
    func toolbarSortButton() -> some View{
        Menu("Sort", systemImage: "arrow.up.and.down.text.horizontal"){
            Text("Sort By")
            Button("Priority", action: { sortBy(sortKey: "priority", ascending: false) })
            Button("First Done", action: { sortBy(sortKey: "isDone", ascending: false) })
            Button("First Undone", action: { sortBy(sortKey: "isDone", ascending: true) })
            Button("Time added", action: { sortBy(sortKey: "addedOn", ascending: true) })
            Button("Due date", action: { sortBy(sortKey: "dueDate", ascending: true) })
            Button("Title", action: { sortBy(sortKey: "title", ascending: true) })
        }
    }
    
}

#Preview {
    NavigationStack{
        TodoView(todoVM: TodoViewModel(), tagVM: TagViewModel(), settingsMgrVM: MockPreviews.viewModel)
    }
}
