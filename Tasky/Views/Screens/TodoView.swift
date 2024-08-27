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
            .navigationDestination(for: Todo.self){ todo in
                TodoDetailView(observedTodo: todo, todoVM: todoVM, tagVM: tagVM)
            }
            .navigationTitle("To-Do")
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
        let tagsArray = todo.tags?.allObjects as? [Tag] ?? []
        VStack(alignment:.leading, spacing:5){
            Text(todo.title ?? "Uknown title")
                .strikethrough(todo.isDone, color: .primary)
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
    
    func toolbarSortButton() -> some View{
        Menu("Sort", systemImage: "arrow.up.and.down.text.horizontal"){
            Text("Sort By")
            Button("Priority", action: { sortBy(sortKey: "priority", ascending: false) })
                .sensoryFeedback(.success, trigger: true)
            Button("First Done", action: { sortBy(sortKey: "isDone", ascending: false) })
                .sensoryFeedback(.success, trigger: true)
            Button("First Undone", action: { sortBy(sortKey: "isDone", ascending: true) })
                .sensoryFeedback(.success, trigger: true)
            Button("Time added", action: { sortBy(sortKey: "addedOn", ascending: true) })
                .sensoryFeedback(.success, trigger: true)
            Button("Due date", action: { sortBy(sortKey: "dueDate", ascending: true) })
                .sensoryFeedback(.success, trigger: true)
            Button("Title", action: { sortBy(sortKey: "title", ascending: true) })
                .sensoryFeedback(.success, trigger: true)
        }
    }
    
}

#Preview {
    NavigationStack{
        TodoView(todoVM: TodoViewModel(), tagVM: TagViewModel(), settingsMgrVM: MockPreviews.viewModel)
    }
}
