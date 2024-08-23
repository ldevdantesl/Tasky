//
//  ToDoEditView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 20.08.2024.
//

import SwiftUI

struct ToDoEditView: View {
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocus: Bool
    
    let todo: Todo
    
    @State var todoTitle: String = ""
    @State var todoDesc: String = ""
    @State var todoPriority: Int16 = 1
    @State var todoDueDate: Date = .now
    @State var addDueDate: Bool = false
    @State var todoTags: [Tag] = []
    @State private var alertMessage: String = ""
    @State private var toggleAlert: Bool = false
    @State private var toggleConfirmation: Bool = false
    
    @StateObject var todoVM = TodoViewModel()
    @StateObject var tagVM = TagViewModel()
    
    @State private var saveAlert: Bool = false
    
    var body: some View {
        NavigationStack{
            ScrollView{
                Group{
                    // MARK: - TITLE
                    VStack(alignment:.leading){
                        Text("Title of your task")
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal,5)
                        UIKitTextField(text: $todoTitle, placeholder: "Title")
                            .scrollDismissesKeyboard(.immediately)
                            .padding(10)
                            .frame(maxWidth: Constants.screenWidth - 30)
                            .frame(maxHeight: 40)
                            .background(Constants.secondaryColor, in: Constants.circularShape)
                    }
                    .padding(.vertical,10)
                    
                    // MARK: - DESCRIPTION
                    VStack(alignment:.leading){
                        Text("Description of your task")
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal,5)
                        TextField("Description", text: $todoDesc, axis: .vertical)
                            .focused($isFocus)
                            .textInputAutocapitalization(.sentences)
                            .scrollDismissesKeyboard(.immediately)
                            .padding(10)
                            .frame(maxWidth: Constants.screenWidth - 30)
                            .background(Constants.secondaryColor, in: Constants.circularShape)
                    }
                    .padding(.vertical,10)
                    
                    // MARK: - DUE DATE
                    DueDateFragmentView(dueDate: $todoDueDate, addDueDate: $addDueDate)
                        .padding(.vertical, 10)
                    
                    // MARK: - PRIORITY
                    PriorityCapsuleView(selectedPriority: $todoPriority)
                        .padding(.vertical,10)
                }
                .padding(.horizontal)
                // MARK: - TAGS
                TagLazyFragmentView(selectedTags: $todoTags)
                    .padding(.vertical, 10)
            }
            .scrollIndicators(.hidden)
            .onAppear(perform: onAppearInit)
            .alert("Save changes?", isPresented: $saveAlert) {
                Button(role: .destructive, action: editTodo){
                    Text("Yes")
                }
                .tint(.red)
            } message: {
                Text("This changes can not be inverted. Please pay attention!")
            }
            .confirmationDialog("Leave Description?", isPresented: $toggleConfirmation, titleVisibility: .visible){
                Button(role:.destructive, action: {saveAlert.toggle()}){
                    Text("Yes")
                }
                .tint(.red)
            } message: {
                Text("The description serves as a reminder of what you should have done.")
            }
            .alert("Watch Out! Title is not Accurate", isPresented: $toggleAlert) {
                Button(action:{alertMessage = ""}){
                    Text("OK")
                }
            } message: {
                Text(alertMessage)
            }
            .toolbar{
                if isFocus{
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done"){
                           isFocus = false
                        }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: finalCheck){
                        Text("Save")
                            .foregroundStyle(.white)
                            .frame(minWidth: Constants.screenWidth - 40)
                            .frame(height: 50)
                            .background(Color.blue, in:.capsule)
                    }
                }
            }
        }
    }
    
    func checkTitle() -> Bool{
        let trimmedTitle = todoTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let result = trimmedTitle.isEmpty || trimmedTitle.count < 3
        alertMessage = result ? "Accurate title will be your best navigator. It should be more than 3 characters!" : ""
        return result
    }
    
    func checkDescription() -> Bool {
        let trimmedDesc = todoDesc.trimmingCharacters(in: .whitespacesAndNewlines)
        let result = trimmedDesc.isEmpty
        return result
    }
    
    func finalCheck() {
        if !checkTitle(){
            if !checkDescription(){
                saveAlert.toggle()
            } else {
                toggleConfirmation.toggle()
            }
        } else {
            toggleAlert.toggle()
        }
    }
    
    func editTodo() {
        let withDesc = checkDescription()
        todoVM.editTodos(todo, newTitle: todoTitle, newDesc: withDesc ? nil : todoDesc, newPriority: todoPriority, newDueDate: addDueDate ? todoDueDate : nil, newTags: todoTags)
        dismiss()
    }
    
    func onAppearInit() {
        todoTitle = todo.title ?? ""
        todoDesc = todo.desc ?? ""
        todoPriority = todo.priority
        todoDueDate = todo.dueDate ?? .now
        addDueDate = (todo.dueDate != nil) ? true : false
        todoTags = todo.tags?.allObjects as? [Tag] ?? []
    }
}

#Preview {
    ToDoEditView(todo: TodoViewModel.mockToDo())
}
