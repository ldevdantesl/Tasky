//
//  ArchivedOrRemovedView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 24.08.2024.
//

import SwiftUI

struct ArchivedTodosView: View {
    @ObservedObject var todoVM: TodoViewModel
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    
    @State private var alertToggle: Bool = false
    @State private var searchText: String = ""
    
    var archivedTodos: [Todo] {
        return todoVM.archivedTodos
    }
    
    var body: some View {
        ScrollView{
            if !archivedTodos.isEmpty{
                ForEach(archivedTodos){ todo in
                    Menu {
                        Button("Unarchive", systemImage: "archivebox.circle.fill"){
                            withAnimation {
                                todoVM.unArchive(todo)
                            }
                        }
                    } label: {
                        TodoRowView(todo: todo, settingsManagerVM: settingsMgrVM, todoVM: todoVM)
                            .padding(.horizontal, 10)
                    }
                }
            } else {
                NoFoundComponentView(image: "archivebox.fill", color: .green, title: "No archived Todos", subtitle: "You don't have archived Todos, archive any to see it here")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, Constants.screenHeight / 3)
            }
        }
        .toolbar {
            if !archivedTodos.isEmpty{
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Archive", systemImage: "archivebox.fill", action: {alertToggle.toggle()})
                }
            }
        }
        .alert("Unarchive All", isPresented: $alertToggle){
            Button("Unarchive", role:.destructive, action: todoVM.unArchiveAll)
        } message: {
            Text("Do you really want to Unarchive all?")
        }
        .background(Color.background)
        .scrollIndicators(.hidden)
        .navigationTitle("Archived Todos")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack{
        ArchivedTodosView(todoVM: TodoViewModel(), settingsMgrVM: MockPreviews.viewModel)
    }
}
