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
            SinglePropertyComponent(title: "Title", property: todo.title, fontStyle: .title3, fontWeight: .bold)
            
            SinglePropertyComponent(title: "Description", property: todo.desc, fontStyle: .headline)
            
            HStack{
                if let tags = todo.tags?.allObjects as? [Tag] {
                    TagsCircleView(tags: tags)
                }
                Spacer()
                Text("\(todo.dueDate?.getDayDigit ?? 0) of \(todo.dueDate?.getDayMonthString ?? "")")
                    .font(.system(.callout, design: .rounded, weight: .regular))
            }
            .padding([.horizontal, .bottom], 15)
            
            Divider()
                .padding(.horizontal, 10)
                .padding(.bottom, 15)
            
            Capsule()
                .fill(Color.textField)
                .frame(width: Constants.screenWidth - 20, height: 40)
                .overlay{
                    HStack{
                        Text("Priority:")
                            .font(.system(.subheadline, design: .rounded, weight: .regular))
                        
                        Spacer()
                        
                        Capsule()
                            .frame(minWidth: 90, maxWidth: 120)
                            .frame(height: 30)
                            .foregroundStyle(TodoViewHelpers(todo: todo).priorityColor)
                            .overlay {
                                Text(TodoViewHelpers(todo: todo).priorityName)
                                    .foregroundStyle(.white)
                            }
                    }
                    .padding(.horizontal, 15)
                }
                .padding(.bottom, 15)
            
            HStack{
                Text("Double click to change")
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                    .foregroundStyle(.secondary)
                    .padding(.leading, 5)
                    
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
                        .onTapGesture(count: 2, perform: {doneOrUndoneTodo(makeDone: todo.isDone)})
                        .contextMenu {
                            if todo.isDone {
                                Button("Mark as undone", systemImage: "xmark.circle.fill", action:{doneOrUndoneTodo(makeDone: false)})
                            } else {
                                Button("Remind me", systemImage: "bell.circle.fill", action: {})
                                Button("\(showHowManyDaysLeft ? "Hide" : "Show") days left", systemImage: "exclamationmark.circle.fill", action:{showHowManyDaysLeft.toggle()})
                                Button("Mark as done", systemImage: "checkmark.circle.fill", action: { doneOrUndoneTodo() })
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
                if todo.isDone {
                    Menu{
                        Button("By Custom Date", systemImage: "calendar", action: {withAnimation{showCustomDate.toggle()}})
                        Button("By Tomorrow", systemImage: "sun.max.fill", action: {repeatByTomorrowOR()})
                    } label: {
                        Text("Repeat")
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: Constants.screenWidth / 2.5, height: 40)
                            .background(.green, in: .capsule)
                    }
                } else {
                    Text("Repeat")
                        .font(.system(.headline, design: .rounded, weight: .regular))
                        .foregroundStyle(.gray)
                        .frame(width: Constants.screenWidth / 2.5, height: 40)
                        .background(Color.textField, in: .capsule)
                }
                Button(action: { withAnimation { isEditing.toggle() } } ){
                    Text("Edit")
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: Constants.screenWidth / 2.5, height: 40)
                        .background(Color.blue.opacity(0.8), in:.capsule)
                }
            }
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
        .overlay {
            if isLoading {
                ProgressView()
                    .frame(width: 100, height: 100)
                    .background(.ultraThinMaterial, in:.rect(cornerRadius: 15))
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
                    withAnimation {
                        repeatByTomorrowOR(byCustomDate: settingCustomDate)
                        settingsManagerVM.settingsManager.notificationSettingsManager.scheduleNotificationFor(todo, at: settingCustomDate)
                        showCustomDate.toggle()
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
    
    func repeatByTomorrowOR(byCustomDate: Date? = nil) {
        withAnimation {
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                if let byCustomDate {
                   let _ = todoVM.createTodo(title: todo.title ?? "", description: todo.desc, priority: todo.priority, dueDate: byCustomDate, tags: todo.tags?.allObjects as? [Tag] ?? [])
                } else {
                    let _ = todoVM.createTodo(title: todo.title ?? "", description: todo.desc, priority: todo.priority, dueDate: todo.dueDate?.getTomorrowDay, tags: todo.tags?.allObjects as? [Tag] ?? [])
                }
                isLoading = false
            }
        }
    }
    
    func doneOrUndoneTodo(makeDone: Bool = true) {
        withAnimation {
            if makeDone{
                todoVM.uncompleteTodo(todo)
                settingsManagerVM.settingsManager.notificationSettingsManager.scheduleNotificationFor(todo, at: todo.dueDate ?? .now)
            }  else {
                todoVM.completeTodo(todo)
                settingsManagerVM.settingsManager.notificationSettingsManager.removeScheduledNotificationFor(todo)
            }
            dismiss()
        }
    }
}

#Preview {
    NavigationStack{
        TodoDetailView(observedTodo: TodoViewModel.mockToDo(), todoVM: TodoViewModel(), tagVM: TagViewModel(), settingsManagerVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
    }
}
