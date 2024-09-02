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
        case dueDate
    }
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject private var todoVM: TodoViewModel
    @ObservedObject private var tagVM: TagViewModel
    @ObservedObject private var settingsManagerVM: SettingsManagerViewModel
    
    @State private var showAlert: Bool = false
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
            // MARK: - TITLE
            HStack{
                if isEditing == .title{
                    TextFieldComponent(text: $editingTitle, placeholder: "\(todo.title ?? "")", maxChars: 30)
                        .focused($focusedField, equals: Fields.title)
                        .submitLabel(.done)
                        .onSubmit{
                            withAnimation {
                                isEditing = nil
                                editingTitle.isEmpty ? () : todoVM.editTodos(todo, newTitle: editingTitle)
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
                
                if isEditing == nil {
                    Button(action: {dismiss()}) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 25)
                            .foregroundStyle(.gray, .gray.opacity(0.3))
                    }
                } else if isEditing == .title || isEditing == .description {
                    Button {
                        isEditing == .title ? todoVM.editTodos(todo, newTitle: editingTitle) : todoVM.editTodos(todo, newDesc: editingDesc)
                        isEditing = nil
                        focusedField = nil
                    } label:{
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 25)
                            .foregroundStyle(Color.accentColor)
                    }
                }
            }
            .padding(.horizontal)
            
            // MARK: - DESCRIPTION
            HStack{
                VStack(alignment:.leading){
                    Text("Description:")
                        .font(.system(.callout, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                    if isEditing == .description{
                        TextField("\(editingDesc)", text: $editingDesc, axis:.vertical)
                            .focused($focusedField, equals: .description)
                    } else {
                        Text(todo.desc ?? "Add description")
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
            .padding(.horizontal)
            
            // MARK: - STATUS AND PRIORITY
            HStack{
                VStack(alignment:.leading){
                    Text("Status: ")
                        .font(.system(.callout, design: .rounded, weight: .semibold))
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
                    .onTapGesture(count:2){
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
            .padding(.vertical, 10)
            .padding(.horizontal)
            
            // MARK: - DUE DATE
            VStack(alignment:.leading){
                HStack{
                    if isEditing != .dueDate{
                        Spacer()
                    }
                    Text(TodoViewHelpers(todo: todo).formatDate())
                        .font(.system(.title3, design: .rounded, weight: .medium))
                        .foregroundStyle(isEditing == .dueDate ? .secondary : .primary)
                        .scaleEffect(isEditing == .dueDate ? 0.8 : 1)
                    if isEditing == .dueDate{
                        Spacer()
                    }
                }
                .onTapGesture(count: 2) {
                    withAnimation {
                        if isEditing == .dueDate {
                            isEditing = nil
                        } else {
                            isEditing = .dueDate
                        }
                    }
                }
                
                if isEditing == .dueDate {
                    HStack{
                        ShowSpecDate(text: "Date", sysImage: "calendar.circle.fill", color: .red, action: {_ in})
                        ShowSpecDate(text: "- Day", sysImage: "arrow.backward.circle.fill", color: .purple, action:todoVM.removeADayTodo)
                        ShowSpecDate(text: "Today", sysImage: "sun.and.horizon.circle.fill", action:todoVM.makeTodoToday)
                        ShowSpecDate(text: "+ Day", sysImage: "arrow.forward.circle.fill", color: .purple, action:todoVM.addADayTodo)
                    }
                    
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal)
        }
        .onAppear{
            editingTitle = todo.title ?? ""
            editingDesc = todo.desc ?? ""
            editingPriority = todo.priority
            editingTags = todo.tags?.allObjects as? [Tag] ?? []
        }
        .scrollIndicators(.never)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Remove To-Do? ", isPresented: $showAlert) {
            Button("Remove", role:.destructive){
                withAnimation {
                    todoVM.removeTodo(todo)
                    dismiss()
                }
            }
        } message: {
            Text("Do you really want to remove this Todo?")
        }
        .onTapGesture {
            withAnimation {
                isEditing = nil
                focusedField == .description ? todoVM.editTodos(todo, newDesc: editingDesc) : todoVM.editTodos(todo, newTitle: editingTitle)
                focusedField = nil
            }
        }
    }
    
    @ViewBuilder
    func ShowSpecDate(text: String, sysImage: String, color: Color? = .yellow, action: @escaping (Todo) -> ()) -> some View {
        VStack(spacing: 0){
            Image(systemName: sysImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 20)
                .foregroundStyle(color ?? .black)
                
            Text(text)
                .font(.system(.callout, design: .rounded, weight: .medium))
        }
        .frame(minWidth: Constants.screenWidth / 7, maxHeight: 40)
        .padding(5)
        .background(Color.gray.opacity(0.2), in: .rect(cornerRadius: 15))
        .onTapGesture {
            withAnimation {
                isEditing = nil
                action(todo)
            }
        }
    }
}

#Preview {
    NavigationStack{
        TodoDetailView(observedTodo: TodoViewModel.mockToDo(), todoVM: TodoViewModel(), tagVM: TagViewModel(), settingsManagerVM: MockPreviews.viewModel)
    }
}
