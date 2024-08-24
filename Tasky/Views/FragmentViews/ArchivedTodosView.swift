//
//  ArchivedOrRemovedView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 24.08.2024.
//

import SwiftUI

struct ArchivedTodosView: View {
    @ObservedObject var todoVM: TodoViewModel
    @State private var alertToggle: Bool = false
    @State private var searchText: String = ""
    
    
    var filteredTodos: [Todo] {
        if searchText.isEmpty{
            return todoVM.archivedTodos
        } else {
            return todoVM.archivedTodos.filter { $0.title!.localizedStandardContains(searchText) }
        }
    }
    
    var body: some View {
        List{
            ForEach(filteredTodos){ todo in
                NavigationLink(destination: ArchivedOrRemovedTodoDetailView(observedTodo: todo, todoVM: todoVM, isArchive: true)) {
                    rowForTodo(todo)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button("Unarchive", systemImage: "archivebox", action: {todoVM.unArchive(todo)})
                                .tint(.secondary)
                        }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Archived Search")
        .alert("Unarchive All", isPresented: $alertToggle){
            Button("Unarchive", role:.destructive, action: todoVM.unArchiveAll)
        } message: {
            Text("Do you really want to Unarchive all?")
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                EditButton()
                Menu("Menu", systemImage: "ellipsis.circle") {
                    Button("Unarchive All", action: {alertToggle.toggle()})
                }
            }
        }
        .navigationTitle("Archived")
        .toolbarTitleDisplayMode(.inline)
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
        ArchivedTodosView(todoVM: TodoViewModel())
    }
}
