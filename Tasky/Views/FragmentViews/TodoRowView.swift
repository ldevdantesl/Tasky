//
//  TodoListView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 30.08.2024.
//

import SwiftUI

struct TodoRowView: View {
    @StateObject var todo: Todo
    
    @ObservedObject var settingsManagerVM: SettingsManagerViewModel
    @ObservedObject var todoVM: TodoViewModel
    
    private var isFullInitType: Bool
    
    init(todo: Todo, settingsManagerVM: SettingsManagerViewModel, todoVM: TodoViewModel, offsetY: CGFloat? = nil) {
        self._todo = StateObject(wrappedValue: todo)
        self.settingsManagerVM = settingsManagerVM
        self.todoVM = todoVM
        self.isFullInitType = true
    }
    
    init(todo: Todo) {
        self._todo = StateObject(wrappedValue: todo)
        self.todoVM = TodoViewModel()
        self.settingsManagerVM = MockPreviews.viewModel
        self.isFullInitType = false
    }
    
    var body: some View {
        ZStack(alignment:.topLeading){
            RoundedRectangle(cornerRadius: 25)
                .fill(TodoViewHelpers(todo: todo).priorityColor.gradient)
            
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
            if isFullInitType{
                if !todo.isRemoved && !todo.isArchived{
                    Button(todo.isDone ? "Uncomplete" : "Complete", systemImage: todo.isDone ? "xmark.circle.fill" : "checkmark.circle.fill"){
                        withAnimation {
                            if todo.isDone {
                                todoVM.uncompleteTodo(todo)
                                settingsManagerVM.settingsManager.notificationSettingsManager.scheduleNotificationFor(todo, at: todo.dueDate ?? .now)
                            } else {
                                todoVM.completeTodo(todo)
                                settingsManagerVM.settingsManager.notificationSettingsManager.removeScheduledNotificationFor(todo)
                            }
                        }
                    }
                    Button("Remove", systemImage: "trash.fill"){
                        withAnimation {
                            todoVM.removeTodo(todo)
                            settingsManagerVM.settingsManager.notificationSettingsManager.removeScheduledNotificationFor(todo)
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
                if todo.isSaved{
                    Button("Unsave", systemImage: "bookmark.circle.fill"){
                        withAnimation {
                            todoVM.unsaveTodo(todo)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TodoRowView(todo: TodoViewModel.mockToDo(), settingsManagerVM: MockPreviews.viewModel, todoVM: TodoViewModel())
}
