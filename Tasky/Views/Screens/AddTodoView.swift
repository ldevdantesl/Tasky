//
//  AddTodoView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import SwiftUI

struct AddTodoView: View {
    @ObservedObject var todoVM = TodoViewModel()
    @FocusState var focusedField: Field?
    @State private var title: String = ""
    @State private var desc: String = ""
    @State private var priority: Int16 = 2
    @State private var alertMessage: String?
    
    @Binding var toggleView: Bool
    
    enum Field: Hashable{
        case title
        case description
    }
    
    var body: some View {
        NavigationStack{
            ScrollView{
                // MARK: - TITLE
                HStack{
                    Text("New Todo")
                        .font(.system(.title, design: .rounded, weight: .semibold))
                    Spacer()
                    Button(role:.destructive,action: {toggleView.toggle()}){
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
                    
                    TextField(text: $title, axis: .horizontal){
                        Text("Title")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                    }
                    .focused($focusedField, equals: .title)
                    .onSubmit {
                        focusedField = .description
                    }
                    .submitLabel(.next)
                    .autocorrectionDisabled()
                    .padding(10)
                    .frame(maxWidth: Constants.screenWidth)
                    .frame(minHeight: 40)
                    .background(Constants.secondaryColor, in: Constants.circularShape)
                }
                .padding(.vertical, 10)
                
                // MARK: - TODO DESCRIPTION
                VStack(alignment:.leading){
                    Text("Description of your task")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal,5)
                    TextField(text: $desc, axis: .vertical){
                        Text("Description")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                    }
                    .toolbar{
                        ToolbarItem(placement: .keyboard) {
                            Button(action:{ focusedField = nil }){
                                Text("Done")
                            }
                        }
                    }
                    .focused($focusedField, equals: .description)
                    .submitLabel(.return)
                    .autocorrectionDisabled()
                    .padding(10)
                    .frame(maxWidth: Constants.screenWidth)
                    .frame(minHeight: 40)
                    .background(Constants.secondaryColor, in: Constants.circularShape)
                }
                .padding(.vertical,10)
                
                // MARK: - PRIORITY
                PriorityCapsuleView(selectedPriority: $priority)
                    .padding(.vertical,10)
            }
            .padding()
            .toolbar{
                ToolbarItem(placement: .bottomBar) {
                    Button(action: addTodo) {
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
                    }
                    .frame(maxWidth: Constants.screenWidth)
                    .frame(minHeight: 50)
                    .background(Color.blue, in:.capsule)
                }
            }
        }
    }
    
    func checkInputs() -> Bool{
        if title.isEmpty || title.count < 3 {
            alertMessage = "Title is not valid"
            return false
        }
        if desc.isEmpty { return false }
        return true
    }
    
    func addTodo() {
        todoVM.createTodo(title: title, description: desc, priority: priority)
        todoVM.fetchTodos()
        toggleView.toggle()
    }
}

#Preview {
    NavigationStack{
        AddTodoView(toggleView: .constant(true))
    }
}
