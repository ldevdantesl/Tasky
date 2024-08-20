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
    @State private var alertMessage: String = ""
    @State private var toggleAlert: Bool = false
    @State private var toggleConfirmation: Bool = false
    
    @StateObject var todoVM = TodoViewModel()
    
    @State private var saveAlert: Bool = false
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment:.leading){
                    Text("Title of your task")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal,5)
                    UIKitTextField(text: $todoTitle, placeholder: "Title")
                        .keyboardType(.default)
                        .scrollDismissesKeyboard(.immediately)
                        .padding(10)
                        .frame(maxWidth: Constants.screenWidth - 30)
                        .frame(maxHeight: 40)
                        .background(Constants.secondaryColor, in: Constants.circularShape)
                }
                .padding(.vertical,10)
                VStack(alignment:.leading){
                    Text("Description of your task")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal,5)
                    TextField("Title", text: $todoDesc, axis: .vertical)
                        .focused($isFocus)
                        .textInputAutocapitalization(.sentences)
                        .scrollDismissesKeyboard(.immediately)
                        .padding(10)
                        .frame(maxWidth: Constants.screenWidth - 30)
                        .background(Constants.secondaryColor, in: Constants.circularShape)
                }
                .padding(.vertical,10)
                PriorityCapsuleView(selectedPriority: $todoPriority)
                    .padding(.vertical,10)
            }
            .scrollIndicators(.hidden)
            .onAppear{
                todoTitle = todo.title ?? ""
                todoDesc = todo.desc ?? ""
                todoPriority = todo.priority
            }
            .padding()
            .alert("Save changes?", isPresented: $saveAlert) {
                Button("Yes"){
                    if checkDescription(){
                        todoVM.editTodos(todo, newTitle: todoTitle, newDesc: todoDesc, newIsDone: false, newPriority: todoPriority)
                        dismiss()
                    } else {
                        todoVM.editTodos(todo, newTitle: todoTitle, newDesc: nil, newIsDone: false, newPriority: todoPriority)
                        dismiss()
                    }
                }
                .tint(.red)
                Button("Cancel"){}
            } message: {
                Text("This changes can not be inverted. Please pay attention!")
            }
            .confirmationDialog("Leave Description?", isPresented: $toggleConfirmation, titleVisibility: .visible){
                Button(role:.destructive){
                    saveAlert.toggle()
                } label: {
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
                    Button(action:editTodo){
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
        if todoTitle.isEmpty || todoTitle.count < 3 {
            alertMessage = "Accurate title will be your best navigator. It should be more than 3 characters!"
            return false
        }
        return true
    }
    
    func checkDescription() -> Bool {
        if todoDesc.isEmpty{
            return false
        }
        return true
    }
    
    func hasChanges() -> Bool {
        if todoTitle == todo.title && todoDesc == todo.desc && todoPriority == todo.priority{
            return false
        }
        return true
    }
    
    func editTodo() {
        if hasChanges(){
            if checkTitle(){
                if checkDescription(){
                    saveAlert.toggle()
                } else {
                    toggleConfirmation.toggle()
                }
            } else {
                toggleAlert.toggle()
            }
        } else {
            dismiss()
        }
    }
}

#Preview {
    ToDoEditView(todo: TodoViewModel.mockToDo())
}
