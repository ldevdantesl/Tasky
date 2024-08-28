//
//  RemovedTodosView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 24.08.2024.
//

import SwiftUI

struct RemovedTodosView: View {
    @ObservedObject var todoVM: TodoViewModel
    
    @State private var alertToggle: Bool = false
    @State private var deleteToggle = false
    @State private var searchText: String = ""
    
    var filteredTodos: [Todo] {
        if searchText.isEmpty{
            return todoVM.todos
        } else {
            return todoVM.todos.filter { $0.title!.localizedStandardContains(searchText) }
        }
    }
    
    var body: some View {
        List{
            ForEach(todoVM.removedTodos){ todo in
                NavigationLink(destination: ArchivedOrRemovedTodoDetailView(observedTodo: todo, todoVM: todoVM, isArchive: false)) {
                    rowForTodo(todo)
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button("Unremove", systemImage: "trash.slash", action: {todoVM.unRemoveTodo(todo)})
                                .tint(.secondary)
                        }
                }
            }
            .onDelete(perform: todoVM.deleteTodoByIndex)
        }
        .searchable(text: $searchText, prompt: "Removed Todos")
        .alert("Unremove All", isPresented: $alertToggle){
            Button("Unremove", role:.destructive, action: todoVM.unRemoveAll)
        } message: {
            Text("Do you really want to Unremove all?")
        }
        .alert("Delete All", isPresented: $deleteToggle){
            Button("Delete all", role:.destructive, action: todoVM.deleteAllRemovedTodos)
        } message: {
            Text("Do you really want to delete all removed Todos?")
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Edit", systemImage: "ellipsis.circle") {
                    Button("Delete all", action: {deleteToggle.toggle()})
                    Button("Unremove all", action: {alertToggle.toggle()})
                }
            }
        }
        .navigationTitle("Removed")
        .navigationBarTitleDisplayMode(.inline)
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
        RemovedTodosView(todoVM: TodoViewModel())
    }
}

