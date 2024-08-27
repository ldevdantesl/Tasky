//
//  AddTodoView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import SwiftUI

struct AddTodoView: View {
    @ObservedObject var todoVM: TodoViewModel
    @ObservedObject var tagVM: TagViewModel
    @FocusState var isFocused: Bool
    @Environment(\.dismiss) var dismiss
    
    init(todoVM: TodoViewModel, tagVM: TagViewModel){
        self.todoVM = todoVM
        self.tagVM = tagVM
    }
    
    @State private var title: String = ""
    @State private var desc: String = ""
    @State private var priority: Int16 = 2
    @State private var dueDate: Date = .now
    @State private var selectedTags: [Tag] = []
    @State private var addDueDate: Bool = false
    @State private var alertMessage: String = ""
    @State private var toggleAlert: Bool = false
    @State private var toggleConfirmation: Bool = false
    
    var body: some View {
        NavigationStack{
            ScrollView{
                Group{
                    // MARK: - TITLE
                    HStack{
                        Text("New Todo")
                            .font(.system(.title, design: .rounded, weight: .semibold))
                        Spacer()
                        Button(role:.destructive,action: {dismiss()}){
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 15)
                                .frame(maxHeight: 15)
                                .bold()
                        }
                        .padding(.trailing, 5)
                    }
                    
                    // MARK: - TODO TITLE
                    VStack(alignment:.leading){
                        Text("Title of your task")
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal,5)
                        
                        TextField("Title", text: $title)
                            .focused($isFocused)
                            .scrollDismissesKeyboard(.immediately)
                            .padding(10)
                            .frame(maxWidth: Constants.screenWidth - 30)
                            .frame(minHeight: 40)
                            .background(Constants.secondaryColor, in: Constants.circularShape)
                            .submitLabel(.done)
                            .onSubmit {
                                isFocused = false
                            }
                    }
                    .padding(.vertical, 10)
                    
                    // MARK: - TODO DESCRIPTION
                    VStack(alignment:.leading){
                        Text("Description of your task")
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal,5)
                        TextField("Description", text: $desc, axis: .vertical)
                            .focused($isFocused)
                            .textInputAutocapitalization(.sentences)
                            .scrollDismissesKeyboard(.immediately)
                            .padding(10)
                            .frame(maxWidth: Constants.screenWidth - 30)
                            .background(Constants.secondaryColor, in: Constants.circularShape)
                    }
                    .padding(.vertical,10)
                    
                    // MARK: - DUE DATE
                    DueDateFragmentView(dueDate: $dueDate, addDueDate: $addDueDate)
                        .padding(.vertical, 10)
                        .padding(.horizontal, -5)
                    
                    // MARK: - PRIORITY
                    PriorityCapsuleView(selectedPriority: $priority)
                        .padding(.vertical,10)
                }
                .padding(.horizontal)
                // MARK: - TAGS
                TagLazyFragmentView(tagVM: tagVM, selectedTags: $selectedTags)
                    .padding(.vertical, 10)
                
            }
            .scrollIndicators(.never)
            .toolbar{
                if isFocused {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action:{isFocused = false}){
                            Text("Done")
                        }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: finalCheck) {
                        HStack{
                            Text("Todo")
                                .font(.title3)
                            Image(systemName: "note.text.badge.plus")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 40)
                                .frame(maxHeight: 30)
                        }
                        .foregroundColor(.white)
                        .frame(width: Constants.screenWidth - 40)
                        .frame(minHeight: 50)
                        .background(Color.blue, in:.capsule)
                        .padding(.bottom, 15)
                    }
                }
            }
            .confirmationDialog("Leave Description?", isPresented: $toggleConfirmation, titleVisibility: .visible){
                Button(role:.destructive){
                    todoVM.createTodo(title: title, description: nil, priority: priority, dueDate: addDueDate ? dueDate : nil, tags: selectedTags)
                    dismiss()
                } label: {
                    Text("Yes")
                }
            } message: {
                Text("The description serves as a reminder of what you should have done.")
            }
            .alert("Title Issues", isPresented: $toggleAlert) {
                Button(action:{alertMessage = ""}){
                    Text("OK")
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func checkTitle() -> Bool{
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let result = trimmedTitle.isEmpty || trimmedTitle.count < 3
        alertMessage = result ? "Accurate title will be your best navigator." : ""
        return result
    }
    
    func checkDescription() -> Bool {
        let trimmedDesc = desc.trimmingCharacters(in: .whitespacesAndNewlines)
        let result = trimmedDesc.isEmpty
        return result
    }
    
    func finalCheck() {
        if !checkTitle(){
            if !checkDescription(){
                addTodo()
            } else {
                toggleConfirmation.toggle()
            }
        } else {
            toggleAlert.toggle()
        }
    }
    
    func addTodo() {
        todoVM.createTodo(title: title, description: desc, priority: priority, dueDate: addDueDate ? dueDate : nil, tags: selectedTags)
        dismiss()
    }
}

#Preview {
    NavigationStack{
        AddTodoView(todoVM: TodoViewModel(), tagVM: TagViewModel())
    }
}
