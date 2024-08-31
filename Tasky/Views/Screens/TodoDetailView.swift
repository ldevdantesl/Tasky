//
//  TodoDetailView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import SwiftUI

struct TodoDetailView: View {
    
    enum Fields{
        case title
        case description
    }
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject private var todoVM: TodoViewModel
    @ObservedObject private var tagVM: TagViewModel
    @ObservedObject private var settingsManagerVM: SettingsManagerViewModel
    
    @State private var showAlert: Bool = false
    @State private var showEditView: Bool = false
    @State private var isEditing: Fields? = nil
    
    @State private var editingTitle: String = ""
    @State private var editingDesc: String = ""
    @State private var editingPriority: Int16 = 0
    @State private var editingDueDate: Date? = .now
    @State private var editingTags: [Tag]? = []
    
    @FocusState private var focusedField: Fields?
    
    @ObservedObject var todo: Todo
    
    init(observedTodo: Todo, todoVM: TodoViewModel, tagVM: TagViewModel, settingsManagerVM: SettingsManagerViewModel){
        _todo = ObservedObject(wrappedValue: observedTodo)
        self.todoVM = todoVM
        self.tagVM = tagVM
        self.settingsManagerVM = settingsManagerVM
    }
    
    var body: some View {
        ScrollView{
            HStack{
                Image(systemName: "flag.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 25)
                    .frame(maxHeight: 25)
                    .foregroundStyle(TodoViewHelpers(todo: todo).priorityColor)
                
                if isEditing == .title{
                    TextField("\(todo.title ?? "")", text: $editingTitle)
                        .focused($focusedField, equals: Fields.title)
                        .submitLabel(.done)
                        .onSubmit{
                            withAnimation {
                                isEditing = nil
                                todoVM.editTodos(todo, newTitle: editingTitle, newDesc: editingDesc, newPriority: editingPriority, newDueDate: editingDueDate, newTags: editingTags)
                                focusedField = nil
                            }
                        }
                } else {
                    Text(todo.title ?? "No title")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .frame(maxWidth: Constants.screenWidth - 30, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .onTapGesture(count: 2) {
                            withAnimation {
                                isEditing = .title
                                focusedField = .title
                            }
                        }
                }
                Spacer()
                
                Button("",systemImage: "trash", role:.destructive){
                    withAnimation {
                        todoVM.removeTodo(todo)
                        dismiss()
                    }
                }
            }
            
            HStack{
                VStack(alignment:.leading){
                    Text("Description:")
                        .font(.system(.callout, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                    if isEditing == .description{
                        TextField("\(editingDesc)", text: $editingDesc, axis:.vertical)
                            .focused($focusedField, equals: .description)
                            .submitLabel(.done)
                            .onSubmit {
                                withAnimation {
                                    isEditing = nil
                                    focusedField = nil
                                    todoVM.editTodos(todo, newTitle: editingTitle, newDesc: editingDesc, newPriority: editingPriority, newDueDate: editingDueDate, newTags: editingTags)
                                }
                            }
                    } else {
                        Text(todo.desc ?? "No description")
                            .font(.system(.title2, design: .rounded, weight: .semibold))
                            .frame(maxWidth: Constants.screenWidth - 10, alignment: .leading)
                            .onTapGesture(count: 2){
                                withAnimation {
                                    isEditing = .description
                                    focusedField = .description
                                }
                            }
                    }
                }
                Spacer()
            }
            .padding(.vertical, 10)
            HStack{
                VStack(alignment:.leading){
                    Text("Due Date:")
                        .font(.system(.callout, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                    
                    Text(TodoViewHelpers(todo: todo).formatDate())
                        .font(.system(.title2, design: .rounded, weight: .semibold))
                        .frame(maxWidth: Constants.screenWidth - 10, alignment: .leading)
                }
                
                VStack(alignment:.leading){
                    Text("Priority:")
                        .font(.system(.callout, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                    HStack{
                        Text(TodoViewHelpers(todo: todo).priorityName)
                            .font(.system(.title3, design: .rounded, weight: .semibold))
                            .foregroundStyle(.white)
                        Image(systemName: "exclamationmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 20)
                            .frame(maxHeight: 20)
                            .foregroundStyle(.white)
                    }
                    .frame(minWidth: Constants.screenWidth / 3, maxWidth: Constants.screenWidth / 3 + 30)
                    .frame(minHeight: 40)
                    .background(TodoViewHelpers(todo: todo).priorityColor, in:.capsule)
                    .onTapGesture(count: 2){
                        withAnimation {
                            todoVM.editTodos(todo, newTitle: editingTitle, newDesc: editingDesc, newPriority: todo.priority != 3 ? todo.priority + 1 : 1, newDueDate: todo.dueDate, newTags: editingTags)
                        }
                    }
                }
                
            }
            showStatus()
                .padding(.vertical, 10)
            
            
            AllTagsFragmentView(todo: todo)
                .padding(.vertical, 10)
        }
        .padding(.horizontal)
        .onAppear{
            editingTitle = todo.title ?? ""
            editingDesc = todo.desc ?? ""
            editingPriority = todo.priority
            editingTags = todo.tags?.allObjects as? [Tag] ?? []
        }
        .scrollIndicators(.never)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Remove To-Do? ", isPresented: $showAlert) {
            Button("Remove", role:.destructive, action:{todoVM.deleteTodo(todo); dismiss()})
        } message: {
            Text("Do you really want to remove this Todo?")
        }
        .sheet(isPresented: $showEditView){
            ToDoEditView(todo: todo, todoVM: todoVM, tagVM: tagVM)
                .presentationDetents([.fraction(1/1.3), .large])
        }
        .onTapGesture {
            withAnimation {
                isEditing = nil
                focusedField = nil
            }
        }
    }
    
    @ViewBuilder
    func showTodo() -> some View {
        
    }
    
    @ViewBuilder
    func showPriority() -> some View {
        HStack{
            VStack(alignment:.leading){
                Text("Priority:")
                    .font(.system(.callout, design: .rounded, weight: .semibold))
                    .foregroundStyle(.secondary)
                HStack{
                    Text(TodoViewHelpers(todo: todo).priorityName)
                        .font(.system(.title3, design: .rounded, weight: .semibold))
                        .foregroundStyle(.white)
                    Image(systemName: "exclamationmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 20)
                        .frame(maxHeight: 20)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: Constants.screenWidth / 3 + 30)
                .frame(minHeight: 40)
                .background(TodoViewHelpers(todo: todo).priorityColor, in:.capsule)
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    func showStatus() -> some View {
        HStack{
            VStack(alignment:.leading){
                Text("Status: ")
                    .font(.system(.callout, design: .rounded, weight: .semibold))
                    .foregroundColor(.secondary) +
                Text("Click to change the status")
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                    .foregroundColor(.secondary)
                HStack{
                    Text(todo.isDone ? "done_key" : "undone_key")
                        .font(.system(.title3, design: .rounded, weight: .semibold))
                        .foregroundStyle(.white)
                    Image(systemName: todo.isDone ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 20)
                        .frame(maxHeight: 20)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: Constants.screenWidth / 3 + 30)
                .frame(minHeight: 40)
                .background(TodoViewHelpers(todo: todo).statusColor, in:.capsule)
                .onTapGesture {
                    withAnimation {
                        if todo.isDone{
                            todoVM.uncompleteTodo(todo)
                        } else {
                            todoVM.completeTodo(todo)
                        }
                        
                    }
                }
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    func showDueDate() -> some View {
        HStack{
            VStack(alignment:.leading){
                Text("Due Date:")
                    .font(.system(.callout, design: .rounded, weight: .semibold))
                    .foregroundStyle(.secondary)
                
                Text(TodoViewHelpers(todo: todo).formatDate())
                    .font(.system(.title2, design: .rounded, weight: .semibold))
                    .frame(maxWidth: Constants.screenWidth - 10, alignment: .leading)
            }
            Spacer()
        }
    }
}

#Preview {
    NavigationStack{
        TodoDetailView(observedTodo: TodoViewModel.mockToDo(), todoVM: TodoViewModel(), tagVM: TagViewModel(), settingsManagerVM: MockPreviews.viewModel)
    }
}
