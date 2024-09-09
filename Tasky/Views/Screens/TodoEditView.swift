//
//  EditView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 9.09.2024.
//

import SwiftUI

struct TodoEditView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    @ObservedObject var todo: Todo
    @ObservedObject var todoVM: TodoViewModel
    @ObservedObject var tagVM: TagViewModel
    
    @FocusState private var isFocused: Bool
    
    @Binding var path: NavigationPath
    
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
    
    init(todo: Todo, settingsMgrVM: SettingsManagerViewModel, todoVM: TodoViewModel, tagVM: TagViewModel, path: Binding<NavigationPath>) {
        self.todo = todo
        self.settingsMgrVM = settingsMgrVM
        self.todoVM = todoVM
        self.tagVM = tagVM
        self._title = State(wrappedValue: todo.title ?? "")
        self._description = State(wrappedValue: todo.desc ?? "")
        self._priority = State(wrappedValue: todo.priority)
        self._dueDate = State(wrappedValue: todo.dueDate)
        self._status = State(wrappedValue: todo.isDone)
        self._tags = State(wrappedValue: todo.tags?.allObjects as? [Tag] ?? [])
        self._path = path
    }
    
    var body: some View {
        NavigationStack{
            ScrollView{
                HStack{
                    Text("Edit Todo")
                        .font(.system(.title, design: .rounded, weight: .bold))
                    Spacer()
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.gray)
                        .onTapGesture(perform: { dismiss() })
                }
                .padding([.horizontal, .bottom], 15)
                
                VStack(alignment:.leading){
                    TextFieldComponent(text: $title, placeholder: "Title", maxChars: 25)
                        .padding(10)
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
                
                DueDateFragmentView(settingsMgrVM: settingsMgrVM, dueDate: $dueDate, dateErrorMessage: .constant(nil))
                    .padding(.bottom, 15)
                
                TagLazyFragmentView(tagVM: tagVM, settingsMgrVM: settingsMgrVM, selectedTags: $tags)
            }
            .background(Color.background)
            .onTapGesture {
                withAnimation {
                    isFocused = false
                }
            }
            .toolbar{
                ToolbarItem(placement: .bottomBar) {
                    Button(action: save){
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
        }
    }
    
    func isTitleValid() -> Bool{
        titleErrorMessage = title.count < 3 ? "Title should be more than 3 characters" : nil
        titleErrorMessage = title.trimmingCharacters(in: .whitespaces).isEmpty ? "Title can't be only the spaces" : nil
        return title.count > 2 || !title.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func save() {
        withAnimation {
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                if dueDate?.getDayAndMonth != todo.dueDate?.getDayAndMonth {
                    path.removeLast()
                }
                isTitleValid() ? todoVM.editTodos(todo, newTitle: title, newDesc: description, newPriority: priority, newDueDate: dueDate, newTags: tags) : ()
                isLoading = false
                dismiss()
            }
        }
    }
}

#Preview {
    TodoEditView(todo: TodoViewModel.mockToDo(), settingsMgrVM: MockPreviews.viewModel, todoVM: TodoViewModel(), tagVM: TagViewModel(), path: .constant(NavigationPath()))
}
