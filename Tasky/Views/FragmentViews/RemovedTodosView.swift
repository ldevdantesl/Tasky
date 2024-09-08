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
        ScrollView{
            if !removedTodos.isEmpty{
                ForEach(removedTodos) { todo in
                    TodoRowView(todo: todo, settingsManagerVM: settingsMgrVM, todoVM: todoVM)
                }
                .scrollIndicators(.hidden)
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack{
                            Button("Unremove All", systemImage: "trash.slash.fill", action: {alertToggle.toggle()})
                            Button("Delete All", systemImage: "trash.fill", action: {deleteToggle.toggle()})
                                .tint(.red)
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
            } else {
                VStack{
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
                }
                .padding(.top, Constants.screenHeight / 3)
            }
        }
        .navigationTitle("Removed Todos")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack{
        RemovedTodosView(todoVM: TodoViewModel(), settingsMgrVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
    }
}

