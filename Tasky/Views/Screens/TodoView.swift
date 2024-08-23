//
//  TodoView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import SwiftUI

struct TodoView: View {
    @StateObject var todoVM = TodoViewModel()
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
            List {
                ForEach(filteredTodos, id: \.id){ todo in
                    NavigationLink(value: todo) {
                        rowForTodo(todo)
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
                TodoDetailView(observedTodo: todo)
            }
            .navigationTitle("To-Do")
            .searchable(text: $searchText)
            .toolbar{
                ToolbarItemGroup(placement: .topBarTrailing) {
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
                    
                    EditButton()
                }
                ToolbarItem(placement:.topBarLeading){
                    Button("Settings", systemImage: "gear"){
                        
                    }
                }
            }
            .overlay(alignment: .bottomTrailing){
                Menu{
                    Button(action: {onAddTodo.toggle()}) {
                        Text("Todo")
                    }
                    Button(action: {onAddTag.toggle()}) {
                        Text("Tag")
                    }
                } label:{
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .frame(minWidth: 30, maxWidth: 40)
                        .frame(height: 30)
                        .padding(20)
                        .background(Color.blue, in:.circle)
                        .shadow(radius: 5)
                        .padding()
                }
            }
            .fullScreenCover(isPresented: $onAddTodo) {
                AddTodoView()
            }
            .sheet(isPresented: $onAddTag) {
                AddingTagView()
                    .presentationDetents([.medium, .large])
            }
        }
    }
    
    func sortBy(sortKey: String, ascending: Bool){
        todoVM.sortDescriptor = NSSortDescriptor(key: sortKey, ascending: ascending)
        todoVM.fetchTodos()
    }
    
    @ViewBuilder
    func rowForTodo(_ todo: Todo) -> some View {
        let tagsArray = todo.tags?.allObjects as? [Tag] ?? []
        VStack(alignment:.leading, spacing:5){
            Text(todo.title ?? "Uknown title")
                .strikethrough(todo.isDone)
            if !tagsArray.isEmpty{
                HStack{
                    ForEach(tagsArray, id:\.hashValue) { tag in
                        Text("#\(tag.name ?? "")")
                            .font(.system(.caption, design: .rounded, weight: .light))
                            .padding(3)
                            .background(Tag.getColor(from: tag) ?? .gray.opacity(0.3), in:.capsule)
                            .foregroundStyle(foregroundForTagColor(tag: tag))
                    }
                }
                .frame(maxWidth: Constants.screenWidth - 40, maxHeight: 15, alignment:.leading)
            }
        }
    }
    
    func foregroundForTagColor(tag: Tag) -> Color {
        if areColorsEqual(color1: Tag.getColor(from: tag), color2: .gray.opacity(0.3)){
            return .black
        } else {
            return .white
        }
    }
    
}

#Preview {
    NavigationStack{
        TodoView()
    }
}
