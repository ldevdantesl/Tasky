//
//  TodoDetailView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import SwiftUI

struct TodoDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject private var todoVM: TodoViewModel
    @ObservedObject private var tagVM: TagViewModel
    @ObservedObject private var settingsManagerVM: SettingsManagerViewModel
    @ObservedObject var todo: Todo
    @ObservedObject var calendarSet: CalendarSet
    
    @Binding var path: NavigationPath
    
    @State private var showAlert: Bool = false
    @State private var showHowManyDaysLeft: Bool = false
    @State private var showArchiveAlert: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var showRepeat: Bool = false
    @State private var showCustomDate: Bool = false
    @State private var settingCustomDate: Date = .now
    @State private var isEditing: Bool = false
    
    @State private var isLoading: Bool = false
    
    init(observedTodo: Todo, todoVM: TodoViewModel, tagVM: TagViewModel, settingsManagerVM: SettingsManagerViewModel, path: Binding<NavigationPath>){
        _todo = ObservedObject(wrappedValue: observedTodo)
        self.todoVM = todoVM
        self.tagVM = tagVM
        self.settingsManagerVM = settingsManagerVM
        self._path = path
        self._calendarSet = ObservedObject(wrappedValue: CalendarSet.instance)
    }
    
    var body: some View {
        ScrollView{
            ///Title
            SinglePropertyComponent(title: String(localized: "Title"), property: todo.title, fontStyle: .title3, fontWeight: .bold)
            
            ///Description
            SinglePropertyComponent(title: String(localized: "Description"), property: todo.desc, fontStyle: .headline)
            
            // MARK: - TAGS
            HStack{
                if let tags = todo.tags?.allObjects as? [Tag] {
                    TagsCircleView(tags: tags)
                }
                Spacer()
                VStack{
                    Text("\(TodoViewHelpers(todo:todo).formatDate)")
                        .font(.system(.callout, design: .rounded, weight: .regular))
                    if !todo.dueDate!.isStartOfDay{
                        Text("\(todo.dueDate!.getTime)")
                            .font(.system(.callout, design: .rounded, weight: .bold))
                    }
                }
            }
            .padding([.horizontal, .bottom], 15)
            
            Divider()
                .padding(.horizontal, 10)
                .padding(.bottom, 15)
            
            // MARK: - PRIORITY
            Capsule()
                .fill(Color.textField)
                .frame(width: Constants.screenWidth - 20, height: 40)
                .overlay {
                    HStack{
                        Text("Priority:")
                            .font(.system(.subheadline, design: .rounded, weight: .regular))
                        
                        Spacer()
                        
                        Capsule()
                            .frame(minWidth: 90, maxWidth: 120)
                            .frame(height: 30)
                            .foregroundStyle(TodoViewHelpers(todo: todo).priorityColor)
                            .shadow(color: .primary.opacity(0.2), radius: 10, x: 0, y: 5)
                            .overlay {
                                Text(TodoViewHelpers(todo: todo).priorityName)
                                    .foregroundStyle(.white)
                                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                            }
                    }
                    .padding(.horizontal, 15)
                }
                .padding(.bottom, 15)
            
            // MARK: - STATUS
            HStack{
                if !todo.isArchived && !todo.isRemoved{
                    Text("Double click to change")
                        .font(.system(.subheadline, design: .rounded, weight: .bold))
                        .foregroundStyle(.secondary)
                        .padding(.leading, 5)
                }
                Spacer()
                    
                VStack{
                    Capsule()
                        .fill(todo.isDone ? Color.green.gradient : Color.gray.gradient)
                        .frame(minWidth: 120, maxWidth: 150)
                        .frame(height: 35)
                        .overlay {
                            HStack(spacing: 5){
                                Text(todo.isDone ? "Done" : "Undone")
                                    .font(.system(.headline, design: .rounded, weight: .bold))
                                    .foregroundStyle(.white)
                                Image(systemName: todo.isDone ? "checkmark.circle.fill" : "xmark.circle.fill" )
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.white)
                            }
                        }
                        .onTapGesture(count: 2, perform: doneOrUndoneTodo)
                        .contextMenu {
                            if !todo.isRemoved && !todo.isArchived{
                                Button("Mark as \(todo.isDone ? "undone" : "done")", systemImage: todo.isDone ? "xmark.circle.fill" : "checkmark.circle.fill", action: doneOrUndoneTodo)
                                if !todo.isDone {
                                    Button("Remind me", systemImage: "bell.circle.fill", action: {})
                                    Button("\(showHowManyDaysLeft ? "Hide" : "Show") days left", systemImage: "exclamationmark.circle.fill", action:{showHowManyDaysLeft.toggle()})
                                }
                            }
                        }
                    
                    if showHowManyDaysLeft && !todo.isDone {
                        Text(calendarSet.showHowManyDaysLeft(for: todo.dueDate ?? .now))
                            .font(.system(.caption, design: .rounded, weight: .semibold))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal, 15)
        }
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 20){
                if !todo.isArchived && !todo.isRemoved {
                    Menu{
                        Button("By Custom Date", systemImage: "calendar", action: {withAnimation{showCustomDate.toggle()}})
                        Button("By Tomorrow", systemImage: "sun.max.fill") {
                            Task {
                                await repeatByTomorrowOR()
                            }
                        }
                    } label: {
                        Text("Repeat")
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: Constants.screenWidth / 2.5, height: 40)
                            .background(.green, in: .capsule)
                    }
                    .disabled(todo.isDone)
                    Button(action: { withAnimation { isEditing.toggle() } } ){
                        Text("Edit")
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: Constants.screenWidth / 2.5, height: 40)
                            .background(Color.blue.opacity(0.8), in:.capsule)
                    }
                }
                else if todo.isArchived {
                    Button(action: { withAnimation { todoVM.unArchive(todo); dismiss() } } ){
                        Text("Unarchive")
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: Constants.screenWidth - 40, height: 40)
                            .background(Color.green.opacity(0.8), in:.capsule)
                    }
                } else if todo.isRemoved {
                    Button(action: { withAnimation { todoVM.unRemoveTodo(todo); dismiss() } } ){
                        Text("Unremove")
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: Constants.screenWidth / 2.5, height: 40)
                            .background(Color.blue.opacity(0.8), in:.capsule)
                    }
                    
                    Button(action: { withAnimation { showDeleteAlert.toggle() } } ){
                        Text("Delete")
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: Constants.screenWidth / 2.5, height: 40)
                            .background(Color.red.opacity(0.8), in:.capsule)
                    }
                }
            }
        }
        .alert("Delete?", isPresented: $showDeleteAlert){
            Button("Delete", role:.destructive){
                withAnimation {
                    todoVM.deleteTodo(todo)
                    dismiss()
                }
            }
        } message: {
            Text("Do you really want to delete this todo ?")
        }
        .alert("Remove Todo? ", isPresented: $showAlert) {
            Button("Remove", role:.destructive){
                withAnimation {
                    todoVM.removeTodo(todo)
                    settingsManagerVM.settingsManager.notificationSettingsManager.removeScheduledNotificationFor(todo)
                    dismiss()
                }
            }
        } message: {
            Text("Do you really want to remove this Todo?")
        }
        .alert("Archive Todo? ", isPresented: $showArchiveAlert) {
            Button("Archive", role:.destructive){
                withAnimation {
                    todoVM.archive(todo)
                    dismiss()
                }
            }
        } message: {
            Text("Do you really want to archive this Todo?")
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if !todo.isArchived && !todo.isRemoved{
                    HStack(spacing: 5){
                        Button("Save", systemImage: todo.isSaved ? "bookmark.fill" : "bookmark") {
                            withAnimation {
                                todo.isSaved ? todoVM.unsaveTodo(todo) : todoVM.saveTodo(todo)
                            }
                        }
                        .tint(.green)
                        Button("Archive", systemImage: "archivebox.fill"){
                            withAnimation {
                                showArchiveAlert.toggle()
                            }
                        }
                        Button("Delete",systemImage: "trash.fill", action: {showAlert.toggle()})
                            .tint(.red)
                    }
                }
            }
        }
        .overlay {
            if isLoading {
                ProgressView()
                    .frame(width: 100, height: 100)
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .sheet(isPresented: $showCustomDate) {
            VStack {
                // DatePicker inside a sheet
                DatePicker(
                    "Select a Date",
                    selection: $settingCustomDate,
                    in: Calendar.current.date(byAdding: .day, value: 1, to: Date())!...,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical) // Or use another style like .wheel, .compact, etc.
                .labelsHidden() // Hide the default label
                .padding()
                
                Button("Repeat") {
                    Task{
                        await repeatByTomorrowOR(byCustomDate: settingCustomDate)
                        withAnimation {
                            showCustomDate.toggle()
                        }
                    }
                }
                .padding()
            }
            .presentationDetents([.medium])
        }
        .fullScreenCover(isPresented: $isEditing) {
            TodoEditView(todo: todo, settingsMgrVM: settingsManagerVM, todoVM: todoVM, tagVM: tagVM, path: $path)
        }
    }
    
    func repeatByTomorrowOR(byCustomDate: Date? = nil) async {
        isLoading = true
        do{
            if let byCustomDate {
                let _ = try await todoVM.createTodo(title: todo.title ?? "", description: todo.desc, priority: todo.priority, dueDate: byCustomDate, tags: todo.tags?.allObjects as? [Tag] ?? [])
            } else {
                let _ = try await todoVM.createTodo(title: todo.title ?? "", description: todo.desc, priority: todo.priority, dueDate: .now.getTomorrowDay, tags: todo.tags?.allObjects as? [Tag] ?? [])
            }
            withAnimation {
                isLoading = false
            }
        } catch {
            print("Can't repeat the task: \(error.localizedDescription)")
        }
    }
    
    func doneOrUndoneTodo() {
        guard !todo.isRemoved, !todo.isArchived else { return }
        withAnimation {
            todo.isDone ? todoVM.uncompleteTodo(todo) : todoVM.completeTodo(todo)
        }
    }
}

#Preview {
    NavigationStack{
        TodoDetailView(observedTodo: TodoViewModel.mockToDo(), todoVM: TodoViewModel(), tagVM: TagViewModel(), settingsManagerVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
    }
}
