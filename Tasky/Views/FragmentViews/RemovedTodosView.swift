//
//  RemovedTodosView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 24.08.2024.
//

import SwiftUI

struct RemovedTodosView: View {
    @ObservedObject var todoVM: TodoViewModel
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    
    @Binding var path: NavigationPath
    
    @State private var alertToggle: Bool = false
    @State private var deleteToggle = false
    @State private var searchText: String = ""
    
    var removedTodos: [Todo] {
        todoVM.removedTodos
    }
    
    var body: some View {
        VStack{
            SettingsHeaderComponent(settingsMgrVM: settingsMgrVM, path: $path, title: "Removed Todos", buttonItems: [ButtonItem(systemImage: "trash.slash.fill", color: .blue, action: {alertToggle.toggle()}), ButtonItem(systemImage: "trash.fill", color: .red, action: {deleteToggle.toggle()})])
                .padding(.horizontal, 10)
            
            if !removedTodos.isEmpty{
                ScrollView{
                    ForEach(removedTodos) { todo in
                        TodoRowView(todo: todo, settingsManagerVM: settingsMgrVM, todoVM: todoVM)
                    }
                }
                .scrollIndicators(.hidden)
            } else {
                VStack{
                    Spacer()
                    Image(systemName: "trash.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.red)
                    Text("No deleted todos")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                    Text("You don't have deleted Todos, delete any to see it here")
                        .font(.system(.caption, design: .rounded, weight: .light))
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
            
        }
        .alert("Unremove All", isPresented: $alertToggle){
            Button("Unremove", role:.destructive, action: todoVM.unRemoveAll)
        } message: {
            Text("Do you really want to Unremove all?")
        }
        .alert("Delete All", isPresented: $deleteToggle){
            Button("Delete all", role:.destructive, action: todoVM.deleteAllRemovedTodos)
        } message: {
            Text("Do you really want to delete all removed Todos?")
        }
    }
}

#Preview {
    NavigationStack{
        RemovedTodosView(todoVM: TodoViewModel(), settingsMgrVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
    }
}

