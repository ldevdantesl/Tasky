//
//  SavedTodosView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 11.09.2024.
//

import SwiftUI

struct SavedTodosView: View {
    @ObservedObject var todoVM: TodoViewModel
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    
    @Binding var path: NavigationPath
    
    @State private var alertToggle: Bool = false
    @State private var searchText: String = ""
    
    var savedTodos: [Todo] {
        return todoVM.savedTodos
    }
    
    var body: some View {
        ScrollView{
            if !todoVM.savedTodos.isEmpty{
                ForEach(todoVM.savedTodos){ todo in
                    TodoRowView(todo: todo, settingsManagerVM: settingsMgrVM, todoVM: todoVM)
                        .padding(.horizontal, 10)
                }
            } else {
                NoFoundComponentView(image: "bookmark.fill", color: .green, title: "No Saved Todos", subtitle: "You don't have saved Todos, save any to see it here")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, Constants.screenHeight / 3)
            }
        }
        .background(Color.background)
        .scrollIndicators(.hidden)
        .navigationTitle("Saved Todos")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack{
        SavedTodosView(todoVM: TodoViewModel(), settingsMgrVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
    }
}
