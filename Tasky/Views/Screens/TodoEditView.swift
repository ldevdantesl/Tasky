//
//  EditView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 9.09.2024.
//

import SwiftUI

struct TodoEditView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var settingsMgrVM: SettingsManagerViewModel
    @EnvironmentObject var todoVM: TodoViewModel
    @EnvironmentObject var tagVM: TagViewModel
    @EnvironmentObject var navpath: NavPathManager
    
    @FocusState private var isFocused: Bool
    
    @ObservedObject var todo: Todo
    
    @State private var isLoading: Bool = false
    
    @State var title: String
    @State var description: String
    @State var priority: Int16
    @State var dueDate: Date?
    @State var status: Bool
    @State var tags: [Tag]
    
    @State private var titleErrorMessage: String?
    
    var colorTheme: Color {
        settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    init(todo: Todo) {
        self._todo = ObservedObject(wrappedValue: todo)
        self._title = State(wrappedValue: todo.title ?? "")
        self._description = State(wrappedValue: todo.desc ?? "")
        self._priority = State(wrappedValue: todo.priority)
        self._dueDate = State(wrappedValue: todo.dueDate)
        self._status = State(wrappedValue: todo.isDone)
        self._tags = State(wrappedValue: todo.tags?.allObjects as? [Tag] ?? [])
    }
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment:.leading){
                    TextFieldComponent(text: $title, placeholder: "Title", maxChars: 25)
                        .padding(.vertical, 10)
                        .background(Color.textField, in:.capsule)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    
                    if let titleErrorMessage {
                        Text(titleErrorMessage)
                            .font(.system(.caption, design: .rounded, weight: .light))
                            .foregroundStyle(.red)
                            .padding(.horizontal, 10)
                    }
                }
                .padding([.horizontal, .bottom], 15)
                
                TextField("Description", text: $description, axis:.vertical)
                    .focused($isFocused)
                    .padding(10)
                    .background(Color.textField, in:.rect(cornerRadius: 25))
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .padding([.horizontal, .bottom], 15)
                    .autocorrectionDisabled()
                    .padding(.bottom, 15)
                
                PriorityCapsuleView(selectedPriority: $priority)
                    .padding(.bottom, 15)
                
                DueDateFragmentView(dueDate: $dueDate, dateErrorMessage: .constant(nil))
                    .padding(.bottom, 15)
                
                TagLazyFragmentView(selectedTags: $tags)
            }
            .safeAreaInset(edge: .top, spacing: 25) {
                UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 25, bottomTrailing: 25))
                    .fill(colorTheme.gradient)
                    .overlay(alignment:.bottom) {
                        HStack{
                            Text("Edit Todo")
                                .font(.system(.title, design: .rounded, weight: .bold))
                                .foregroundStyle(.white)
                            Spacer()
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.white)
                                .onTapGesture {
                                    dismiss()
                                }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    }
                    .shadow(color: .primary.opacity(0.2), radius: 10, x: 0, y: 5)
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
            }
            .background(Color.background)
            .onTapGesture {
                withAnimation {
                    isFocused = false
                }
            }
            .toolbar{
                ToolbarItem(placement: .bottomBar) {
                    Button{
                        save()
                        Task{ await todoVM.fetchTodayTodos(for: CalendarSet.instance.currentDay) }
                    } label: {
                        Text("Save")
                            .font(.system(.title3, design: .rounded, weight: .bold))
                            .frame(width: Constants.screenWidth - 40, height: 50)
                            .background(colorTheme, in:.capsule)
                            .foregroundStyle(.white)
                    }
                }
            }
            .overlay{
                if isLoading{
                    ProgressView()
                        .frame(width: 100, height: 100)
                        .background(.ultraThinMaterial, in:.rect(cornerRadius: 25))
                }
            }
            .disabled(isLoading)
            .animation(.bouncy, value: isLoading)
        }
    }
    
    func isTitleValid() -> Bool {
        if title.count <= 2 {
            titleErrorMessage = String(localized:"Title should be more than 2 characters")
            return false
        } else if title.trimmingCharacters(in: .whitespaces).isEmpty {
            titleErrorMessage = String(localized: "Title can't be only the spaces")
            return false
        } else {
            return true
        }
    }
    
    func save() {
        isLoading = true
        
        do {
            guard isTitleValid() else { isLoading = false; return }
            try todoVM.editTodos(todo, newTitle: title, newDesc: description, newPriority: priority, newDueDate: dueDate, newTags: tags)
        } catch {
            logger.log("Error editing todo")
        }
        
        isLoading = false
        dismiss()
    }
}

#Preview {
    TodoEditView(todo: TodoViewModel.mockToDo())
        .environmentObject(TodoViewModel())
        .environmentObject(TagViewModel())
        .environmentObject(MockPreviews.viewModel)
        .environmentObject(NavPathManager())
}
