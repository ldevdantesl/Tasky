//
//  AddTodoView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import SwiftUI

struct AddTodoView: View {
    
    enum FocusedFields{
        case title
        case description
    }
    
    @ObservedObject var todoVM: TodoViewModel
    @ObservedObject var tagVM: TagViewModel
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    @Binding var path: NavigationPath
    @FocusState var focusedField: FocusedFields?
    
    @State private var title: String = ""
    @State private var desc: String = ""
    @State private var priority: Int16 = 2
    @State private var dueDate: Date?
    @State private var selectedTags: [Tag] = []
    @State private var addDueDate: Bool = false
    @State private var titleErrorMessage: String?
    @State private var dateErrorMessage: String?
    @State private var showProgressView: Bool = false
    
    var colorTheme: Color {
        return settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    var body: some View {
        ScrollView{
            // MARK: - TITLE
            HStack{
                Text("New Todo")
                    .font(.system(.title, design: .rounded, weight: .semibold))
                    .foregroundStyle(Constants.textColor)
                Spacer()
                Button(action: {path.removeLast()}){
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 25)
                        .frame(maxHeight: 25)
                }
                .padding(.trailing, 5)
                .tint(Constants.secondaryColor)
            }
            .padding(.bottom, 15)
            .padding(.horizontal)
            
            // MARK: - TODO TITLE
            VStack(alignment:.leading){
                Text("Title")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(Constants.secondaryColor)
                    .padding(.horizontal,5)
                
                TextFieldComponent(text: $title, placeholder: "Title", maxChars: 30)
                    .focused($focusedField, equals: .title)
                    .scrollDismissesKeyboard(.immediately)
                    .frame(maxWidth: Constants.screenWidth - 30)
                    .frame(height: 40)
                    .background(Constants.textFieldColor, in: .capsule)
                    .submitLabel(.done)
                    .onSubmit {
                        focusedField = nil
                    }
                    .shadow(color: Color.black.opacity(focusedField == .title ? 0.2 : 0), radius: 10, x: 0, y: 5)
                
                if let titleErrorMessage, title.count <= 3 {
                    Text(titleErrorMessage)
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                        .foregroundStyle(.red.opacity(0.8))
                        .padding(.horizontal, 7)
                }
            }
            .padding(.bottom, 15)
            .padding(.horizontal)
            
            // MARK: - TODO DESCRIPTION
            VStack(alignment:.leading){
                Text("Description(optional)")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(Constants.secondaryColor)
                    .padding(.horizontal,5)
                TextField("Description", text: $desc, axis: .vertical)
                    .focused($focusedField, equals: .description)
                    .scrollDismissesKeyboard(.immediately)
                    .padding(10)
                    .frame(maxWidth: Constants.screenWidth - 30)
                    .background(Constants.textFieldColor, in: .capsule)
                    .shadow(color: Color.black.opacity(focusedField == .description ? 0.2 : 0), radius: 10, x: 0, y: 5)
            }
            .padding(.bottom,15)
            .padding(.horizontal)
            
            // MARK: - DUE DATE
            DueDateFragmentView(settingsMgrVM: settingsMgrVM, dueDate: $dueDate, dateErrorMessage: $dateErrorMessage)
                .padding(.horizontal, 20)
                .padding(.bottom, 15)
            
            // MARK: - PRIORITY
            PriorityCapsuleView(selectedPriority: $priority)
                .padding(.bottom,15)
            
            // MARK: - TAGS
            TagLazyFragmentView(tagVM: tagVM, selectedTags: $selectedTags)
                        
        }
        .background(Constants.backgroundColor)
        .scrollIndicators(.never)
        .toolbar{
            ToolbarItem(placement: .bottomBar) {
                Button(action: save){
                    Text("Add + ")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: Constants.screenWidth - 40, height: 50)
                        .background(colorTheme, in: .capsule)
                }
            }
        }
        .overlay{
            if showProgressView {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(width: 100, height: 100)
                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 25))
            }
        }
        .disabled(showProgressView)
        .onTapGesture {
            if focusedField == .description {
                focusedField = nil
            }
        }
        .onAppear {
            focusedField = .title
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    func save() {
        showProgressView = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            withAnimation {
                if title.count > 2 && title.trimmingCharacters(in: .whitespaces).count > 2 && dueDate != nil {
                    todoVM.createTodo(title: title, description: desc.isEmpty ? nil : desc, priority: priority, dueDate: dueDate, tags:selectedTags)
                    withAnimation {
                        showProgressView = false
                        path.removeLast()
                    }
                } else {
                    withAnimation {
                        if title.count < 2{
                            titleErrorMessage = "Title should be more than 2 characters"
                        } else if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            titleErrorMessage = "Title can't only be the spaces"
                        }
                        if dueDate == nil{
                            dateErrorMessage = "Specify a day"
                        }
                        showProgressView = false
                    }
                }
            }
        }
        
    }
}

#Preview {
    NavigationStack{
        AddTodoView(todoVM: TodoViewModel(), tagVM: TagViewModel(), settingsMgrVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
    }
}
