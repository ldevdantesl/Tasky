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
    
    @Binding var path: NavigationPath
    
    @State private var showAlert: Bool = false
    @State private var editingTitle: String = ""
    @State private var editingDesc: String = ""
    @State private var editingPriority: Int16 = 0
    @State private var editingDueDate: Date? = .now
    @State private var editingTags: [Tag]? = []
    
    init(observedTodo: Todo, todoVM: TodoViewModel, tagVM: TagViewModel, settingsManagerVM: SettingsManagerViewModel, path: Binding<NavigationPath>){
        _todo = ObservedObject(wrappedValue: observedTodo)
        self.todoVM = todoVM
        self.tagVM = tagVM
        self.settingsManagerVM = settingsManagerVM
        self._path = path
    }
    
    var body: some View {
        ScrollView{
            
        }
        .onAppear{
            editingTitle = todo.title ?? ""
            editingDesc = todo.desc ?? ""
            editingPriority = todo.priority
            editingTags = todo.tags?.allObjects as? [Tag] ?? []
        }
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
        .scrollIndicators(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                Text(todo.title ?? "")
                    .font(.system(.headline, design: .rounded, weight: .bold))
            }
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
                            todoVM.archive(todo)
                            dismiss()
                        }
                    }
                    Button("Delete",systemImage: "trash.fill", action: {showAlert.toggle()})
                        .tint(.red)
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        TodoDetailView(observedTodo: TodoViewModel.mockToDo(), todoVM: TodoViewModel(), tagVM: TagViewModel(), settingsManagerVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
    }
}
