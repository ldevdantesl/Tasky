//
//  TodoListView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 30.08.2024.
//

import SwiftUI

struct TodoRowView: View {
    @State var todo: Todo
    
    @ObservedObject var settingsManagerVM: SettingsManagerViewModel
    @ObservedObject var todoVM: TodoViewModel
    
    var body: some View {
        ZStack(alignment:.topLeading){
            RoundedRectangle(cornerRadius: 25)
                .fill(TodoViewHelpers(todo: todo).priorityColor.gradient.opacity(0.8))
            
            VStack(alignment:.leading){
                HStack{
                    Text(todo.title ?? "Uknown title")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .lineLimit(1)
                    Spacer()
                    if todo.isSaved {
                        Image(systemName: "bookmark.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.white)
                    }
                }
                Text(todo.desc ?? "No description")
                    .font(.system(.subheadline, design: .rounded, weight: .regular))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                HStack{
                    if let tags = todo.tags?.allObjects as? [Tag]{
                        HStack(spacing: 5){
                            ForEach(tags, id:\.self) { tag in
                                Image(systemName: tag.systemImage ?? "")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    Spacer()
                    Text(TodoViewHelpers(todo: todo).formatDate)
                        .font(.system(.caption, design: .rounded, weight: .light))
                }
                .padding(.bottom, 10)
            }
            .padding([.top,.horizontal])
            .foregroundStyle(.white)
        
        }
        .frame(width: Constants.screenWidth - 20)
        .frame(minHeight: 130, maxHeight: 130)
        .contextMenu {
            if !todo.isRemoved && !todo.isArchived{
                Button(todo.isDone ? "Uncomplete" : "Complete", systemImage: todo.isDone ? "xmark.circle.fill" : "checkmark.circle.fill"){
                    withAnimation {
                        todo.isDone ? todoVM.uncompleteTodo(todo) : todoVM.completeTodo(todo)
                    }
                }
                Button("Remove", systemImage: "trash.fill"){
                    withAnimation {
                        todoVM.removeTodo(todo)
                    }
                }
                Button("Archive", systemImage: "archivebox.fill"){
                    withAnimation {
                        todoVM.archive(todo)
                    }
                }
            }
            if todo.isRemoved {
                Button("Unremove", systemImage: "trash.slash.fill"){
                    withAnimation {
                        todoVM.unRemoveTodo(todo)
                    }
                }
                Button("Delete", systemImage: "trash.fill"){
                    withAnimation {
                        todoVM.deleteTodo(todo)
                    }
                }
                .tint(.red)
            }
            if todo.isArchived{
                Button("Unarchive", systemImage: "archivebox"){
                    withAnimation {
                        todoVM.unArchive(todo)
                    }
                }
            }
        }
    }
}

#Preview {
    TodoRowView(todo: TodoViewModel.mockToDo(), settingsManagerVM: MockPreviews.viewModel, todoVM: TodoViewModel())
}
